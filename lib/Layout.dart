import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/BottomNavigationBar/navigation_page.dart';
import 'package:gohphn_2024/MobileHome.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/ShareManager.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareHomeTownChickenSale.dart';


class Layout extends StatefulWidget {

  final int startApp;
  final goHome;
  final int myVisit;
  final analytics;
  final Map<String, dynamic> deliveryAppUrls;
  final List<String> userFavoriteList;



  const Layout({Key? key,
    required this.startApp,
    required this.goHome,
    required this.myVisit,
    required this.analytics,
    required this.deliveryAppUrls,
    required this.userFavoriteList,
  }) : super(key: key);



  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfffff4f4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MediaQuery.of(context).size.width > 450?
          Spacer():SizedBox(),

          MediaQuery.of(context).size.width >= 900?
          Container(
            width: 450,
              margin: EdgeInsets.only(left: 10),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: "브랜드 치킨,",
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.normal,
                            fontFamily: "GmarketSansBold",
                            color: Color(0xff000000)),



                    ),
                  ),
                  SizedBox(height: 7,),
                  RichText(
                    text: TextSpan(
                        text: "더 싸게",
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.normal,
                            fontFamily: "GmarketSansBold",
                            color: Color(0xfffa6565)),

                        children: [
                          TextSpan(
                            text: " 가보자고",
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.normal,
                                fontFamily: "GmarketSansBold",
                                color: Color(0xff000000)),),
                          TextSpan(
                            text: " ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                fontFamily: "GmarketSansMedium",
                                color: Color(0xff000000)),),

                          TextSpan(
                            text: "!",
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.normal,
                                fontFamily: "GmarketSansBold",
                                color: Color(0xff000000)),)





                        ]

                    ),
                  ),
                  SizedBox(height: 21),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: RichText(
                      text: TextSpan(
                          text: "오늘 저녁엔 가족들과 치킨 어떠세요?",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              fontFamily: "GmarketSansMedium",
                              color: Color(0xff000000)),



                      ),
                    ),
                  ),

                  SizedBox(height: 80),



                ],
              ),
          ):SizedBox(),


          // Container(
          //   constraints: BoxConstraints(
          //     maxWidth: MediaQuery.of(context).size.width > 450? 450 : MediaQuery.of(context).size.width
          //   ),
          //   decoration: BoxDecoration(
          //       border: Border.all(
          //           width:MediaQuery.of(context).size.width > 450?  2 : 0,
          //           color: MediaQuery.of(context).size.width > 450? Color(0xffeeeeee) : Colors.transparent
          //       )
          //   ),
          //   child: Navigator(
          //     onGenerateRoute: (settings) {
          //       if (settings.name == '/') {
          //         return MaterialPageRoute(builder: (context) => MobileHome(
          //           analytics: widget.analytics,
          //           myVisit: widget.myVisit,
          //           startApp: 0,
          //           goHome: widget.goHome,
          //           deliveryAppUrls: widget.deliveryAppUrls,
          //           userFavoriteList: widget.userFavoriteList,
          //         ));
          //       }
          //
          //       if (settings.name == '/share') {
          //         // settings.arguments를 통해 전달받은 인자 처리
          //         final args = settings.arguments as ShareManager;
          //         return MaterialPageRoute(
          //           builder: (context) => ShareHomeTownChickenSale(
          //             shareInfoList: args.shareInfoList,
          //             selectedCity: args.selectedCity!,
          //             selectedDistrict: args.selectedDistrict!,
          //             location: args.location,
          //           ),
          //         );
          //       }
          //     },
          //   )
          // ),
          Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width > 450? 450 : MediaQuery.of(context).size.width
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                      width:MediaQuery.of(context).size.width > 450?  2 : 0,
                      color: MediaQuery.of(context).size.width > 450? Color(0xffeeeeee) : Colors.transparent
                  )
              ),
              child: BottomNavigationPage(startApp: widget.startApp,
                goHome: widget.goHome,
                myVisit: widget.myVisit,
                analytics: widget.analytics,
                userFavoriteList: widget.userFavoriteList,
                deliveryAppUrls: widget.deliveryAppUrls,),
          ),
          MediaQuery.of(context).size.width > 450?
          Spacer():SizedBox(),
        ],
      ),
    );



  }
}
