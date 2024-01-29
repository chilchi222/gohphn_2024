import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/Layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatefulWidget {

  final analytics;

  const Root({
    Key? key,
    required this.analytics


  }) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  List chickenStoreNameAndDiscount = [];
  List otherStoreNameAndDiscount = [];
  List chickenStoreName = [];
  List otherStoreName = [];
  int? myVisit;
  var goHome;

  // 배달앱 링크
  Map<String, dynamic> deliveryAppUrls = {};
  Future<void> loadDeliveryAppUrls() async {
    var collection = FirebaseFirestore.instance.collection('goAppLink');
    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      deliveryAppUrls[doc.id] = doc.data();
    }
  }

  // 즐겨찾기
  List<String> userFavoriteList = ['BHC', 'BBQ', '교촌치킨'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadDeliveryAppUrls();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseFirestore.instance.collection("goHome").get().then((value) =>

      {
        value.docs.forEach((result) {
          goHome = result;



          getMyVisit().then(
                  (value)    {


                if(myVisit == null || myVisit ==2) {

                  FirebaseFirestore.instance.collection(
                      "goHome").doc("vD1X1cl8E2IrP69DaN3l")
                      .update(
                      {
                        "visit": FieldValue.increment(1)
                      }


                  ).then((value) =>
                      setMyVisit(goHome.data()["visit"]+1).then((value) =>


                          getMyVisit().then((value) async {

                            //유저 즐겨찾기 (즐겨찾기 저장소 만들기 - 기본값 저장)
                            await setUserFavoriteList(userFavoriteList);

                            Future.delayed(Duration.zero, () {
                              var introDoc = FirebaseFirestore
                                  .instance
                                  .collection("goVisit").doc();



                              introDoc.set({
                                "joinDate": "${DateTime.now().toUtc().add(Duration(hours: 9))}",

                                "visit": myVisit,
                                "platform" : "web"
                              });
                            });
                          }
                          ).then((value) =>



                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Layout(
                                            deliveryAppUrls : deliveryAppUrls,
                                            analytics: widget.analytics,
                                            myVisit: myVisit == null ? 2 : myVisit!,
                                            startApp: 0,
                                            goHome: goHome,
                                            userFavoriteList : userFavoriteList,
                                          )),
                                      (route) => false)
                          )






                      )

                  );

                }

                else{

                  Future.delayed(Duration.zero, () async {
                    var introDoc = FirebaseFirestore
                        .instance
                        .collection("goRevisit")
                        .doc();

                    // 재방문자 즐겨찾기 리스트 읽어오기
                    final SharedPreferences pref = await SharedPreferences.getInstance();
                    userFavoriteList = await pref.getStringList('userFavoriteList')!;

                    introDoc.set({
                      "visitDate": "${DateTime.now().toUtc().add(Duration(hours: 9))
                      }",

                      "visit": myVisit,
                      "platform" : "web"
                    });
                  }).then((value) =>


                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Layout(
                                    deliveryAppUrls : deliveryAppUrls,
                                    analytics: widget.analytics,
                                    myVisit:  myVisit == null ? 2 : myVisit!,
                                    startApp: 0,
                                    goHome: goHome,
                                    userFavoriteList: userFavoriteList,


                                  )),
                              (route) => false)
                  );

                }





              });

        })
      });
    });
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
          child:  Center(

            child: CircularProgressIndicator(
              color: Color(0xfffa6565).withOpacity(0.3),
            ),
          )
      ),
    );
  }


  Future getMyVisit() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    myVisit = pref.getInt('myVisit');

  }

  Future<void> setMyVisit(myVisit) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('myVisit', myVisit);
  }

  Future<void> setUserFavoriteList(List<String> defaultFavoriteList) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('userFavoriteList', defaultFavoriteList);
  }
}
