import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareInfo.dart';
import 'package:intl/intl.dart';

class ManagerPage extends StatefulWidget {
  final VoidCallback onToggleManagerPage;
  final List<ShareInfo> shareInfoList;

  const ManagerPage({Key? key, required this.onToggleManagerPage, required this.shareInfoList})
      : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}


class _ManagerPageState extends State<ManagerPage> {

  selectedManageElement _onSelectedManageElement = selectedManageElement.share;
  completedState _completedState = completedState.waiting;

  bool _openShareImage = false;
  bool _post = false;
  String _openBrandName = '';
  String _openBranchName = '';
  String _storeAddress = '';
  String _storePhoneNumber = '';
  String _openImageUrl = '';
  String _getShareImageId = '';
  String _imageFileName = '';

  late TextEditingController _brandNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _storeAddressController;
  late TextEditingController _storePhoneNumberController;

  late List<ShareInfo> _shareInfoList;

  String formatTimestampToKST(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();

    // 한국 시간대(KST)로 설정
    dateTime = dateTime.add(Duration(hours: 9));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void getShareInfoDetails() {
    for (var shareInfo in _shareInfoList) {
      if (shareInfo.id == _getShareImageId) {
        setState(() {
          _openBrandName = shareInfo.brandName;
          _openBranchName = shareInfo.branchName;
          _openImageUrl = shareInfo.imageUrl;
          _post = shareInfo.post;
        });
        break; // 일치하는 요소를 찾았으므로 루프 종료
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _shareInfoList = widget.shareInfoList;
  }

  // 파이어베이스 & dart 리스트 업데이트 함수
  Future<void> updateShareSaleImage() async {
    try {
      await FirebaseFirestore.instance.collection('shareSaleImage').doc('${_getShareImageId}').update({
        'brandName': _brandNameController.text,
        'branchName': _branchNameController.text,
        'storeAddress': _storeAddressController.text,
        'storePhoneNumber': _storePhoneNumberController.text,
        'post' : _post,
      });

      updateShareInfoList();

    } catch (e) {
      // 에러 처리
    }
  }

  void updateShareInfoList() {
    List<ShareInfo> updatedList = List<ShareInfo>.from(_shareInfoList);
    for (var i = 0; i < updatedList.length; i++) {
      if (updatedList[i].id == _getShareImageId) {
        ShareInfo currentInfo = updatedList[i];
        updatedList[i] = ShareInfo(
          id: currentInfo.id,
          brandName: _brandNameController.text,
          branchName: _branchNameController.text,
          storeAddress: _storeAddressController.text,
          storePhoneNumber: _storePhoneNumberController.text,
          post: _post,
          fileName: currentInfo.fileName,
          imageUrl: currentInfo.imageUrl,
          discount: currentInfo.discount,
          condition: currentInfo.condition,
          timestamp: currentInfo.timestamp,
        );
        break;
      }
    }

    setState(() {
      _shareInfoList = updatedList;
    });
  }

  // 문서 삭제함수
// Firestore 문서 삭제 및 Storage 이미지 삭제
  Future<void> deleteShareSaleImageDocument() async {
    try {
      // Firestore에서 문서 삭제
      await FirebaseFirestore.instance
          .collection('shareSaleImage')
          .doc(_getShareImageId)
          .delete();

      // 성공적으로 문서가 삭제되었을 때 Storage에서 이미지도 삭제

      print(_imageFileName);

      await deleteImageFromStorage(_imageFileName);

      // 성공적으로 문서와 이미지가 삭제되었을 때의 처리 로직
      deleteShareInfoFromList();

    } catch (e) {
      // 오류 처리 로직
      print("Firestore or Storage 삭제 중 오류 발생: $e");
    }
  }

  //스토리지 내의 사진 삭제
  Future<void> deleteImageFromStorage(String fileName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('sharedSaleImage/$fileName');

    try {
      await ref.delete();
      print('Storage: Image deleted successfully');
    } catch (e) {
      print('Storage: Error occurred while deleting the image: $e');
    }
  }


  // 리포트 Future
  Future<QuerySnapshot>? _futureReportSharedInfo;

  Future<QuerySnapshot> getReportSharedInfo() {
    return FirebaseFirestore.instance.collection('reportSharedInfo').get();
  }

  void deleteShareInfoFromList() {
    int? indexToDelete;

    for (int i = 0; i < _shareInfoList.length; i++) {
      if (_shareInfoList[i].id == _getShareImageId) {
        indexToDelete = i;
        break;
      }
    }

    if (indexToDelete != null) {
      setState(() {
        _shareInfoList.removeAt(indexToDelete!);
      });
    }
  }

  // 리포트 확인값
  bool checkDoc = false;

  // 체크에서 실행시킬 콜백함수
  void refreshReportSharedInfo() {
    setState(() {
      _futureReportSharedInfo = getReportSharedInfo();
    });
  }

  @override
  void dispose() {
    _brandNameController.dispose();
    _branchNameController.dispose();
    _storeAddressController.dispose();
    _storePhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
            child: Column(
              children: [

                // 앱바
                Container(
                  width: double.maxFinite,
                  height: 60,
                  color: Color(0xffff5f5f5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: widget.onToggleManagerPage,
                            child: Icon(Icons.chevron_left)),
                      ],
                    ),
                  ),
                ),
                // 관리 선택
                Container(
                  width: double.maxFinite,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xffcdcdcd), // 선의 색상을 지정하세요.
                        width: 1.0, // 선의 두께를 지정하세요.
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _onSelectedManageElement = selectedManageElement.share;
                              _completedState = completedState.waiting;
                            });
                          },
                          child: Text(
                            '공유 관리',
                            style: TextStyle(
                              fontSize: 14,
                              color: _onSelectedManageElement ==
                                  selectedManageElement.share
                                  ? Color(0xff000000)
                                  : Color(0xffcdcdcd),
                              fontFamily: "GmarketSansMedium",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '|',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffcdcdcd),
                              fontFamily: "GmarketSansMedium",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            _futureReportSharedInfo = getReportSharedInfo();

                            setState(() {
                              _onSelectedManageElement = selectedManageElement.report;
                              _completedState = completedState.waiting;
                            });
                          },
                          child: Text(
                            '리포트',
                            style: TextStyle(
                              fontSize: 14,
                              color: _onSelectedManageElement ==
                                  selectedManageElement.report
                                  ? Color(0xff000000)
                                  : Color(0xffcdcdcd),
                              fontFamily: "GmarketSansMedium",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 처리 여부
                Container(
                  width: double.maxFinite,
                  height: 60,
                  color: Color(0xffffffff),
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _completedState = completedState.waiting;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _completedState == completedState.waiting ? Color(0xfffa6565) :Color(0xfff5f5f5),
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Color(0xffcdcdcd)))),
                              child: Center(child: Text('처리 대기')),
                            ),
                          )),
                      Expanded(
                          child: GestureDetector(
                            onTap : () {
                              setState(() {
                                _completedState = completedState.completed;
                              });
                            },
                            child: Container(
                              color: _completedState == completedState.completed ? Color(0xfffa6565) : Color(0xfff5f5f5),
                              child: Center(child: Text('처리 완료')),
                            ),
                          )),
                    ],
                  ),
                ),

                _onSelectedManageElement == selectedManageElement.share ? Expanded(
                  child: ListView.builder(
                    itemCount: _shareInfoList.length,
                    itemBuilder: (context, index) {
                      // 현재 상태와 post 값에 따라 표시할 항목 결정
                      bool _shouldDisplayItem = (_completedState == completedState.waiting && !_shareInfoList[index].post) ||
                          (_completedState == completedState.completed && _shareInfoList[index].post);

                      if (_shouldDisplayItem) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _openShareImage = true;
                              _openBrandName = _shareInfoList[index].brandName;
                              _openBranchName = _shareInfoList[index].branchName;
                              _openImageUrl = _shareInfoList[index].imageUrl;
                              _getShareImageId = _shareInfoList[index].id;
                              _imageFileName = _shareInfoList[index].fileName;
                              _post = _shareInfoList[index].post;

                              _brandNameController = TextEditingController(text: _openBrandName);
                              _branchNameController = TextEditingController(text: _openBranchName);
                              _storeAddressController = TextEditingController();
                              _storePhoneNumberController = TextEditingController();
                            });
                          },
                          child: Container(
                            width: double.maxFinite,
                            height: 64,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xffcdcdcd),
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${formatTimestampToKST(_shareInfoList[index].timestamp)}', style: TextStyle(fontSize: 16,),),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink(); // 빈 위젯 반환
                      }
                    },
                  ),
                ) : SizedBox(),

                // 리포트 관리내용
                _onSelectedManageElement == selectedManageElement.report
                    ? Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: _futureReportSharedInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();// 로딩 중 표시
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('오류가 발생했습니다.')); // 에러 표시
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('데이터가 없습니다.')); // 데이터 없음 표시
                      }

                      // 데이터가 있는 경우 ListView.builder로 목록 표시

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          String reportDocId = doc.id;
                          checkDoc = doc['check'];

                          bool _shouldDisplayItem = (_completedState == completedState.waiting && !checkDoc) ||
                              (_completedState == completedState.completed && checkDoc);

                          if(_shouldDisplayItem) {
                            return GestureDetector(
                              onTap : () {

                                setState(() {
                                  _getShareImageId = doc['docId'];
                                  _openShareImage = true;

                                  _brandNameController = TextEditingController(text: _openBrandName);
                                  _branchNameController = TextEditingController(text: _openBranchName);
                                  _storeAddressController = TextEditingController();
                                  _storePhoneNumberController = TextEditingController();

                                });

                                //해당하는 id의 문서값들을 가져옵니다.
                                getShareInfoDetails();
                              },
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Color(0xffcdcdcd)
                                    ),

                                    color: Color(0xffffffff)
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${formatTimestampToKST(doc['timestamp'])}'),
                                        Spacer(),
                                        CheckIconWidget(reportDocId: reportDocId, initialCheck: checkDoc, futureReportSharedInfo: _futureReportSharedInfo!, onRefresh: refreshReportSharedInfo,),
                                      ],
                                    ),
                                    if(doc['reason'] == 'ReportReason.BrandMismatch') Text('사유 : 브랜드명이 달라요.')
                                    else if(doc['reason'] == 'ReportReason.BranchMismatch') Text('사유 : 지점명이 달라요.')
                                    else Text('사유 : 이미지가 정상적이지 않아요.')
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }

                        },
                      );
                    },
                  ),
                )
                    : SizedBox(),
              ],
            ),
          ),

          _openShareImage == true ? Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 60,
                    color: Color(0xffff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap : () {
                                setState(() {
                                  _openShareImage = false;
                                });
                              },
                              child: Icon(Icons.chevron_left)),

                          Spacer(),

                          GestureDetector(
                            onTap: () {

                              Future.delayed(Duration.zero).then((value) {
                                updateShareSaleImage();
                              }).then((value) {
                                setState(() {
                                  _openShareImage = false;
                                });
                              });

                            },
                            child: Container(
                              width:  72,
                              height: 64,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xfff5f5f5)
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                  color: Color(0xfffa6565)
                              ),
                              child: Center(child: Text('완료', style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xfff5f5f5)
                              ),)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.maxFinite,
                    height: 360,
                    child: CachedNetworkImage(
                      imageUrl: _openImageUrl,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),


                  SizedBox(
                    height: 16,
                  ),

                  Row(
                    children: [

                      SizedBox(
                        width: 12,
                      ),

                      Text('삭제하기 '),
                      SizedBox(
                        width: 6,
                      ),

                      IconButton(onPressed: () {
                        deleteShareSaleImageDocument();

                        setState(() {
                          _openShareImage = false;
                        });
                      }, icon: Icon(Icons.delete)),

                      Spacer(),



                      Text('게시 여부'),

                      SizedBox(
                        width: 6,
                      ),

                      IconButton(
                        icon: Icon(
                          _post ? Icons.toggle_on : Icons.toggle_off, // _post 값에 따라 아이콘 변경
                          color: _post ? Colors.green : Colors.grey,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            _post = !_post; // _post 값을 토글
                          });
                        },
                      ),

                      SizedBox(
                        width: 12,
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _brandNameController,
                      decoration: InputDecoration(
                        labelText: '브랜드명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _openBrandName = value;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _branchNameController,
                      decoration: InputDecoration(
                        labelText: '지점명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _openBranchName = value;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _storeAddressController,
                      decoration: InputDecoration(
                        labelText: '주소입력',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _storeAddress = value;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _storePhoneNumberController,
                      decoration: InputDecoration(
                        labelText: '가게 전화번호',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _storePhoneNumber = value;
                      },
                    ),
                  ),

                ],
              ),
            ),
          ) : SizedBox(),

        ],
      ),
    );
  }
}

