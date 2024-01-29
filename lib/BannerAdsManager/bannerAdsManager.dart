import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BannerAdsManager {
  final FirebaseFirestore firestore;
  final PageController pageController;
  List<String> urls;
  List<String> imageUrls;
  Timer? timer;
  int currentPageIndex;
  int myVisit;
  final analytics;

  BannerAdsManager({
    required FirebaseFirestore firestore,
    required PageController pageController,
    required List<String> urls,
    required List<String> imageUrls,
    required int currentPageIndex,
    required int myVisit,
    required analytics,
  })  : firestore = firestore,
        pageController = pageController,
        urls = urls,
        imageUrls = imageUrls,
        currentPageIndex = currentPageIndex,
        myVisit = myVisit,
        analytics = analytics;

  void dispose() {
    timer?.cancel(); // 타이머 정리
    pageController.dispose(); // PageController 정리
  }

  Future<void> loadImageUrls(BuildContext context) async {
    var snapshots = await getBannerImages();

    var imageMapList = snapshots.map((doc) {
      var data = doc.data() as Map<String, dynamic>?; // Object를 Map으로 캐스팅
      return {
        'url': data?['url'] as String?,
        'imageUrl': data?['imageUrl'] as String?,// null 안전 접근
        'index': data?['index'] as int? // index값 가져오기
      };
    }).where((item) => item['imageUrl'] != null && item['index'] != null) // null인 url 또는 index 제거
        .toList();

    // index에 따라 정렬
    imageMapList.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));

    // URL만 추출하여 저장
    imageUrls = imageMapList.map((item) => item['imageUrl'] as String).toList();
    urls = imageMapList.map((item) => item['url'] as String).toList();

    precacheImages(context);
  }

  // 자동 스크롤
  void startAutoScroll() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      int nextPage = pageController.page!.toInt() + 1;

      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  //파이어베이스 스토어 url 읽어오기
  Future<List<DocumentSnapshot>> getBannerImages() async {
    var collection = firestore.collection('goBannerAdImage');
    var snapshot = await collection.get();
    return snapshot.docs;
  }

// 첫 페이지위젯 (공유하기)
  Widget buildFixedFirstPage() {
    return Stack(
      alignment: Alignment.topLeft,
      children: [

        Container(
          height: 230,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(top: 85, bottom: 10),
          color: Color(0xff1C1304),
          child: Image.asset('assets/img/chicken.png'),
        ),

        Container(
          height: 230,
          color: Color(0xff000000).withOpacity(0.45),

        ),

        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only( left: 19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 36),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: RichText(
                  text: TextSpan(
                      text: "배달앱은 요즘 ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: "GmarketSansMedium",
                          color: Color(0xff808080)),

                      children: [



                        TextSpan(
                          text: "'할인경쟁'",
                          style: TextStyle(

                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xffF8B629)),
                        ),
                        TextSpan(
                          text: " 중",
                          style: TextStyle(

                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xff808080)),
                        ),
                        TextSpan(
                          text: " ",
                          style: TextStyle(

                              fontSize: 4,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xffffffff)),
                        ),
                        TextSpan(
                          text: "~",
                          style: TextStyle(

                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xff808080)),
                        ),

                      ]

                  ),
                ),
              ),
              SizedBox(height: 13,),
              RichText(
                text: TextSpan(
                  text: "어떻게 주문해야",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.normal,
                      fontFamily: "GmarketSansBold",
                      color: Color(0xffffffff)),


                ),
              ),
              SizedBox(height: 6,),
              RichText(
                text: TextSpan(
                    text: "최저가",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.normal,
                        fontFamily: "GmarketSansBold",
                        color: Color(0xfffa6565)),

                    children: [



                      TextSpan(
                        text: "로 소문이 날까?",
                        style: TextStyle(

                            fontSize: 23,
                            fontWeight: FontWeight.normal,
                            fontFamily: "GmarketSansBold",
                            color: Color(0xffffffff)),
                      ),



                    ]

                ),
              ),


              SizedBox(height: 23,),



              Container(

                // margin: EdgeInsets.only(right: 50, left: 31),
                decoration: BoxDecoration(
                  color: Color(0xfffa6565),
                  borderRadius: BorderRadius.circular(50),

                ),

                height:27,
                width: 125,

                child:

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(width: 2,),
                    Container(
                      height: 15,

                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: "친구에게 소문내기",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xffffffff)),



                        ),
                      ),
                    ),
                    SizedBox(width: 2,),
                    Container(
                        margin: EdgeInsets.only(bottom: 3),
                        alignment: Alignment.center,
                        height: 15,
                        child: Icon(Icons.rss_feed_rounded, size: 15, color: Color(0xffffffff),)),

                  ],
                ),
              )


            ],
          ),
        ),
        GestureDetector(

          behavior: HitTestBehavior.translucent,
          onTap: ()  {
            // onButtonPressed1();
            Future.delayed(Duration.zero, (){

              var introDoc = FirebaseFirestore
                  .instance
                  .collection("goShare").doc();

              introDoc.set({
                "clickDate": "${DateTime.now().toUtc().add(Duration(hours: 9))
                }",

                "visit": myVisit,
                "platform" : "web"
              });


            }).then((value) async {


              final urlPreview = "https://gohphn.com/" ;
              await Share.share("$urlPreview");
            }


            );






          },
          child: Container(
            height: 230,
            color: Color(0xff000000).withOpacity(0.0),

          ),
        ),

      ],
    );
  }

  // 나머지 배너광고 이미지위젯
  Widget buildDynamicPage(String? imageUrl) {
    // URL이 null 또는 비어 있을 경우 빈 컨테이너 반환
    return imageUrl == null || imageUrl.isEmpty
        ? Container(color: Colors.white, height: 230)
        : CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  //이미지 사전 로딩
  void precacheImages(BuildContext context) {
    for (String url in imageUrls) {
      final imageProvider = CachedNetworkImageProvider(url);
      precacheImage(imageProvider, context);
    }
  }

  void onButtonPressed1() {
    analytics.logEvent(
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
}



