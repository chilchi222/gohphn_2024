import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';






class GoManager extends StatefulWidget {


  const GoManager({Key? key}) : super(key: key);

  @override
  _GoManagerState createState() => _GoManagerState();
}

class _GoManagerState extends State<GoManager> {

  late Stream goManager;

  bool buttonPushed = false;

  int documentCount = 0;
  int documentCount2 = 0;

  bool color = false;


  int newVisit = 0;


  int i = 0;

  bool nowPlaying = false;
  String requestDocID ="";

  int newToday =0;
  int revisitToday =0;


  List appName = [
    "배달의민족",
    "배민원",
    "요기요",
    "쿠팡이츠",
    "땡겨요",
    "위메프오"
  ];







  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('goRevisit')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        documentCount = querySnapshot.size;
      });
    });
    FirebaseFirestore.instance
        .collection('goShare')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        documentCount2 = querySnapshot.size;
      });
    });


    goManager = FirebaseFirestore.instance
        .collection("goManager")
        .snapshots();








  }

  @override
  void dispose() {


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(


        body: Stack(
          children: [
            StreamBuilder(
                stream: goManager,
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  var items = snapshot.data?.docs ?? [];




                  if (snapshot.hasData) {

                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                                Stack(
                                  alignment: Alignment.topLeft,
                                  children: [
                                    Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.only(top: 20, bottom: 20),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        "10만 앱 다운로드와 돈돈돈을 한번에 2023",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: "GmarketSansBold"
                                        ),
                                      ),
                                    ),




                                  ],
                                ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 5, right: 20),
                                  child: Text("전날 총 방문자 수 ${(items[0]["preNewTotal"]+items[0]["preRevisitTotal"]).toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("오늘 총 방문자 수 ${newToday+revisitToday}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ),
                                    buttonPushed == false?
                                    Container(
                                      color: Color(0xffff0000),
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("??",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ):SizedBox()
                                  ],
                                ),
                              ],
                            ),

                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("(오늘포함) 총 방문자 수 ${(items[0]["preNewTotal"]+items[0]["preRevisitTotal"]+newToday).toString()}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                buttonPushed == false?
                                Container(
                                  color: Color(0xffff0000),
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("???????",
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ):SizedBox()
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 5, right: 20),
                                  child: Text("전날 총 또방문자 수 ${items[0]["preRevisitTotal"].toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("오늘 총 또방문자 수 ${revisitToday}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ),
                                    buttonPushed == false?
                                    Container(
                                      color: Color(0xffff0000),
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("??",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ):SizedBox()
                                  ],
                                ),
                              ],
                            ),

                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("(오늘포함) 총 또방문자 수 ${(items[0]["preRevisitTotal"]+revisitToday).toString()}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                buttonPushed == false?
                                Container(
                                  color: Color(0xffff0000),
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("???????",
                                    style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ):SizedBox()
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 5, right: 20),
                                  child: Text("전날 총 새방문자 수 ${items[0]["preNewTotal"].toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [

                                    Container(
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("오늘 총 새방문자 수 ${newToday}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ),
                                    buttonPushed == false?
                                    Container(
                                      color: Color(0xffff0000),
                                      margin: EdgeInsets.only( bottom: 5),
                                      child: Text("??",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffffffff),
                                            fontFamily: "GmarketSansMedium"
                                        ),
                                      ),
                                    ):SizedBox()
                                  ],
                                ),
                              ],
                            ),

                            Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("(오늘포함) 총 새방문자 수 ${(items[0]["preNewTotal"]+newToday).toString()}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ),
                                buttonPushed == false?
                                Container(
                                  color: Color(0xffff0000),
                                  margin: EdgeInsets.only( bottom: 20),
                                  child: Text("???????",
                                    style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontSize: 25,
                                        fontFamily: "GmarketSansMedium"
                                    ),
                                  ),
                                ) : SizedBox(),
                              ],
                            ),

                      

                            Container(
                              margin: EdgeInsets.only( bottom: 20),
                              child: Text("공유수 $documentCount2",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "GmarketSansMedium"
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () async {
                                QuerySnapshot querySnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('goRevisit')
                                    .where('visit', isEqualTo: 13664)
                                    .get();

                                querySnapshot.docs.forEach((doc) async {
                                  await FirebaseFirestore.instance.collection(
                                      'goRevisit').doc(doc.id).delete();
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 200,
                                color: Color(0xff000000),
                                child: Text("지우개", style: TextStyle(color: Color(0xffffffff),fontSize: 20),),

                              ),
                            ),





                            GestureDetector(
                              onTap: () async {

                                DateTime selectedDate = DateTime(2023, 6, 26);
                                DateTime dayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day).toUtc().add(Duration(hours: 9));
                                DateTime dayEnd = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59).toUtc().add(Duration(hours: 9));

                                // Fetch all documents within the time range
                                var revisitSnapshot = await FirebaseFirestore.instance
                                    .collection('goRevisit')
                                    .where('visitDate', isGreaterThanOrEqualTo: dayStart.toString())
                                    .where('visitDate', isLessThan: dayEnd.toString())
                                    .get();

                                var visitSnapshot = await FirebaseFirestore.instance
                                    .collection('goVisit')
                                    .where('joinDate', isGreaterThanOrEqualTo: dayStart.toString())
                                    .where('joinDate', isLessThan: dayEnd.toString())
                                    .get();


                                int visitCounter = 0;
                                int revisitCounter =0;
                                Map<int, DateTime> visitorTimes = {};

                                // Iterate over all documents
                                for (var doc in visitSnapshot.docs) {
                                  // Parse the visitor ID and visit timestamp
                                  int visitorId = doc.data()["visit"];
                                  DateTime visitTimestamp = DateTime.parse(doc.data()['joinDate']);

                                  // Check if the visitor is already in the map
                                  if (visitorTimes.containsKey(visitorId)) {
                                    // Fetch the previous visit timestamp
                                    DateTime previousVisitTimestamp = visitorTimes[visitorId]!;

                                    // Check if the current visit happened within 1 second of the previous visit
                                    if (visitTimestamp.difference(previousVisitTimestamp).inSeconds <= 2) {
                                      // If so, ignore this visit
                                      continue;
                                    }
                                  }

                                  // Update the visitor's most recent visit time
                                  visitorTimes[visitorId] = visitTimestamp;


                                  // Increment the visit counter
                                  visitCounter++;
                                }
                                newToday = visitCounter;
                                print('새방문자 $visitCounter visits on ${selectedDate.toIso8601String()}');



                                // Iterate over all documents
                                for (var doc in revisitSnapshot.docs) {
                                  // Parse the visitor ID and visit timestamp
                                  int visitorId = doc.data()["visit"];
                                  DateTime visitTimestamp = DateTime.parse(doc.data()['visitDate']);

                                  // Check if the visitor is already in the map
                                  if (visitorTimes.containsKey(visitorId)) {
                                    // Fetch the previous visit timestamp
                                    DateTime previousVisitTimestamp = visitorTimes[visitorId]!;

                                    // Check if the current visit happened within 1 second of the previous visit
                                    if (visitTimestamp.difference(previousVisitTimestamp).inSeconds <= 5) {
                                      // If so, ignore this visit
                                      continue;
                                    }
                                  }

                                  // Update the visitor's most recent visit time
                                  visitorTimes[visitorId] = visitTimestamp;

                                  // Increment the visit counter

                                  revisitCounter++;
                                }
                                revisitToday = revisitCounter;
                                print('또방문자 $revisitCounter visits on ${selectedDate.toIso8601String()}');

                                setState(() {

                                  buttonPushed = true;
                                });

                              },
                              child: Container(
                                height: 100,
                                width: 200,
                                color: Colors.orange,
                                alignment: Alignment.center,
                                child: Text("궁금하면 500원?", style: TextStyle(color: Color(0xffffffff),fontSize: 20),),
                              ),
                            ),









                          ],
                        ),
                      ),
                    );
                  } else {
                    return SafeArea(
                      child: Container(
                        child: Center(child: CircularProgressIndicator(
                          color: Color(0xfffa6565).withOpacity(0.3),
                        ),),
                        color: Color(0xffffffff),
                      ),
                    );
                  }
                }),

          ],
        ));

  }

}

