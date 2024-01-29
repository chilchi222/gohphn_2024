import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gohphn_2024/GoChickenSaleStoreData.dart';
import 'package:gohphn_2024/GoChickenSaleStoreTop20Data.dart';
import 'package:gohphn_2024/GoHPHN/GoSaleList/GoChickenSaleJson2List.dart';
import 'package:gohphn_2024/GoManager.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/ShareManager.dart';
import 'package:gohphn_2024/bannerAdsManager/bannerAdsManager.dart';
import 'package:gohphn_2024/favorites/favoritesManager.dart';
import 'package:gohphn_2024/favorites/openFavoriteEdit.dart';
import 'package:gohphn_2024/favorites/openFavoritesPage.dart';
import 'package:gohphn_2024/filter/chickenSaleFilter.dart';
import 'package:gohphn_2024/managerPage/managerPage.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareInfo.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'shortcutBottomSheet/shortcutBottomSheet.dart';

class MobileHome extends StatefulWidget {

  final int startApp;
  final goHome;
  final int myVisit;
  final analytics;
  final Map<String, dynamic> deliveryAppUrls;
  final List<String> userFavoriteList;
  final TabController tabController;
  final List<ShareInfo> shareInfoList;

  const MobileHome({Key? key,

    required this.startApp,
    required this.goHome,
    required this.myVisit,
    required this.analytics,
    required this.deliveryAppUrls,
    required this.userFavoriteList,
    required this.tabController,
    required this.shareInfoList

  }) : super(key: key);

  @override
  _MobileHomeState createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  var f = NumberFormat('###,###,###,###');
  bool isLoading = true;
  bool _hideVOC = false;


  int leftPW = 3;
  int rightPW = 1;

  // 배너광고
  late BannerAdsManager _bannerAdsManager;

  // 즐겨찾기
  late FavoritesManager _favoritesManager;
  
  // 치킨할인필터
  late SortingManager _sortingManager;


  // 할인정보 공유
  late ShareManager _ShareManager;


  // 관리자 페이지
  bool openManagerPage = false;

  void toggleManagerPage() {
    setState(() {
      openManagerPage = !openManagerPage;
    });
  }

  // 즐겨찾기 페이지
  bool openFavoritePage = false;

  void toggleFavoritesPage() {
    setState(() {
      openFavoritePage = !openFavoritePage;
    });
  }

  // 즐겨찾기 편집 페이지
  bool openFavoriteEdit = false;