// 리포트 check 값 따로 관리
class ReportListItem extends StatefulWidget {
  final DocumentSnapshot doc;
  final String reportDocId;

  ReportListItem({Key? key, required this.doc, required this.reportDocId}) : super(key: key);

  @override
  _ReportListItemState createState() => _ReportListItemState();
}

class _ReportListItemState extends State<ReportListItem> {
  bool checkDoc;

  _ReportListItemState() : checkDoc = false;

  @override
  void initState() {
    super.initState();
    checkDoc = widget.doc['check'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await FirebaseFirestore.instance
              .collection('reportSharedInfo')
              .doc(widget.reportDocId)
              .update({'check': !checkDoc});

          setState(() {
            checkDoc = !checkDoc; // 상태를 올바르게 토글
          });
        } catch (e) {
          print('Firestore 업데이트 실패: $e');
        }
      },
      // 위젯 구성
    );
  }
}

// checkIcon만 setState되게끔 분리
class CheckIconWidget extends StatefulWidget {
  final String reportDocId;
  final bool initialCheck;
  final Future<QuerySnapshot> futureReportSharedInfo;
  final VoidCallback onRefresh;
  CheckIconWidget({Key? key, required this.reportDocId, required this.initialCheck, required this.futureReportSharedInfo, required this.onRefresh}) : super(key: key);

  @override
  _CheckIconWidgetState createState() => _CheckIconWidgetState();
}

class _CheckIconWidgetState extends State<CheckIconWidget> {
  late bool checkDoc;

  @override
  void initState() {
    super.initState();
    checkDoc = widget.initialCheck;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await FirebaseFirestore.instance
              .collection('reportSharedInfo')
              .doc(widget.reportDocId)
              .update({'check': !checkDoc});

          setState(() {
            checkDoc = !checkDoc;
          });

          widget.onRefresh();

        } catch (e) {
          print('Firestore 업데이트 실패: $e');
        }
      },
      child: Icon(
        Icons.check,
        color: checkDoc ? Colors.greenAccent : Color(0xffcdcdcd),
      ),
    );
  }
}

enum selectedManageElement {
  share,
  report,
}

enum completedState {
  waiting,
  completed,
}
