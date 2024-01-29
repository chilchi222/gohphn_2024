import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/Filter/koreaCitiesAndDistricts.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareInfo.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareHomeTownChickenSale extends StatefulWidget {
  final List<ShareInfo> shareInfoList;
  final String selectedCity;
  final String selectedDistrict;
  final String location;

  const ShareHomeTownChickenSale({Key? key,

    required this.shareInfoList,
    required this.selectedCity,
    required this.selectedDistrict,
    required this.location,

  }) : super(key: key);

  @override
  State<ShareHomeTownChickenSale> createState() => _ShareHomeTownChickenSaleState();
}

class _ShareHomeTownChickenSaleState extends State<ShareHomeTownChickenSale> with SingleTickerProviderStateMixin {

  final userPhoneNumberNotifier = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();

    //필터
    filterList();
    _searchFilter.addListener(_onSearchChanged);
    _location = widget.location;
    _selectedCity = widget.selectedCity;
    _selectedDistrict = widget.selectedDistrict;
  }

  // 페이지가 처음 열릴 때, 지역필터링
  void filterList() {

    if (widget.location == "전체") {

      setState(() {
        filteredList = widget.shareInfoList;
      });

    } else {

      setState(() {
        filteredList = widget.shareInfoList.where((item) => item.storeAddress.toLowerCase().replaceAll(' ', '').contains(widget.location.toLowerCase().replaceAll(' ', ''))).toList();
      });
    }

  }


  @override
  void dispose() {
    // 컨트롤러들을 dispose하여 메모리 누수를 방지합니다.
    _brandNameController.dispose();
    _branchNameController.dispose();
    _searchFilter.dispose();
    super.dispose();
  }


  bool _isLoading = false;
  bool _imageLoading = false;

  // 유저 공유 이미지 열기
  bool _openShareImage = false;
  String _openBrandName = '';
  String _openBranchName = '';
  String _openImageUrl = '';
  String _openDiscount = '';
  String _openCondition = '';
  String _getShareImageId = '';

  // 이미지 파일 선택 & 카메라 열기

  bool _openShareEditPageImage = false;
  bool _openShareEditPageDirectInput = false;

  String? _selectedFileName;
  Uint8List? _imageData;
  late Uint8List _compressedImageData;

  Future<void> pickImage() async {
    // 이미지 선택
    final Uint8List? imageData = await ImagePickerWeb.getImageAsBytes();
    if (imageData != null) {

      // 원본파일 압축
      // final Uint8List? resizedImageData = await resizeImageToTenPercent(imageData);

      if (imageData != null) {
        setState(() {
          _imageData = imageData; // 여기에서 조정된 이미지 데이터를 저장
          // 파일 이름을 생성 (예: 현재 날짜 및 시간)
          _selectedFileName = 'image_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.jpg';
        });
      }
    }
  }

  Future<Uint8List?> resizeImageToTenPercent(Uint8List imageData) async {
    // 이미지 데이터를 Image 객체로 디코딩합니다.
    img.Image? image = img.decodeImage(imageData);
    if (image == null) return null;

    // 원본 이미지의 너비와 높이의 72%를 계산합니다.
    int newWidth = (image.width * 0.72).round();
    int newHeight = (image.height * 0.72).round();

    // 이미지 크기를 조정합니다.
    img.Image resized = img.copyResize(image, width: newWidth, height: newHeight);

    // 조정된 이미지를 JPEG 포맷으로 인코딩합니다.
    return Uint8List.fromList(img.encodeJpg(resized, quality: 100));
  }

  Future<void> uploadImage(String brandName, String branchName, String selectedFileName) async {
    if (_imageData == null) {
      return;
    }

    // 파일 이름 설정 (현재 날짜 + 이미지 파일명)
    String fileName = '${_selectedFileName!}';
    String filePath = 'sharedSaleImage/$fileName';


    // Firebase Storage - 원본 저장
    Reference ref = FirebaseStorage.instance.ref().child(filePath);

    // 데이터 업로드
    try {

      // 이미지 다운로드 url
      UploadTask uploadTask = ref.putData(_imageData!);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadURL = await snapshot.ref.getDownloadURL();

      // Firestore에 URL 저장
      await FirebaseFirestore.instance.collection('shareSaleImage').add({
        'brandName' : brandName,
        'branchName' : branchName,
        'fileName' : selectedFileName,
        'imageUrl': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),

        // 틀
        'storePhoneNumber' : '',
        'storeAddress' : '',
        'post' : false,
        'discount' : '',
        'condition' : '',
      });

      print('업로드 완료');

    } catch (e) {
      // 에러 처리
      print(e);
    }
  }

  // 유저가 사진이 없는 경우
  Future<void> uploadDirectInput(String brandName, String branchName, String discount, discountCondition discountCondition) async {

    try {

      // Firestore에 URL 저장
      await FirebaseFirestore.instance.collection('shareSaleImage').add({
        'brandName' : brandName,
        'branchName' : branchName,
        'discount' : discount,
        'condition' : discountCondition.toString(),
        'timestamp': FieldValue.serverTimestamp(),

        // 틀
        'storePhoneNumber' : '',
        'storeAddress' : '',
        'post' : false,
        'fileName' : '',
        'imageUrl': '',

      });

      print('업로드 완료');

    } catch (e) {
      // 에러 처리
      print(e);
    }
  }






  // 브랜드명&지점명 텍스트필드
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String _brandName = '';
  String _branchName = '';
  String _discount = '';

  discountCondition? _discountCondition = discountCondition.pickUp;

  // 제출완료 페이지
  bool _completedSubmit = false;

  // 정보가 달라요! 리포트 페이지
  bool _openReport = false;
  ReportReason? _selectedReason;

  void _reportToFirestore(String getShareImageId, ReportReason reason) {
    var report = {
      'docId' : getShareImageId,
      'check' : false,
      'reason': reason.toString(),
      'timestamp': FieldValue.serverTimestamp(), // 현재 시간
    };

    FirebaseFirestore.instance.collection('reportSharedInfo').add(report).then((docRef) {
      print('Report submitted with ID: ${docRef.id}');
    }).catchError((error) {
      print('Error submitting report: $error');
    });
  }





  // 검색필터
  Timer? _debounce;
  final TextEditingController _searchFilter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = '';

  List<ShareInfo> filteredList = [];


  // 이 작업은 검색어를 입력할 때마다 깜빡거리는 것을 줄이기 위해서 추가되었습니다.
  // 검색어 입력할 때마다 타이머 실행 (입력될 때마다 타이머가 취소되었다가 다시 설정됩니다)
  // 입력이 중단되고, 타이머 시간이 다 흐르면 필터함수 실행
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      filterSearchResults(_searchFilter.text);
    });
  }

  void filterSearchResults(String query) {
    // 첫 번째 필터링: _location에 따라 필터링
    List<ShareInfo> tempList;
    if (_location == '전체') {
      tempList = List.from(widget.shareInfoList); // _location이 '전체'이면 모든 항목을 포함
    } else {
      tempList = widget.shareInfoList.where((item) {
        return item.storeAddress.contains(_location.trim());
      }).toList(); // _location이 '전체'가 아니면 storeAddress에 _location이 포함된 항목만 포함
    }

    // 두 번째 필터링: 검색 쿼리에 따라 필터링
    List<ShareInfo> dummySearchList = [];
    tempList.forEach((item) {
      if (item.brandName.toLowerCase().contains(query.toLowerCase()) ||
          item.branchName.toLowerCase().contains(query.toLowerCase())) {
        dummySearchList.add(item);
      }
    });

    setState(() {
      filteredList = dummySearchList; // 최종 필터링된 리스트로 filteredList 업데이트
    });
  }

  // 지역필터
  bool _openLocationFilter = false;
  bool _notification = false;

  // 기본 설정 값
  String selectedValue = '전체';
  String selectedBrand = '';

  // 지역 필터 관련 변수
  String? _selectedCity;
  String? _selectedDistrict;
  String _location = '';
  List<ShareInfo> _filterData = [];

  // 지역 설정을 위한 함수
  Future<void> saveSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    String? storedCity = prefs.getString('selectedCity');
    String? storedDistrict = prefs.getString('selectedDistrict');

    if (_location == '전체' && _selectedCity != '서울') {
      _selectedCity = '서울';
    }

    // 값이 저장소에 없거나 변경되었으면 새로 저장
    if (storedCity != _selectedCity || storedDistrict != _selectedDistrict) {

      // SharedPreferences에 새로운 값을 저장
      await prefs.setString('selectedCity', _selectedCity ?? '전체');

      if (_selectedDistrict != null) {
        await prefs.setString('selectedDistrict', _selectedDistrict!);
      }

      // Firestore에 저장
      String location = '$_selectedCity $_selectedDistrict';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('locationCounting')
          .where('selectedLocation', isEqualTo: location)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('locationCounting')
            .doc(docId)
            .update({'count': FieldValue.increment(1)});
      } else {
        FirebaseFirestore.instance.collection('locationCounting').add({
          'selectedLocation': location,
          'count': 1,
        });
      }
    }
  }

  // SharedPreferences에서 저장된 지역 정보를 불러오는 함수
  Future<void> getUpdatedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String selectedCity = prefs.getString('selectedCity') ?? '전체';
    String selectedDistrict = prefs.getString('selectedDistrict') ?? '';
    String location = selectedCity == '전체' ? '전체' : '$selectedCity $selectedDistrict';

    _location = location;

    setState(() {
      if (_location == '전체') {
        filteredList = List.from(widget.shareInfoList);
      } else {
        filteredList = widget.shareInfoList.where((item) =>
            item.storeAddress
                .toLowerCase().replaceAll(' ', '')
                .contains(location.toLowerCase().replaceAll(' ', ''))
        ).toList();
      }
    });
  }
  
  //알림 받기 - 휴대폰번호 남기기
  TextEditingController phoneNumberController = TextEditingController();
  String phoneNumber = '';
  bool completedSendPhoneNumber = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 60,
                  color: Color(0xfff5f5f5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // GestureDetector(
                        //     onTap : () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: Text('뒤로가기',)),

                        Spacer(),


                        GestureDetector(
                            onTap : () {
                              setState(() {
                                _openShareEditPageImage = true;
                              });
                            },
                            child: Text('업로드 하기',)),
                    ],
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border : Border(
                        top: BorderSide(
                            width: 1,
                            color: Color(0xffd4d4d4)
                        ),
                      bottom: BorderSide(
                        width: 1,
                        color: Color(0xffd4d4d4)
                      )
                    ),
                    color: Color(0xfff5f5f5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: TextStyle(
                            fontSize: 15
                          ),
                          autofocus: false,
                          controller: _searchFilter,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white12,
                            prefixIcon: Icon(Icons.search,
                              color: Colors.black,
                              size: 20,
                            ),
                            suffixIcon: focusNode.hasFocus
                                ? IconButton(onPressed: () {
                                  setState(() {
                                    _searchFilter.clear();
                                    _searchText = '';
                                  });
                            }, icon : Icon(Icons.cancel, size: 20,))
                                : SizedBox(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              // borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              // borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            border : OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              // borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            hintText: "검색",
                            // hintStyle: TextStyle(color: Color(0xffffffff)),
                            labelStyle: TextStyle(color: Colors.white)
                          ),
                        ),
                      ),
                      focusNode.hasFocus
                          ? TextButton(onPressed: () {
                            setState(() {
                              _searchFilter.clear();
                              _searchText = "";
                              focusNode.unfocus();
                            });

                      },

                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        child: Center(child: Text('취소')),)
                          : Container(),

                      SizedBox(
                        width: 12,
                      ),

                      GestureDetector(
                        onTap : () {
                          setState(() {
                            _openLocationFilter = true;
                          });

                        },
                        child: Container(
                          width: 72,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xfffa6565),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Center(child: Text('지역 필터', style: TextStyle(color: Color(0xffffffff)),)),
                        ),

                      ),

                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredList.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {

                            _openShareImage = true;
                            _openBrandName = filteredList[index].brandName;
                            _openBranchName = filteredList[index].branchName;
                            _openImageUrl = filteredList[index].imageUrl;
                            _getShareImageId = filteredList[index].id;

                            _openDiscount = filteredList[index].discount;

                            filteredList[index].condition == "discountCondition.delivery"
                                ? _openCondition = '배달할인'
                                : filteredList[index].condition == "discountCondition.pickUp"
                                ? _openCondition = '방문/포장'
                                : _openCondition = '매장식사';

                          });
                        },
                        child: Container(
                          color: Color(0xfff0f0f0),
                          child: filteredList[index].imageUrl != ''
                              ? GridTile(
                            child: CachedNetworkImage(
                              imageUrl: filteredList[index].imageUrl,
                              fit: BoxFit.contain,
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            footer: GridTileBar(
                              backgroundColor: Colors.black45,
                              title: Text('${filteredList[index].brandName}'),
                              subtitle: Text('${filteredList[index].branchName}'),
                            ),
                          )
                              : GridTile(
                            child: Container(
                              child: Column(
                                children: [
                                  Text('${filteredList[index].discount}원'),
                                  filteredList[index].condition == "discountCondition.delivery"
                                      ? Text('배달할인')
                                      : filteredList[index].condition == "discountCondition.pickUp"
                                      ? Text('방문/포장')
                                      : Text('매장식사')
                                ],
                              ),
                            ),
                            footer: GridTileBar(
                              backgroundColor: Colors.black45,
                              title: Text('${filteredList[index].brandName}'),
                              subtitle: Text('${filteredList[index].branchName}'),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('해당 지역에는 입점한 치킨집이 없어요.'),

                      Container(
                        margin: EdgeInsets.only(top: 12),
                        width: 340,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: const Color(0xffcccccc)),
                          borderRadius: const BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                          child: ValueListenableBuilder<String>(
                            valueListenable: userPhoneNumberNotifier,
                            builder: (context, value, child) {
                              return TextFormField(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffacacac),
                                  fontFamily: "SCDream4",
                                ),
                                cursorColor: const Color(0xff000000),
                                decoration: InputDecoration(
                                  hintText: '연락처 *',
                                  hintStyle: TextStyle(
                                    fontFamily: "SCDream4",
                                  ),
                                  contentPadding: EdgeInsets.only(left: 6, top: 14, bottom: 10,),
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap : () {

                                      if(phoneNumberController.text != '') {
                                        Future.delayed(Duration.zero).then((value) async {

                                          // SharedPreferences에서 저장된 도시와 지구 값을 가져옵니다.
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          String? storedCity = prefs.getString('selectedCity');
                                          String? storedDistrict = prefs.getString('selectedDistrict');

                                          // 저장된 값을 조합하여 location 문자열을 생성합니다.
                                          // 만약 저장된 값이 없다면, 기본값으로 ''을 사용합니다.
                                          String location = "${storedCity ?? ''}, ${storedDistrict ?? ''}";

                                          Map<String, dynamic> userInfo = {
                                            'phoneNumber': phoneNumber,
                                            'location' : location,
                                          };

                                          await FirebaseFirestore.instance
                                              .collection("requestNotification")
                                              .add(userInfo);

                                        }).then((value) {

                                          setState(() {
                                            phoneNumberController.text = '';
                                            completedSendPhoneNumber = true;
                                          });

                                        }).then((value) {
                                          Future.delayed(Duration(microseconds: 1500)).then((value) {

                                            setState(() {
                                              completedSendPhoneNumber = false;
                                            });
                                          });
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 40,
                                      color: Color(0xfffa6565),
                                      child: Center(
                                        child: !completedSendPhoneNumber
                                            ? Text('알림받기',
                                          style: TextStyle(color: Color(0xffffffff),),)
                                            : Icon(Icons.check),
                                      ),
                                    ),
                                  ),
                                ),
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: phoneNumberController,
                                onChanged: (text) {
                                  userPhoneNumberNotifier.value = text;
                                  phoneNumber = text;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          _openShareImage == true ? Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
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
                            setState(() {
                              _openReport = true;
                            });
                          },
                          child: Container(
                            width: 108,
                            height: 64,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xfff5f5f5)
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              color: Color(0xfffa6565)
                            ),
                            child: Center(child: Text('정보가 다른가요?', style: TextStyle(
                              fontSize: 11,
                              color: Color(0xfff5f5f5)
                            ),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _openImageUrl.isNotEmpty ? Container(
                  width: double.maxFinite,
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: _openImageUrl,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ) : Container(
                  width: double.maxFinite,
                  height: 300,
                  color: Color(0xff545454),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_openDiscount}원', style: TextStyle(color: Colors.white), ),
                      Text('${_openCondition}', style: TextStyle(color: Colors.white), )
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${_openBrandName} ${_openBranchName}'),
                    ],
                  ),
                ),
              ],
            ),
          ) : SizedBox(),

          _openLocationFilter == true ? Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: const Color(0xffffffff),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 60,
                    color: const Color(0xff545454),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _openLocationFilter = false;
                              getUpdatedLocation();
                            });
                          },
                          child: const Icon(Icons.navigate_before),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_openLocationFilter) {

                              saveSelectedLocation().then((value) {
                                getUpdatedLocation();

                                setState(() {
                                  _openLocationFilter = false;
                                });

                              });
                            }
                          },
                          child: const Text('저장'),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cityToDistricts.keys.length,
                          itemBuilder: (context, index) {
                            String city = cityToDistricts.keys.elementAt(index);
                            if (city == '전체') {
                              return const SizedBox.shrink();
                            }

                            // _selectedCity가 '전체'일 때 서울을 선택된 것으로 표시합니다.
                            bool isSelected = (_selectedCity == '전체' && city == '서울') || _selectedCity == city;

                            return Container(
                              color: isSelected ? const Color(0xfffa6565) : const Color(0xffffffff),
                              child: ListTile(
                                title: Text(
                                  city,
                                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedCity = city;
                                    _selectedDistrict = '';
                                  });
                                },
                                selected: isSelected,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      if ((_selectedCity == '전체' || _selectedCity == null) && cityToDistricts.containsKey('서울'))
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cityToDistricts['서울']?.length ?? 0,
                            itemBuilder: (context, index) {
                              String? district = cityToDistricts['서울']?[index];

                              if (district == null) return const SizedBox.shrink();

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDistrict = district;
                                  });
                                },
                                child: Container(
                                  color: _selectedDistrict == district ? const Color(0xff545454) : const Color(0xffffffff),
                                  child: ListTile(
                                    title: Text(district, style: TextStyle(color: _selectedDistrict == district ? Colors.white : Colors.black)),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else if (_selectedCity != null && cityToDistricts.containsKey(_selectedCity))
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cityToDistricts[_selectedCity]?.length ?? 0,
                            itemBuilder: (context, index) {
                              String? district = cityToDistricts[_selectedCity]?[index];

                              if (district == null) return const SizedBox.shrink();

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDistrict = district;
                                  });
                                },
                                child: Container(
                                  color: _selectedDistrict == district ? const Color(0xff545454) : const Color(0xffffffff),
                                  child: ListTile(
                                    title: Text(district, style: TextStyle(color: _selectedDistrict == district ? Colors.white : Colors.black)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
      ) : SizedBox(),

          _openShareEditPageImage == true ? Container(
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
                                  _openShareEditPageImage = false;
                                });
                              },
                              child: Icon(Icons.chevron_left)),

                          Spacer(),

                          GestureDetector(
                            onTap: () async {

                              setState(() {
                                _isLoading = true;
                              });

                              await uploadImage(_brandName, _branchName, _selectedFileName!).then((value) {
                                setState(() {
                                  _completedSubmit = true;
                                  _isLoading = false;

                                  _imageData = null;
                                  _brandName = '';
                                  _branchName = '';
                                  _brandNameController.text = '';
                                  _branchNameController.text = '';
                                });
                              });





                            },
                            child: Container(
                              width: 72,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Color(0xfffa6565),
                              ),

                              child: Center(child: Text('제출', style: TextStyle(
                                color: Color(0xffffffff)
                              ),)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height :36,
                  ),

                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Stack(
                      children: [
                      _imageData == null  ? Container(
                          width: 300,
                          height: 240,
                          color: Color(0xfff5f5f5),
                          child: Center(child: Icon(Icons.add, size: 36,)),
                        ) : SizedBox(),

                        Container(
                          width: 300,
                          height: 240,
                          child: _imageData == null
                              ? Center(child: Icon(Icons.add, size: 36))
                              : Stack(

                                children: [
                                  Align(
                                      alignment : Alignment.center,
                                      child: Image.memory(_imageData!, fit: BoxFit.fill)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        Icon(Icons.edit, color: Color(0xffcdcdcd),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                        ),

                        _imageLoading == true ? Container(
                          width: 300,
                          height: 240,
                          color: Color(0xfff5f5f5),
                          child: Center(child: CircularProgressIndicator()),
                        ) : SizedBox(),

                      ],
                    ),
                  ),

                  SizedBox(
                    height :16,
                  ),

                  Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap : () {
                            setState(() {
                              _imageData = null;
                              _openShareEditPageImage = false;
                              _openShareEditPageDirectInput = true;
                            });
                          },
                          child: Container(
                            width : 108,
                              height: 24,
                              color: Color(0xff545454),
                              child: Center(
                                child: Text('사진이 없나요?', style: TextStyle(
                                  color: Color(0xffffffff)
                                ),),
                              )),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height :16,
                  ),

                  Text('할인금액이 잘보이게 올려주시면 좋아요!'),

                  SizedBox(
                    height :16,
                  ),

                  Container(
                    width : 300,
                    child: TextFormField(
                      controller: _brandNameController,
                      decoration: InputDecoration(
                        labelText: '브랜드명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _brandName = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '브랜드명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width : 300,
                    child: TextFormField(
                      controller: _branchNameController,
                      decoration: InputDecoration(
                        labelText: '지점명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _branchName = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '지점명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ) : SizedBox(),

          _openShareEditPageDirectInput == true ? Container(
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
                                  _openShareEditPageDirectInput = false;
                                });
                              },
                              child: Icon(Icons.chevron_left)),

                          Spacer(),

                          GestureDetector(
                            onTap: () async {

                              setState(() {
                                _isLoading = true;
                              });

                              await uploadDirectInput(_brandName, _branchName , _discount, _discountCondition!).then((value) {
                                setState(() {
                                  _completedSubmit = true;
                                  _isLoading = false;

                                  _brandName = '';
                                  _branchName = '';
                                  _discount = '';
                                  _brandNameController.text = '';
                                  _branchNameController.text = '';
                                  _discountController.text = '';

                                });
                              });





                            },
                            child: Container(
                              width: 72,
                              height: 62,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: Color(0xfffa6565),
                              ),

                              child: Center(child: Text('제출', style: TextStyle(
                                  color: Color(0xffffffff)
                              ),)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height :36,
                  ),

                  Container(
                    width : 300,
                    child: TextFormField(
                      controller: _brandNameController,
                      decoration: InputDecoration(
                        labelText: '브랜드명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _brandName = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '브랜드명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width : 300,
                    child: TextFormField(
                      controller: _branchNameController,
                      decoration: InputDecoration(
                        labelText: '지점명',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _branchName = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '지점명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width : 300,
                    child: TextFormField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: '할인금액',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _discount = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '할인금액을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Row(
                          children: [
                            Radio<discountCondition>(
                              value: discountCondition.pickUp,
                              groupValue: _discountCondition,
                              onChanged: (discountCondition? value) {
                                setState(() {
                                  _discountCondition = value;
                                });
                              },
                            ),
                            const Text('방문/포장'),
                          ],
                        ),


                        SizedBox(
                          width: 10,
                        ),

                        Row(
                          children: [
                            Radio<discountCondition>(
                              value: discountCondition.storeMeal,
                              groupValue: _discountCondition,
                              onChanged: (discountCondition? value) {
                                setState(() {
                                  _discountCondition = value;
                                });
                              },
                            ),
                            const Text('매장식사'),
                          ],
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        Row(
                          children: [
                            Radio<discountCondition>(
                              value: discountCondition.delivery,
                              groupValue: _discountCondition,
                              onChanged: (discountCondition? value) {
                                setState(() {
                                  _discountCondition = value;
                                });
                              },
                            ),
                            const Text('배달'),
                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ) : SizedBox(),

          _openReport == true ? Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
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
                                _openReport = false;
                              });
                            },
                            child: Icon(Icons.chevron_left)),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: double.maxFinite,
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: _openImageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                Container(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Radio<ReportReason>(
                            value: ReportReason.ImageMismatch,
                            groupValue: _selectedReason,
                            onChanged: (ReportReason? value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                          ),
                          const Text('이미지가 정보와 달라요'),
                        ],
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      Row(
                        children: [
                          Radio<ReportReason>(
                            value: ReportReason.BrandMismatch,
                            groupValue: _selectedReason,
                            onChanged: (ReportReason? value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                          ),
                          const Text('브랜드가 달라요'),
                        ],
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      Row(
                        children: [
                          Radio<ReportReason>(
                            value: ReportReason.BranchMismatch,
                            groupValue: _selectedReason,
                            onChanged: (ReportReason? value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                          ),
                          const Text('지점명이 달라요'),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 24,
                ),

                GestureDetector(
                  onTap: () {
                    if (_selectedReason != null) {
                      _reportToFirestore(_getShareImageId, _selectedReason!);
                    }

                    setState(() {
                      _completedSubmit = true;
                    });
                  },
                  child: Container(
                    width: 300,
                    height: 40,
                    color: _selectedReason != null
                        ? Color(0xfffa6565)
                        : Color(0xfff5f5f5),
                    child: Center(child: Text('제출', style: TextStyle(
                      color: _selectedReason != null
                          ? Color(0xffffffff)
                          : Color(0xff000000),
                    ),)),
                  ),
                ),

                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ) : SizedBox(),

          _completedSubmit == true ? Container(
            width: double.maxFinite,
            color: Color(0xffffffff),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text('정상적으로 제출되었습니다! 빠르게 처리하겠습니다!!'),

                SizedBox(
                  height: 8,
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _completedSubmit = false;
                      _openShareEditPageImage = false;
                      _openReport = false;
                    });
                  },
                  child: Container(
                    width: 300,
                    height: 80,
                    color: Color(0xfffa6565),
                    child: Center(child: Text('처음으로')),
                  ),
                )
              ],
            ),
          ) : SizedBox(),

          _isLoading == true?
          SafeArea(
            child: Container(
              width: double.maxFinite,
              color : Color(0xffffffff),
              child: Center(child: CircularProgressIndicator(
                color: Color(0xfffa6565).withOpacity(0.3),
              ),),
            ),
          ) : SizedBox()
        ],
      ),
    );
  }
}

enum ReportReason {
  ImageMismatch,
  BrandMismatch,
  BranchMismatch,
}

enum discountCondition {
  delivery,
  pickUp,
  storeMeal,
}