  void toggleFavoritesEditPage() {
    setState(() {
      openFavoriteEdit = !openFavoriteEdit;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // 치킨할인필터 클래스
    _sortingManager = SortingManager();

    // 배너광고 클래스
    _bannerAdsManager = BannerAdsManager(
      firestore: FirebaseFirestore.instance,
      pageController: PageController(),
      urls: [],
      imageUrls: [],
      currentPageIndex: 0,
      myVisit: widget.myVisit,
      analytics: widget.analytics,
    );

    _bannerAdsManager.loadImageUrls(context);
    _bannerAdsManager.startAutoScroll();

    // 즐겨찾기 클래스
    _favoritesManager = FavoritesManager(userFavoriteList: widget.userFavoriteList, analytics: widget.analytics);
    _favoritesManager.userFavoriteListNotifier = ValueNotifier<List<String>>(_favoritesManager.userFavoriteList);

    _sortingManager.priceOrderDelivery();
    _sortingManager.priceOrderPickUP();
    _sortingManager.priceOrderTop20PickUP();


    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

          readChickenSaleInfo(widget.goHome.data()["chickenSaleInfo"]).then((value) {
            Future.delayed(Duration.zero, () {
              for (int i = 0; i < 105; i++) {
                for (int j = 0; j < goChickenSaleInfoList.length; j++) {
                  if (goChickenSaleStoreData[i]["storeNum"] ==
                      goChickenSaleInfoList[j].storeNum &&
                      goChickenSaleInfoList[j].today == true) {
                    if (goChickenSaleStoreData[i]["saleInfo"]
                        .map((e) =>
                    e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                        .toList()
                        .contains(true)) {
                      goChickenSaleStoreData[i]["saleInfo"].insert(
                          goChickenSaleStoreData[i]["saleInfo"]
                              .map((e) =>
                          e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                              .toList()
                              .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                    } else {
                      goChickenSaleStoreData[i]["saleInfo"].add(
                          goChickenSaleInfoList[j]);
                    }


                    if (i < 20) {
                      if (goChickenSaleStoreTop20Data[i]["saleInfo"]
                          .map((e) =>
                      e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                          .toList()
                          .contains(true)) {
                        goChickenSaleStoreTop20Data[i]["saleInfo"].insert(
                            goChickenSaleStoreTop20Data[i]["saleInfo"].map((e) =>
                            e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                                .toList()
                                .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                      } else {
                        goChickenSaleStoreTop20Data[i]["saleInfo"].add(
                            goChickenSaleInfoList[j]);
                      }
                    }


                    if (goChickenSaleInfoList[j].delivery == true) {
                      if (goChickenSaleStoreData[i]["delivery"]
                          .map((e) =>
                      e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                          .toList()
                          .contains(true)) {
                        goChickenSaleStoreData[i]["delivery"].insert(
                            goChickenSaleStoreData[i]["delivery"].map((e) =>
                            e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                                .toList()
                                .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                      } else {
                        goChickenSaleStoreData[i]["delivery"].add(
                            goChickenSaleInfoList[j]);
                      }


                      if (i < 20) {
                        if (goChickenSaleStoreTop20Data[i]["delivery"]
                            .map((e) =>
                        e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                            .toList()
                            .contains(true)) {
                          goChickenSaleStoreTop20Data[i]["delivery"].insert(
                              goChickenSaleStoreTop20Data[i]["delivery"].map((e) =>
                              e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                                  .toList()
                                  .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                        } else {
                          goChickenSaleStoreTop20Data[i]["delivery"].add(
                              goChickenSaleInfoList[j]);
                        }
                      }
                    }


                    if (goChickenSaleInfoList[j].pickUp == true) {
                      if (goChickenSaleStoreData[i]["pickUp"]
                          .map((e) =>
                      e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                          .toList()
                          .contains(true)) {
                        goChickenSaleStoreData[i]["pickUp"].insert(
                            goChickenSaleStoreData[i]["pickUp"].map((e) =>
                            e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                                .toList()
                                .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                      } else {
                        goChickenSaleStoreData[i]["pickUp"].add(
                            goChickenSaleInfoList[j]);
                      }


                      if (i < 20) {
                        if (goChickenSaleStoreTop20Data[i]["pickUp"]
                            .map((e) =>
                        e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                            .toList()
                            .contains(true)) {
                          goChickenSaleStoreTop20Data[i]["pickUp"].insert(
                              goChickenSaleStoreTop20Data[i]["pickUp"].map((e) =>
                              e.deliveryApp == goChickenSaleInfoList[j].deliveryApp)
                                  .toList()
                                  .lastIndexOf(true) + 1, goChickenSaleInfoList[j]);
                        } else {
                          goChickenSaleStoreTop20Data[i]["pickUp"].add(
                              goChickenSaleInfoList[j]);
                        }
                      }
                    }
                  }
                }
              }
            }).then((value) =>

                Future.delayed(Duration.zero, () {
                  for (int i = 0; i < 105; i++) {
                    if (goChickenSaleStoreData[i]['saleInfo'].length != 0) {
                      goChickenSaleStoreData[i]["maxDiscount"] =
                          goChickenSaleStoreData[i]['saleInfo']
                              .reduce((current, next) =>
                          current.discount > next.discount ? current : next)
                              .discount;
                    }

                    if (goChickenSaleStoreData[i]['delivery'].length != 0) {
                      goChickenSaleStoreData[i]["deliveryMaxDiscount"] =
                          goChickenSaleStoreData[i]['delivery']
                              .reduce((current, next) =>
                          current.discount > next.discount ? current : next)
                              .discount;
                    }

                    if (goChickenSaleStoreData[i]['pickUp'].length != 0) {
                      goChickenSaleStoreData[i]["pickUpMaxDiscount"] =
                          goChickenSaleStoreData[i]['pickUp']
                              .reduce((current, next) =>
                          current.discount > next.discount ? current : next)
                              .discount;
                    }

                    if (i < 20) {
                      if (goChickenSaleStoreTop20Data[i]['saleInfo'].length != 0) {
                        goChickenSaleStoreTop20Data[i]["maxDiscount"] =
                            goChickenSaleStoreTop20Data[i]['saleInfo']
                                .reduce((current, next) =>
                            current.discount > next.discount ? current : next)
                                .discount;
                      }

                      if (goChickenSaleStoreTop20Data[i]['delivery'].length != 0) {
                        goChickenSaleStoreTop20Data[i]["deliveryMaxDiscount"] =
                            goChickenSaleStoreTop20Data[i]['delivery']
                                .reduce((current, next) =>
                            current.discount > next.discount ? current : next)
                                .discount;
                      }

                      if (goChickenSaleStoreTop20Data[i]['pickUp'].length != 0) {
                        goChickenSaleStoreTop20Data[i]["pickUpMaxDiscount"] =
                            goChickenSaleStoreTop20Data[i]['pickUp']
                                .reduce((current, next) =>
                            current.discount > next.discount ? current : next)
                                .discount;
                      }
                    }
                  }
                }).then((value) =>

                    _sortingManager.priceOrderTop20Delivery().then((value) =>

                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            isLoading = false;
                          });
                        })
                    )
                )


            );
          });
    });
  }

  @override
  void dispose() {
    _bannerAdsManager.dispose();
    super.dispose();
  }

  void onButtonPressed1() {
    widget.analytics.logEvent(
      name: '소문내기',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }

  void onButtonPressed2() {
    widget.analytics.logEvent(
      name: 'Top20',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }

  void onButtonPressed3() {
    widget.analytics.logEvent(
      name: '매장많은순',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }

  void onButtonPressed4() {
    widget.analytics.logEvent(
      name: '할인금액순',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }

  void onButtonPressed5() {
    widget.analytics.logEvent(
      name: '배달',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }
  void onButtonPressed6() {
    widget.analytics.logEvent(
      name: '포장',
      parameters: <String, dynamic>{
        // 'string': 'Button pressed!',
        // 'int': 42,
        // 'long': 12345678910,
        // 'double': 1.234,
        // 'bool': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(

         floatingActionButton: _hideVOC == false ? FloatingActionButton(

            onPressed: () async {

              // 유저 지역정보 읽어오기
              // await getUpdatedLocation();
              //
              // Navigator.pushNamed(context, '/share', arguments: ShareManager(_shareInfoList, _selectedCity, _selectedDistrict, _location));



            },

            elevation: 0,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff222222).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Icon(Icons.forward_to_inbox_rounded, color: Color(0xffffffff)),
            ),
            backgroundColor: Colors.transparent,
            // foregroundColor: Colors.black,
          ) : SizedBox(),
          backgroundColor: Color(0xffffffff),
          body: Stack(
            children: [
              SafeArea(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    }),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width
                          ),
                          Container(
                            color:  Color(0xffffffff),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (){

                                    if(leftPW > 0) {

                                      leftPW --;
                                    } else {

                                      if(rightPW ==0){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => GoManager()));

                                      }
                                    }



                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20,top: 15, bottom: 15),
                                    alignment: Alignment.centerLeft,
                                    height: 50,
                                    child: Image.asset('assets/img/redGohphn.png'),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(left: 8,top: 15, bottom: 15),
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  child: Image.asset('assets/img/gohphnLetterLogo.png'),
                                ),

                                Spacer(),

                                // 임시 관리자페이지 버튼
                                GestureDetector(
                                    onTap : () {
                                      // Future.delayed(Duration.zero).then((value) {
                                      //   _ShareManager.loadImagesAndHandlePage(context, manager: true, );
                                      // }).then((value) {
                                      //
                                      // });

                                      toggleManagerPage();

                                    },
                                    child: Text('관리자 페이지')),

                                Spacer(),

                                GestureDetector(
                                  onTap: (){
                                    rightPW --;
                                  },
                                  child: Container(
                                      width: 30,
                                    height: 30,
                                    color: Colors.transparent,
                                  ),
                                )

                              ],
                            ),
                          ),

                          // 배너광고
                          Container(
                            width: double.maxFinite,
                            height: 230,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _bannerAdsManager.pageController,
                                  itemCount: null, // 무한 스크롤을 위해 null로 설정
                                  onPageChanged: (int index) {
                                    setState(() {
                                      _bannerAdsManager.currentPageIndex = index % (_bannerAdsManager.imageUrls.length + 1);
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    if (index % (_bannerAdsManager.imageUrls.length + 1) == 0) {
                                      // 첫 번째 페이지를 반복적으로 표시
                                      return _bannerAdsManager.buildFixedFirstPage();
                                    } else {
                                      // Firestore 이미지 URL을 사용하여 나머지 페이지 생성
                                      final actualIndex = index % _bannerAdsManager.imageUrls.length;
                                      return GestureDetector(
                                          onTap : () async {
                                            if (_bannerAdsManager.urls[actualIndex] != null && await canLaunch(_bannerAdsManager.urls[actualIndex])) {
                                            await launch(_bannerAdsManager.urls[actualIndex]);
                                            } else {
                                            print('Could not launch ${_bannerAdsManager.urls[actualIndex]}');
                                            }

                                          },
                                          child: _bannerAdsManager.buildDynamicPage(_bannerAdsManager.imageUrls[actualIndex]));
                                    }
                                  },
                                ),

                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    width : 40,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color : Color(0xff000000).withOpacity(0.7),
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xfff5f5f5)
                                      )
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${_bannerAdsManager.currentPageIndex + 1}/${_bannerAdsManager.imageUrls.length + 1}", // 현재 페이지/전체 페이지
                                        style: TextStyle(fontSize: 11, color: Color(0xfff5f5f5), fontFamily: "GmarketSansMedium", fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 28,),

                          //즐겨찾기
                          Row(
                            children: [

                              Container(
                                height: 22,
                                width: 7,
                                color: Color(0xfffa6565),

                                margin: EdgeInsets.only(
                                    left: 20, right: 6, bottom: 0),

                              ),

                              Container(
                                // height: 20,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    left: 6, top: 1, right: 6),
                                child: RichText(
                                  text: TextSpan(
                                    text: "즐겨찾기",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "GmarketSansBold",
                                        color: Color(0xff000000)),

                                  ),
                                ),
                              ),

                              Spacer(),

                              GestureDetector(
                                onTap : toggleFavoritesEditPage,
                                child: Container(
                                  // height: 20,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      left: 5, top: 1, right: 6),
                                  child: Text('편집',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "GmarketSansMedium",),

                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 20,
                              ),

                            ],
                          ),

                          SizedBox(height: 16,),

                          ValueListenableBuilder(
                            valueListenable: _favoritesManager.userFavoriteListNotifier,
                            builder: (BuildContext context, List<String> userFavoriteList, Widget? child) {
                              _favoritesManager.updatedFavorites = [];

                              for (var data in goChickenSaleStoreData) {
                                if (userFavoriteList.contains(data['storeName'])) {
                                  _favoritesManager.updatedFavorites.add(data);
                                }
                              }
                              _favoritesManager.updatedFavorites.sort((a, b) =>
                                  a["storeNum"].compareTo(b["storeNum"]));

                              return Container(
                                height: 144,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _favoritesManager.updatedFavorites.length + (4 - min(3, _favoritesManager.updatedFavorites.length)),
                                  itemBuilder: (BuildContext context, int index) {
                                    int favoritesCount = _favoritesManager.updatedFavorites.length;

                                    // 'updatedFavorites' 목록의 아이템을 먼저 표시
                                    if (index < favoritesCount) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {

                                            toggleFavoritesPage();

                                            setState(() {
                                              _favoritesManager.currentClickedFavoriteStore = _favoritesManager.updatedFavorites[index]['storeName'];
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width >= 450 ? 76 : 68,
                                                    height: MediaQuery.of(context).size.width >= 450 ? 76 : 68,
                                                    margin: EdgeInsets.only(
                                                        left: MediaQuery.of(context).size.width >= 450 ? 21 : 20, right: 6),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(16),
                                                      color: Color(0xfff5f5f5),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        _favoritesManager.updatedFavorites[index]['storeName'],
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.normal,
                                                          fontFamily: "GmarketSansMedium",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  _favoritesManager.updatedFavorites[index]['delivery'].length +
                                                      _favoritesManager.updatedFavorites[index]['pickUp'].length != 0
                                                      ? Positioned(
                                                    top: -6,
                                                    right: 3,
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 2),
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(100),
                                                        color: Color(0xfffa6565),
                                                      ),
                                                      child: Center(child: Text(
                                                        '${_favoritesManager.updatedFavorites[index]['delivery'].length +
                                                            _favoritesManager.updatedFavorites[index]['pickUp'].length}',
                                                        style: TextStyle(color: Color(0xffffffff)),
                                                      )),
                                                    ),
                                                  ) : SizedBox(),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: MediaQuery.of(context).size.width >= 450 ? 21 : 20, right: 6),
                                                child: Center(
                                                  child: Text(
                                                    _favoritesManager.updatedFavorites[index]['storeName'],
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width >= 450 ? 11 : 9,
                                                      color: Color(0xff000000),
                                                      fontWeight: FontWeight.normal,
                                                      fontFamily: "GmarketSansMedium",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    // 남은 자리에 'add' 버튼 박스를 표시
                                    return _buildAddButtonBox(context);

                                    return SizedBox.shrink(); // 추가적인 아이템이 없는 경우
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 16,),

                          Row(
                            children: [

                              Container(
                                height: 22,
                                width: 7,
                                color: Color(0xfffa6565),

                                margin: EdgeInsets.only(
                                    left: 20, right: 6, bottom: 0),

                              ),

                              Container(
                                // height: 20,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only( left: 6, top: 1, right: 6),
                                child: RichText(
                                  text: TextSpan(
                                      text: "오늘의 치킨할인",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "GmarketSansBold",
                                          color: Color(0xff000000)),

                                  ),
                                ),
                              ),

                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 13),
                                child: RichText(
                                  text: TextSpan(
                                      text: widget.goHome.data()["chickenDate"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "GmarketSansMedium",
                                          color: Color(0xff6c6c6c)),



                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 6,),
                          Container(
                              height: 40,
                              padding: EdgeInsets.only(right: 20, left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [






                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){

                                        onButtonPressed5();

                                        if(_sortingManager.deliveryOrNot == false){
                                          _sortingManager.filterLoading = true;

                                          Future.delayed(Duration.zero, (){
                                            setState(() {

                                              if(_sortingManager.top20==true){
                                                _sortingManager.priceOrderTop20Delivery().then((value) =>

                                                    Future.delayed(Duration(milliseconds: 300), () {

                                                      setState(() {
                                                        _sortingManager.maxDiscountFilter = true;
                                                        _sortingManager.deliveryOrNot = true;

                                                      });
                                                    }).then((value) =>
                                                        Future.delayed(Duration(milliseconds: 300), () {

                                                          setState(() {

                                                            _sortingManager.filterLoading = false;
                                                          });
                                                        })


                                                    )


                                                );
                                              }else{
                                                _sortingManager.priceOrderDelivery().then((value) =>

                                                    Future.delayed(Duration(milliseconds: 300), () {

                                                      setState(() {
                                                        _sortingManager.maxDiscountFilter = true;
                                                        _sortingManager.deliveryOrNot = true;

                                                      });
                                                    }).then((value) =>

                                                        Future.delayed(Duration(milliseconds: 300), () {

                                                          setState(() {

                                                            _sortingManager.filterLoading = false;
                                                          });
                                                        })

                                                    )


                                                );
                                              }
                                            });
                                          });


                                        }


                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 7),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Color(0xffffffff).withOpacity(0.0),
                                            border: Border(
                                              top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
                                              bottom:  BorderSide(width: 1, color: _sortingManager.deliveryOrNot == true? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
                                            )
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            text: "배달",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "GmarketSansMedium",
                                                color: _sortingManager.deliveryOrNot == true? Color(0xff000000):Color(0xffbbbbbb)),




                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){

                                        onButtonPressed6();

                                        if(_sortingManager.deliveryOrNot == true){
                                          setState(() {
                                            _sortingManager.filterLoading = true;
                                          });
                                          Future.delayed(Duration.zero, (){
                                            setState(() {

                                              if(_sortingManager.top20==true){
                                                _sortingManager.priceOrderTop20PickUP().then((value) =>

                                                    Future.delayed(Duration(milliseconds: 300), () {

                                                      setState(() {
                                                        _sortingManager.maxDiscountFilter = true;
                                                        _sortingManager.deliveryOrNot = false;

                                                      });
                                                    }). then((value) =>
                                                        Future.delayed(Duration(milliseconds: 300), () {

                                                          setState(() {
                                                            _sortingManager.filterLoading = false;

                                                          });
                                                        })

                                                    )

                                                );
                                              }else{
                                                _sortingManager.priceOrderPickUP().then((value) =>


                                                    Future.delayed(Duration(milliseconds: 300), () {

                                                      setState(() {
                                                        _sortingManager.maxDiscountFilter = true;
                                                        _sortingManager.deliveryOrNot = false;

                                                      });
                                                    }). then((value) =>
                                                        Future.delayed(Duration(milliseconds: 300), () {

                                                          setState(() {
                                                            _sortingManager.filterLoading = false;

                                                          });
                                                        })

                                                    )
                                                );
                                              }
                                            });


                                          });


                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 7),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Color(0xffffffff).withOpacity(0.0),
                                            border: Border(
                                              top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
                                              bottom:  BorderSide(width: 1, color: _sortingManager.deliveryOrNot == false? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
                                            )
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            text: "포장",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "GmarketSansMedium",
                                                color: _sortingManager.deliveryOrNot == false? Color(0xff000000):Color(0xffbbbbbb)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              )

                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  height: 1,
                                  color: _sortingManager.deliveryOrNot == true? Color(0xff000000) : Color(0xffbbbbbb),
                                )),
                                Expanded(child: Container(
                                  height: 1,
                                  color: _sortingManager.deliveryOrNot == false? Color(0xff000000) : Color(0xffbbbbbb),
                                )),
                              ],
                            ),
                          ),
                          
                          Container(
                            padding: EdgeInsets.only(
                                top: 10,
                                left: 20,
                                right: 20,
                                bottom: 10),
                            child: Row(
                              children: [

                                GestureDetector(
                                  onTap: () {
                                    onButtonPressed2();
                                    if(_sortingManager.top20 == false){
                                      setState(() {

                                        _sortingManager.filterLoading = true;
                                        _sortingManager.top20 = true;
                                      });

                                      Future.delayed(Duration.zero, () {

                                        setState(() {


                                          if(_sortingManager.maxDiscountFilter==true){

                                            if(_sortingManager.deliveryOrNot==true){
                                              _sortingManager.priceOrderTop20Delivery();
                                            }else{
                                              _sortingManager.priceOrderTop20PickUP();
                                            }


                                          }else{
                                            _sortingManager.branchOrderTop20().then((value) =>
                                                Future.delayed(Duration(milliseconds: 300), () {

                                                  setState(() {


                                                    _sortingManager.filterLoading = false;
                                                  });
                                                })
                                            );
                                          }

                                        });


                                      }).then((value) =>
                                          Future.delayed(Duration(milliseconds: 300), () {

                                            setState(() {
                                              _sortingManager.filterLoading = false;
                                            });
                                          }));
                                      
                                    }else{
                                      setState(() {

                                        _sortingManager.filterLoading = true;
                                        _sortingManager.top20 = false;
                                      });

                                      Future.delayed(Duration.zero, () {

                                        setState(() {

                                          if(_sortingManager.maxDiscountFilter==true){

                                            if(_sortingManager.deliveryOrNot == true){
                                              _sortingManager.priceOrderDelivery();
                                            }else{
                                              _sortingManager.priceOrderPickUP();
                                            }

                                          }else{
                                            _sortingManager.branchOrder().then((value) =>

                                                Future.delayed(Duration(milliseconds: 300), () {

                                                  setState(() {


                                                    _sortingManager.filterLoading = false;
                                                  });
                                                }));
                                          }
                                        });


                                      }).then((value) =>

                                          Future.delayed(Duration(milliseconds: 300), () {

                                            setState(() {


                                              _sortingManager.filterLoading = false;
                                            });
                                          })

                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: _sortingManager.top20 == true
                                                ? 0
                                                : 1,
                                            color: _sortingManager.top20 == true
                                                ? Colors
                                                .transparent
                                                : Color(
                                                0xffdddddd)),
                                        borderRadius: BorderRadius
                                            .circular(16),
                                        color: _sortingManager.top20 == true
                                            ? Color(0xff111111)
                                            : Color(0xffffffff)
                                    ),
                                    // margin: EdgeInsets.only(right: 5),

                                    width: 94,

                                    height: 30,
                                    child: Text(
                                      "TOP20 브랜드", style: TextStyle(
                                      color: _sortingManager.top20 == true
                                          ? Color(0xffffffff)
                                          : Color(0xff000000),
                                      fontSize: 10,
                                      fontFamily: "GmarketSansMedium",
                                      // fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                ),
                                SizedBox(width: 6,),

                                GestureDetector(
                                  onTap: () {
                                    if (_sortingManager.top20 == true) {
                                      setState(() {
                                        _sortingManager.filterLoading = true;
                                        _sortingManager.top20 = false;
                                      });

                                      Future.delayed(Duration.zero, () {
                                        setState(() {
                                          if (_sortingManager.maxDiscountFilter == true) {
                                            if (_sortingManager.deliveryOrNot == true) {
                                              _sortingManager.priceOrderDelivery();
                                            } else {
                                              _sortingManager.priceOrderPickUP();
                                            }
                                          } else {
                                            _sortingManager.branchOrder().then((value) =>

                                                Future.delayed(Duration(
                                                    milliseconds: 300), () {
                                                  setState(() {
                                                    _sortingManager.filterLoading = false;
                                                  });
                                                }));
                                          }
                                        });
                                      }).then((value) =>

                                          Future.delayed(
                                              Duration(milliseconds: 300), () {
                                            setState(() {
                                              _sortingManager.filterLoading = false;
                                            });
                                          })

                                      );
                                    }
                                  },

                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: _sortingManager.top20 == false
                                                ? 0
                                                : 1,
                                            color: _sortingManager.top20 == false
                                                ? Colors
                                                .transparent
                                                : Color(
                                                0xffdddddd)),
                                        borderRadius: BorderRadius
                                            .circular(16),
                                        color: _sortingManager.top20 == false ? Color(
                                            0xff111111) : Color(
                                            0xffffffff)
                                    ),
                                    // margin: EdgeInsets.only(right: 5),

                                    width: 74,

                                    height: 30,
                                    child: Text(
                                      "전체 브랜드", style: TextStyle(
                                      color: _sortingManager.top20 == false
                                          ? Color(0xffffffff)
                                          : Color(0xff000000),
                                      fontSize: 10,
                                      fontFamily: "GmarketSansMedium",
                                      // fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                ),

                                Spacer(),


                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        onButtonPressed4();
                                        if(_sortingManager.maxDiscountFilter == false){

                                          setState(() {
                                            _sortingManager.filterLoading = true;

                                          });


                                          Future.delayed(Duration.zero, () {

                                            setState(() {

                                              if(_sortingManager.top20==true){
                                                if(_sortingManager.deliveryOrNot==true){
                                                  _sortingManager.priceOrderTop20Delivery();
                                                }else{
                                                  _sortingManager.priceOrderTop20PickUP();
                                                }

                                              }else{
                                                if(_sortingManager.deliveryOrNot==true){
                                                  _sortingManager.priceOrderDelivery();
                                                }else{
                                                  _sortingManager.priceOrderPickUP();
                                                }
                                              }
                                            });
                                          }).then((value) =>
                                              Future.delayed(Duration(milliseconds: 300), () {

                                                setState(() {

                                                  _sortingManager.maxDiscountFilter = true;
                                                  _sortingManager.filterLoading = false;
                                                });
                                              })

                                          );


                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),

                                        ),
                                        // alignment: Alignment.centerRight,
                                        height: 30,
                                        width: 82,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          children: [
                                            Transform.rotate(
                                                angle: -math.pi / 2,
                                                child: Icon(
                                                  Icons.sync_alt,
                                                  size: 12,
                                                  color: Color(
                                                      0xff8f8f8f),)),
                                            SizedBox(width: 2,),
                                            Text(
                                              "매장많은순", style: TextStyle(
                                                color: Color(
                                                    0xff8f8f8f),
                                                fontSize: 12,
                                                fontFamily: "GmarketSansMedium"
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),

                                    _sortingManager.maxDiscountFilter == true ?
                                    GestureDetector(
                                      onTap: () {
                                        onButtonPressed3();
                                        if(_sortingManager.maxDiscountFilter == true){

                                          setState(() {
                                            _sortingManager.filterLoading = true;

                                          });


                                          Future.delayed(Duration.zero, () {
                                            setState(() {

                                              if(_sortingManager.top20 == true){
                                                _sortingManager.branchOrderTop20();
                                              }else{
                                                _sortingManager.branchOrder();
                                              }

                                            });

                                          }).then((value) =>
                                              Future.delayed(Duration(milliseconds: 300), () {

                                                setState(() {

                                                  _sortingManager.maxDiscountFilter = false;
                                                  _sortingManager.filterLoading = false;
                                                });
                                              })
                                          );

                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),

                                        ),

                                        height: 30,
                                        width: 82,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .end,
                                          children: [
                                            Transform.rotate(
                                                angle: -math.pi / 2,
                                                child: Icon(
                                                  Icons.sync_alt,
                                                  size: 12,
                                                  color: Color(
                                                      0xff8f8f8f),)),
                                            SizedBox(width: 2,),
                                            Text(
                                              "할인금액순", style: TextStyle(
                                                color: Color(
                                                    0xff8f8f8f),
                                                fontSize: 12,
                                                fontFamily: "GmarketSansMedium"
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ) : SizedBox(),
                                  ],
                                ),


                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          _sortingManager.deliveryOrNot == true ?
                              
                          //배달
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _sortingManager.top20 == true? goChickenSaleStoreTop20Data.length : goChickenSaleStoreData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return

                                      _sortingManager.top20 == true?
                                      //TOP20
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 치킨집 이름

                                          Row(
                                            children: [
                                              Text(
                                                '${goChickenSaleStoreTop20Data[index]['storeName']}',
                                                style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'GmarketSansMedium'),
                                              ),
                                              Spacer(),

                                              // _sortingManager.top20 배달 즐겨찾기 버튼
                                              GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {

                                                    setState(() {
                                                      if (!_favoritesManager.userFavoriteList.contains(goChickenSaleStoreTop20Data[index]['storeName'])) {

                                                        _favoritesManager.userFavoriteList.add(goChickenSaleStoreTop20Data[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreTop20Data[index]['storeName'], true);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);

                                                      } else {

                                                        _favoritesManager.userFavoriteList.remove(goChickenSaleStoreTop20Data[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreTop20Data[index]['storeName'], false);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);
                                                      }
                                                    });

                                                  },
                                                  child: Icon(
                                                    Icons.favorite, size: 20,
                                                    color:
                                                    _favoritesManager.userFavoriteList.contains(goChickenSaleStoreTop20Data[index]['storeName'])
                                                        ? Color(0xfffa6565)
                                                        : Color(0xffcdcdcd),)),
                                            ],
                                          ),
                                          SizedBox(height: 10,),


                                          // 1. 배달앱
                                          goChickenSaleStoreTop20Data[index]['delivery'].length != 0 ?
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xfff6f6f6),
                                                borderRadius: BorderRadius.circular(4)
                                            ),

                                            child: ListView.builder(
                                              itemCount: goChickenSaleStoreTop20Data[index]['delivery'].length,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int saleIndex) {



                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      saleIndex == 0 ?
                                                      SizedBox(height: 10,) :
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: goChickenSaleStoreTop20Data[index]['delivery'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp ?
                                                        10 : 0, left: 8, right: 8 ),
                                                        height: 1,
                                                        color:  goChickenSaleStoreTop20Data[index]['delivery'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp ?
                                                        Color(0xffdddddd) : Colors.white.withOpacity(0),
                                                      ),
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only( bottom: 10,),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: 340
                                                                ),
                                                                // color: Colors.blue,
                                                                child: FittedBox(
                                                                  child: Stack(
                                                                    alignment: Alignment.centerLeft,
                                                                    children: [
                                                                      Container(
                                                                        // color: Colors.blue,

                                                                        margin: EdgeInsets.only(left: 8),
                                                                        child:

                                                                        saleIndex == 0 ?
                                                                        Text(
                                                                          '${goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: Color(0xff555555)),
                                                                        )
                                                                            :
                                                                        Text(
                                                                          '${goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: goChickenSaleStoreTop20Data[index]['delivery'][saleIndex-1].deliveryApp
                                                                                  != goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp ?
                                                                              Color(0xff555555) : Colors.white.withOpacity(0)),
                                                                        ),
                                                                      ),

                                                                      goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc != null?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,
                                                                        height: 12,

                                                                        decoration: BoxDecoration(
                                                                            color: goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc == "첫"?
                                                                            Color(0xfffff9e6) : Color(0xffFFE3FE),
                                                                            borderRadius: BorderRadius.circular(2)
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                          goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc == "첫"?
                                                                          "${goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc}주문"
                                                                              :"${goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc}착순",
                                                                          style: TextStyle(
                                                                              fontFamily: "GmarketSansMedium",
                                                                              fontSize: 7,
                                                                              color: goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].etc == "첫"?
                                                                              Color(0xffff9800):Color(0xffCC00FF)
                                                                          ),


                                                                        ),
                                                                      )
                                                                          :
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,),

                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 115),
                                                                        child: Text(
                                                                          '${f.format(goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].discount)}원 할인',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color:
                                                                              goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].discount ==  goChickenSaleStoreTop20Data[index]['deliveryMaxDiscount']
                                                                                  ? const Color(0xfffa6565)
                                                                                  : Color(0xff555555),
                                                                              fontFamily:
                                                                              goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].discount == goChickenSaleStoreTop20Data[index]['deliveryMaxDiscount']
                                                                                  ? 'GmarketSansBold'
                                                                                  : 'GmarketSansMedium'),
                                                                        ),
                                                                      ),

                                                                      goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].minimumOrder != 0 ?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 199),

                                                                        // color: Colors.green,
                                                                        child: Text(
                                                                          '(${f.format(goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].minimumOrder)}원 이상 주문시)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily:
                                                                              'GmarketSansMedium',
                                                                              color:
                                                                              const Color(0xff999999)),
                                                                        ),

                                                                      ) : SizedBox(),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),

                                                              // TOP20 배달 링크
                                                              saleIndex == 0 || goChickenSaleStoreTop20Data[index]['delivery'][saleIndex - 1].deliveryApp != goChickenSaleStoreTop20Data[index]['delivery'][saleIndex].deliveryApp
                                                                  ? GestureDetector(
                                                                  onTap: ()  {

                                                                    // onButtonPressed('_sortingManager.top20배달 앱 링크연결');
                                                                    showCustomBottomSheet(context, index, saleIndex, goChickenSaleStoreTop20Data, (newHideVOC) {
                                                                      setState(() {
                                                                        _hideVOC = newHideVOC;
                                                                      });
                                                                    }, widget.deliveryAppUrls);

                                                                    setState(() {
                                                                      _hideVOC = true;
                                                                    });

                                                                  },
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.chevron_right, size: 16, color: Color(0xff4d4d4d),),
                                                                  ))
                                                                  : SizedBox.shrink(),

                                                              SizedBox(
                                                                width: 6,
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                              :
                                          Container(
                                            child: Text(
                                              '오늘은 할인 정보를 못 찾았어요.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GmarketSansMedium',
                                                  color: Color(0xffacacac)),
                                            ),
                                          ),
                                          SizedBox(height: 36,)
                                        ],
                                      )
                                          :
                                      //전체
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 치킨집 이름

                                          Row(
                                            children: [
                                              Text(
                                                '${goChickenSaleStoreData[index]['storeName']}',
                                                style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'GmarketSansMedium'),
                                              ),

                                              Spacer(),

                                              // 전체 배달 즐겨찾기 버튼
                                              GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {

                                                    setState(() {
                                                      if (!_favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])) {

                                                        _favoritesManager.userFavoriteList.add(goChickenSaleStoreData[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], true);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);

                                                      } else {

                                                        _favoritesManager.userFavoriteList.remove(goChickenSaleStoreData[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], false);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);
                                                      }
                                                    });

                                                  },
                                                  child: Icon(
                                                    Icons.favorite, size: 20,
                                                    color:
                                                    _favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])
                                                        ? Color(0xfffa6565)
                                                        : Color(0xffcdcdcd),)),

                                            ],
                                          ),
                                          SizedBox(height: 10,),


                                          // 1. 배달앱
                                          goChickenSaleStoreData[index]['delivery'].length != 0 ?
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xfff6f6f6),
                                                borderRadius: BorderRadius.circular(4)
                                            ),

                                            child: ListView.builder(
                                              itemCount: goChickenSaleStoreData[index]['delivery'].length,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int saleIndex) {

                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      saleIndex == 0 ?
                                                      SizedBox(height: 10,) :
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: goChickenSaleStoreData[index]['delivery'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp ?
                                                        10 : 0, left: 8, right: 8 ),
                                                        height: 1,
                                                        color:  goChickenSaleStoreData[index]['delivery'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp ?
                                                        Color(0xffdddddd) : Colors.white.withOpacity(0),
                                                      ),
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only( bottom: 10,),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: 340
                                                                ),

                                                                child: FittedBox(
                                                                  child: Stack(
                                                                    alignment: Alignment.centerLeft,
                                                                    children: [
                                                                      Container(

                                                                        margin: EdgeInsets.only(left: 8),
                                                                        child:
                                                                        saleIndex == 0 ?
                                                                        Text(
                                                                          '${goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: Color(0xff555555)),
                                                                        )
                                                                            :
                                                                        Text(
                                                                          '${goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: goChickenSaleStoreData[index]['delivery'][saleIndex-1].deliveryApp
                                                                                  != goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp ?
                                                                              Color(0xff555555) : Colors.white.withOpacity(0)),
                                                                        ),
                                                                      ),




                                                                      goChickenSaleStoreData[index]['delivery'][saleIndex].etc != null?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,
                                                                        height: 12,

                                                                        decoration: BoxDecoration(
                                                                            color: goChickenSaleStoreData[index]['delivery'][saleIndex].etc == "첫"?
                                                                            Color(0xfffff9e6) : Color(0xffFFE3FE),
                                                                            borderRadius: BorderRadius.circular(2)
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                          goChickenSaleStoreData[index]['delivery'][saleIndex].etc == "첫"?
                                                                          "${goChickenSaleStoreData[index]['delivery'][saleIndex].etc}주문"
                                                                              :"${goChickenSaleStoreData[index]['delivery'][saleIndex].etc}착순",
                                                                          style: TextStyle(
                                                                              fontFamily: "GmarketSansMedium",
                                                                              fontSize: 7,
                                                                              color: goChickenSaleStoreData[index]['delivery'][saleIndex].etc == "첫"?
                                                                              Color(0xffff9800):Color(0xffCC00FF)
                                                                          ),


                                                                        ),
                                                                      ) :    Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,),


                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 115),
                                                                        child: Text(
                                                                          '${f.format(goChickenSaleStoreData[index]['delivery'][saleIndex].discount)}원 할인',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color:
                                                                              goChickenSaleStoreData[index]['delivery'][saleIndex].discount == goChickenSaleStoreData[index]['deliveryMaxDiscount']
                                                                                  ? const Color(0xfffa6565)
                                                                                  : Color(0xff555555),
                                                                              fontFamily:
                                                                              goChickenSaleStoreData[index]['delivery'][saleIndex].discount == goChickenSaleStoreData[index]['deliveryMaxDiscount']
                                                                                  ? 'GmarketSansBold'
                                                                                  : 'GmarketSansMedium'),
                                                                        ),
                                                                      ),

                                                                      goChickenSaleStoreData[index]['delivery'][saleIndex].minimumOrder != 0 ?
                                                                      Container(

                                                                        margin: EdgeInsets.only(left: 199),
                                                                        child: Text(
                                                                          '(${f.format(goChickenSaleStoreData[index]['delivery'][saleIndex].minimumOrder)}원 이상 주문시)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily:
                                                                              'GmarketSansMedium',
                                                                              color:
                                                                              const Color(0xff999999)),
                                                                        ),

                                                                      ) : SizedBox()

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),

                                                              //전체 배달 링크
                                                              saleIndex == 0 || goChickenSaleStoreData[index]['delivery'][saleIndex - 1].deliveryApp != goChickenSaleStoreData[index]['delivery'][saleIndex].deliveryApp
                                                                  ? GestureDetector(
                                                                  onTap: ()  {

                                                                    // onButtonPressed('전체배달 앱 링크연결');
                                                                    showCustomBottomSheet(context, index, saleIndex, goChickenSaleStoreData, (newHideVOC) {
                                                                      setState(() {
                                                                        _hideVOC = newHideVOC;
                                                                      });
                                                                    }, widget.deliveryAppUrls);

                                                                    setState(() {
                                                                      _hideVOC = true;
                                                                    });

                                                                  },
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.chevron_right, size: 16, color: Color(0xff4d4d4d),),
                                                                  ))
                                                                  : SizedBox.shrink(),

                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),


                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                              :
                                          Container(
                                            child: Text(
                                              '오늘은 할인 정보를 못 찾았어요.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GmarketSansMedium',
                                                  color: Color(0xffacacac)),
                                            ),
                                          ),
                                          SizedBox(height: 36,)
                                        ],
                                      );
                                  },
                                ),
                              ),
                              _sortingManager.filterLoading == true?
                              Container(
                                color: Color(0xffffffff),
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height,
                                child: CircularProgressIndicator(
                                  color: Color(0xfffa6565).withOpacity(0.3),
                                ),
                              ):SizedBox(),
                            ],
                          )
                              :
                          //포장
                          Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _sortingManager.top20 == true? goChickenSaleStoreTop20Data.length : goChickenSaleStoreData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      _sortingManager.top20 == true?
                                      //TOP20
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 나머지 할인정보 가게명

                                          Row(
                                            children: [
                                              Text(
                                                '${goChickenSaleStoreTop20Data[index]['storeName']}',
                                                style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'GmarketSansMedium'),
                                              ),

                                              Spacer(),

                                              // _sortingManager.top20 포장 즐겨찾기 버튼
                                              GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {

                                                    setState(() {
                                                      if (!_favoritesManager.userFavoriteList.contains(goChickenSaleStoreTop20Data[index]['storeName'])) {

                                                        _favoritesManager.userFavoriteList.add(goChickenSaleStoreTop20Data[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreTop20Data[index]['storeName'], true);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);

                                                      } else {

                                                        _favoritesManager.userFavoriteList.remove(goChickenSaleStoreTop20Data[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreTop20Data[index]['storeName'], false);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);
                                                      }
                                                    });

                                                  },
                                                  child: Icon(
                                                    Icons.favorite, size: 20,
                                                    color:
                                                    _favoritesManager.userFavoriteList.contains(goChickenSaleStoreTop20Data[index]['storeName'])
                                                        ? Color(0xfffa6565)
                                                        : Color(0xffcdcdcd),))
                                            ],
                                          ),
                                          SizedBox(height: 10,),


                                          // 1. 배달앱
                                          goChickenSaleStoreTop20Data[index]['pickUp'].length != 0 ?
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xfffcf6f6),
                                                borderRadius: BorderRadius.circular(4)
                                            ),

                                            child: ListView.builder(
                                              itemCount:goChickenSaleStoreTop20Data[index]['pickUp'].length,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int saleIndex) {

                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      saleIndex == 0 ?
                                                      SizedBox(height: 10,) :
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp ?
                                                        10 : 0 , left: 8, right: 8),
                                                        height: 1,
                                                        color:  goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp ?
                                                        Color(0xffeedddd) : Colors.white.withOpacity(0),
                                                      ),
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only( bottom: 10,),
                                                          child: Row(
                                                            children: [

                                                              Container(
                                                                constraints: BoxConstraints(maxWidth: 340),

                                                                child: FittedBox(
                                                                  child: Stack(
                                                                    alignment: Alignment.centerLeft,
                                                                    children: [
                                                                      Container(


                                                                        margin: EdgeInsets.only(left: 8),
                                                                        child:
                                                                        saleIndex == 0 ?
                                                                        Text(
                                                                          '${goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: Color(0xff555555)),
                                                                        )
                                                                            :
                                                                        Text(
                                                                          '${goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex-1].deliveryApp
                                                                                  != goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp ?
                                                                              Color(0xff555555) : Colors.white.withOpacity(0)),
                                                                        ),
                                                                      ),



                                                                      goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc != null?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,
                                                                        height: 12,

                                                                        decoration: BoxDecoration(
                                                                            color: goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc == "첫"?
                                                                            Color(0xfffff9e6) : Color(0xffFFE3FE),
                                                                            borderRadius: BorderRadius.circular(2)
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                          goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc == "첫"?
                                                                          "${goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc}주문"
                                                                              :"${goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc}착순",
                                                                          style: TextStyle(
                                                                              fontFamily: "GmarketSansMedium",
                                                                              fontSize: 7,
                                                                              color: goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].etc == "첫"?
                                                                              Color(0xffff9800):Color(0xffCC00FF)
                                                                          ),


                                                                        ),
                                                                      ) : Container(
                                                                        width: 26,
                                                                        margin: EdgeInsets.only(left: 85),
                                                                      ),


                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 115),

                                                                        child: Text(
                                                                          '${f.format(goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].discount)}원 할인',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color:
                                                                              goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].discount == goChickenSaleStoreTop20Data[index]['pickUpMaxDiscount']
                                                                                  ? const Color(0xfffa6565)
                                                                                  : Color(0xff555555),
                                                                              fontFamily:
                                                                              goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].discount ==  goChickenSaleStoreTop20Data[index]['pickUpMaxDiscount']
                                                                                  ? 'GmarketSansBold'
                                                                                  : 'GmarketSansMedium'),
                                                                        ),
                                                                      ),

                                                                      goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].minimumOrder != 0 ?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 199),

                                                                        // color: Colors.green,
                                                                        child: Text(
                                                                          '(${f.format(goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].minimumOrder)}원 이상 주문시)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily:
                                                                              'GmarketSansMedium',
                                                                              color:
                                                                              const Color(0xff999999)),
                                                                        ),

                                                                      ) : SizedBox()

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),

                                                              //TOP20 포장 링크
                                                              saleIndex == 0 || goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex - 1].deliveryApp != goChickenSaleStoreTop20Data[index]['pickUp'][saleIndex].deliveryApp
                                                                  ? GestureDetector(
                                                                  onTap: ()  {

                                                                    // onButtonPressed('_sortingManager.top20포장 앱 링크연결');
                                                                    showCustomBottomSheet(context, index, saleIndex, goChickenSaleStoreTop20Data, (newHideVOC) {
                                                                      setState(() {
                                                                        _hideVOC = newHideVOC;
                                                                      });
                                                                    }, widget.deliveryAppUrls);

                                                                    setState(() {
                                                                      _hideVOC = true;
                                                                    });

                                                                  },
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.chevron_right, size: 16, color: Color(0xff4d4d4d),),
                                                                  ))
                                                                  : SizedBox.shrink(),

                                                              SizedBox(
                                                                width: 6,
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),


                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                              :
                                          Container(
                                            child: Text(
                                              '오늘은 할인 정보를 못 찾았어요.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GmarketSansMedium',
                                                  color: Color(0xffacacac)),
                                            ),
                                          ),
                                          SizedBox(height: 36,)
                                        ],
                                      )
                                          :
                                      //전체
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // 나머지 할인정보 가게명

                                          Row(
                                            children: [
                                              Text(
                                                '${goChickenSaleStoreData[index]['storeName']}',
                                                style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.normal,
                                                    fontFamily: 'GmarketSansMedium'),
                                              ),

                                              Spacer(),

                                              // 전체 포장 즐겨찾기 버튼
                                              GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {

                                                    setState(() {
                                                      if (!_favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])) {

                                                        _favoritesManager.userFavoriteList.add(goChickenSaleStoreData[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], true);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);

                                                      } else {

                                                        _favoritesManager.userFavoriteList.remove(goChickenSaleStoreData[index]['storeName']);
                                                        _favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], false);
                                                        _favoritesManager.setUserFavoriteList(_favoritesManager.userFavoriteList);
                                                      }
                                                    });

                                                  },
                                                  child: Icon(
                                                    Icons.favorite, size: 20,
                                                    color:
                                                    _favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])
                                                        ? Color(0xfffa6565)
                                                        : Color(0xffcdcdcd),))
                                            ],
                                          ),
                                          SizedBox(height: 10,),


                                          // 1. 배달앱
                                          goChickenSaleStoreData[index]['pickUp'].length != 0 ?
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xfffcf6f6),
                                                borderRadius: BorderRadius.circular(4)
                                            ),

                                            child: ListView.builder(
                                              itemCount:goChickenSaleStoreData[index]['pickUp'].length,
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int saleIndex) {



                                                return Container(
                                                  child: Column(
                                                    children: [
                                                      saleIndex == 0 ?
                                                      SizedBox(height: 10,) :
                                                      Container(
                                                        margin: EdgeInsets.only(bottom: goChickenSaleStoreData[index]['pickUp'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp ?
                                                        10 : 0 , left: 8, right: 8),
                                                        height: 1,
                                                        color:  goChickenSaleStoreData[index]['pickUp'][saleIndex-1].deliveryApp
                                                            != goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp ?
                                                        Color(0xffeedddd) : Colors.white.withOpacity(0),
                                                      ),
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only( bottom: 10,),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxWidth: 340
                                                                ),
                                                                child: FittedBox(
                                                                  child: Stack(
                                                                    alignment: Alignment.centerLeft,
                                                                    children: [
                                                                      Container(

                                                                        margin: EdgeInsets.only(left: 8),
                                                                        child:
                                                                        saleIndex == 0 ?
                                                                        Text(
                                                                          '${goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: Color(0xff555555)),
                                                                        )
                                                                            :
                                                                        Text(
                                                                          '${goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp}',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily: 'GmarketSansMedium',
                                                                              color: goChickenSaleStoreData[index]['pickUp'][saleIndex-1].deliveryApp
                                                                                  != goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp ?
                                                                              Color(0xff555555) : Colors.white.withOpacity(0)),
                                                                        ),
                                                                      ),


                                                                      goChickenSaleStoreData[index]['pickUp'][saleIndex].etc != null?
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,
                                                                        height: 12,

                                                                        decoration: BoxDecoration(
                                                                            color: goChickenSaleStoreData[index]['pickUp'][saleIndex].etc == "첫"?
                                                                            Color(0xfffff9e6) : Color(0xffFFE3FE),
                                                                            borderRadius: BorderRadius.circular(2)
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        child: Text(
                                                                          goChickenSaleStoreData[index]['pickUp'][saleIndex].etc == "첫"?
                                                                          "${goChickenSaleStoreData[index]['pickUp'][saleIndex].etc}주문"
                                                                              :"${goChickenSaleStoreData[index]['pickUp'][saleIndex].etc}착순",
                                                                          style: TextStyle(
                                                                              fontFamily: "GmarketSansMedium",
                                                                              fontSize: 7,
                                                                              color: goChickenSaleStoreData[index]['pickUp'][saleIndex].etc == "첫"?
                                                                              Color(0xffff9800):Color(0xffCC00FF)
                                                                          ),


                                                                        ),
                                                                      ) : Container(
                                                                        margin: EdgeInsets.only(left: 85),
                                                                        width: 26,
                                                                      ),




                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 115),
                                                                        child: Text(
                                                                          '${f.format(goChickenSaleStoreData[index]['pickUp'][saleIndex].discount)}원 할인',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color:
                                                                              goChickenSaleStoreData[index]['pickUp'][saleIndex].discount == goChickenSaleStoreData[index]['pickUpMaxDiscount']
                                                                                  ? const Color(0xfffa6565)
                                                                                  : Color(0xff555555),
                                                                              fontFamily:
                                                                              goChickenSaleStoreData[index]['pickUp'][saleIndex].discount == goChickenSaleStoreData[index]['pickUpMaxDiscount']
                                                                                  ? 'GmarketSansBold'
                                                                                  : 'GmarketSansMedium'),
                                                                        ),
                                                                      ),

                                                                      goChickenSaleStoreData[index]['pickUp'][saleIndex].minimumOrder != 0 ?
                                                                      Container(

                                                                        margin: EdgeInsets.only(left: 199),
                                                                        child: Text(
                                                                          '(${f.format(goChickenSaleStoreData[index]['pickUp'][saleIndex].minimumOrder)}원 이상 주문시)',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontFamily:
                                                                              'GmarketSansMedium',
                                                                              color:
                                                                              const Color(0xff999999)),
                                                                        ),

                                                                      ) : SizedBox()

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Spacer(),

                                                              // 전체 포장 링크
                                                              saleIndex == 0 || goChickenSaleStoreData[index]['pickUp'][saleIndex - 1].deliveryApp != goChickenSaleStoreData[index]['pickUp'][saleIndex].deliveryApp
                                                                  ? GestureDetector(
                                                                  onTap: ()  {

                                                                    // onButtonPressed('전체포장 앱 링크연결');
                                                                    showCustomBottomSheet(context, index, saleIndex, goChickenSaleStoreData, (newHideVOC) {
                                                                      setState(() {
                                                                        _hideVOC = newHideVOC;
                                                                      });
                                                                    }, widget.deliveryAppUrls);

                                                                    setState(() {
                                                                      _hideVOC = true;
                                                                    });

                                                                  },
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.chevron_right, size: 16, color: Color(0xff4d4d4d),),
                                                                  ))
                                                                  : SizedBox.shrink(),

                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),


                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                              :
                                          Container(
                                            child: Text(
                                              '오늘은 할인 정보를 못 찾았어요.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GmarketSansMedium',
                                                  color: Color(0xffacacac)),
                                            ),
                                          ),
                                          SizedBox(height: 36,)
                                        ],
                                      );
                                  },
                                ),
                              ),
                              _sortingManager.filterLoading == true?
                              Container(
                                color: Color(0xffffffff),
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 10),
                                height: MediaQuery.of(context).size.height,
                                child: CircularProgressIndicator(
                                  color: Color(0xfffa6565).withOpacity(0.3),
                                ),
                              ):SizedBox(),
                            ],
                          ),

                          SizedBox(
                            height: 90,
                          ),
                        ],
                      ),
                    ),
                  )
              ),

            ],
          ),
        ),

        // _ShareManager.openShareHomeTownChickenSale == true
        //     ? ShareHomeTownChickenSale(handleSharePage : _ShareManager.handleSharePage,
        //   shareInfoList: _ShareManager.shareInfoList,
        //   selectedCity: _ShareManager.selectedCity!,
        //   selectedDistrict: _ShareManager.selectedDistrict!,
        //   location: _ShareManager.location!, )
        //     : SizedBox(),

        //즐겨찾기 페이지 열기
        openFavoritePage == true ?
        OpenFavoritesPage(sortingManager: _sortingManager, favoritesManager: _favoritesManager, onToggleFavoritesPage: toggleFavoritesPage,) : SizedBox(),

        //즐겨찾기 편집페이지 열기
        openFavoriteEdit == true ?
        OpenFavoriteEdit(sortingManager: _sortingManager, favoritesManager: _favoritesManager, onToggleFavoritesEditPage: toggleFavoritesEditPage, ) : SizedBox(),

        //관리자 페이지
        openManagerPage == true ? ManagerPage(onToggleManagerPage: toggleManagerPage, shareInfoList: widget.shareInfoList,) : SizedBox(),

        isLoading == true?
        Scaffold(
            backgroundColor: Color(0xffffffff),
            body:SafeArea(
              child: Container(
                child: Center(child: CircularProgressIndicator(
                  color: Color(0xfffa6565).withOpacity(0.3),
                ),),
                color: Color(0xffffffff),
              ),
            ),
        ):SizedBox()
      ],
    );
  }
  Widget _buildAddButtonBox(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: toggleFavoritesEditPage,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width >= 450 ? 76 : 68,
              height: MediaQuery.of(context).size.width >= 450 ? 76 : 68,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width >= 450 ? 21 : 20, right: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xfff5f5f5),
              ),
              child: Center(child: Icon(Icons.add)),
            ),
            SizedBox(height: 8),
            Opacity(
              opacity: 0,
              child: Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width >= 450 ? 21 : 20, right: 6),
                child: Center(
                  child: Text('빈공간용'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

