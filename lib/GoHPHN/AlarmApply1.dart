// import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:gohphn/GoHPHN/AlarmApply2.dart';
//
// class AlarmApply1 extends StatefulWidget {
//   final int myVisit;
//   final List otherStoreNameAndDiscount;
//   final List chickenStoreNameAndDiscount;
//   final List chickenStoreName;
//   final List otherStoreName;
//   final String chickenDate;
//
//   const AlarmApply1({
//     Key? key,
//     required this.myVisit,
//     required this.otherStoreNameAndDiscount,
//     required this.chickenStoreNameAndDiscount,
//     required this.chickenStoreName,
//     required this.otherStoreName,
//     required this.chickenDate,
//
//   }) : super(key: key);
//
//
//   @override
//   _AlarmApply1State createState() => _AlarmApply1State();
// }
//
// class _AlarmApply1State extends State<AlarmApply1> {
//
//   List chickenTop20 = [
//     "BHC", "BBQ", "처갓집양념치킨", "교촌치킨",
//     "굽네치킨", "네네치킨", "페리카나", "호식이두마리치킨",
//     "푸라닭치킨", "자담치킨", "지코바양념치킨", "60계",
//     "멕시카나", "노랑통닭", "가마치통닭", "또래오래",
//     "또봉이통닭", "맥시칸치킨", "치킨플러스", "코리엔탈깻잎두마리치킨"
//   ];
//
//
//   List chickenPick = [
//
//   ];
//
//   List chickenPickCheckBox = [
//
//     false, false,false, false, false,
//     false, false,false, false, false,
//     false, false,false, false, false,
//     false, false,false, false, false,
//
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//                 width: MediaQuery.of(context).size.width
//             ),
//             Container(
//                 height: 50,
//                 color: Color(0xffffffff),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//
//                             color: Color(0xffffffff),
//                             alignment: Alignment.centerRight,
//                             width: 35,
//                             height: 50,
//                             child: Icon(
//                               Icons.arrow_back_ios_rounded, size: 20,
//                               color: Color(0xff000000),
//                             ))),
//
//                     Text(
//                       "할인봇 시작",
//                       style: TextStyle(
//                           color: const Color(0xff000000),
//                           fontFamily: "GmarketSansMedium",
//                           fontSize: 12),
//                     ),
//
//
//                     SizedBox(
//                       width: 35,
//                     )
//
//                   ],
//                 ),
//               ),
//
//             Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20,),
//                       Row(
//                         children: [
//                           Container(
//                             color: Color(0xfffa6565),
//                             alignment: Alignment.centerLeft,
//                             margin: EdgeInsets.only( left: 20),
//                             height: 20,
//                             width: 7,
//                           ),
//                           Container(
//                             height: 20,
//                             alignment: Alignment.centerLeft,
//                             margin: EdgeInsets.only( left: 10, top: 1, right: 13),
//                             child: RichText(
//                               text: TextSpan(
//                                 text: "치킨 선택",
//                                 style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.normal,
//                                     fontFamily: "GmarketSansBold",
//                                     color: Color(0xff000000)),
//
//                               ),
//                             ),
//                           ),
//
//                           Container(
//                             alignment: Alignment.centerLeft,
//                             margin: EdgeInsets.only(top: 7),
//                             child: RichText(
//                               text: TextSpan(
//                                 text: "최대 3가지",
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.normal,
//                                     fontFamily: "GmarketSansMedium",
//                                     color: Color(0xffDA81FF)),
//
//
//
//                               ),
//                             ),
//                           ),
//
//
//                         ],
//                       ),
//                       // Container(
//                       //   height: 20,
//                       //   alignment: Alignment.centerLeft,
//                       //   margin: EdgeInsets.only( left: 20, top: 7,),
//                       //   child: RichText(
//                       //     text: TextSpan(
//                       //       text: "최대 3개까지 가능해요.",
//                       //       style: TextStyle(
//                       //           fontSize: 14,
//                       //           fontWeight: FontWeight.normal,
//                       //           fontFamily: "GmarketSansMedium",
//                       //           color: Color(0xffacacac)),
//                       //
//                       //     ),
//                       //   ),
//                       // ),
//
//                       Container(
//                         margin: EdgeInsets.only(left: 20, top: 15),
//                         decoration: BoxDecoration(
//                             color: Color(0xff111111),
//                             borderRadius: BorderRadius.circular(30)
//                         ),
//                         alignment: Alignment.center,
//                         height: 32,
//                         width: 86,
//                         child: Text("매장많은순", style: TextStyle(
//                             color: Color(0xffffffff),
//                             fontSize: 12,
//                             fontFamily: "GmarketSansMedium"
//                         ),),
//                       ),
//
//                       SizedBox(
//                         height: 6,
//                       ),
//
//                       ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: 20,
//                         itemBuilder: (BuildContext context, int index) {
//                           return GestureDetector(
//                             onTap: (){
//
//
//                               if(chickenPick.length <3){
//
//                                 if(chickenPickCheckBox[index] == false){
//                                   setState(() {
//                                     chickenPickCheckBox[index] = true;
//                                     chickenPick.add(
//                                         '${chickenTop20[index]}'
//                                     );
//                                   });
//                                 }else {
//                                   setState(() {
//                                     chickenPickCheckBox[index] = false;
//                                     chickenPick.remove(
//                                         '${chickenTop20[index]}'
//                                     );
//                                   });
//                                 }
//
//                               } else {
//
//                                 setState(() {
//                                   chickenPickCheckBox[index] = false;
//                                   chickenPick.remove(
//                                       '${chickenTop20[index]}'
//                                   );
//                                 });
//                               }
//
//
//
//
//
//                             },
//                             child: Container(
//
//                               color: Color(0xffffffff),
//                               height: 50,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//
//                                   SizedBox(width: 20,),
//                                   // 치킨집 이름
//
//                                   Container(
//                                     width: 21,
//                                     height: 21,
//                                     decoration: BoxDecoration(
//                                         border: Border.all(width: 1.5, color: Color(0xffcdcdcd)),
//                                         color: chickenPickCheckBox[index] == true? Color(0xffff0000):Color(0xffffffff)
//                                     ),
//                                   ),
//
//                                   SizedBox(width: 9),
//                                   Container(
//                                     alignment: Alignment.centerLeft,
//                                     height: 21,
//                                     child: Text(
//                                       '${chickenTop20[index]}',
//                                       style: TextStyle(
//                                           color: Color(0xff000000),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.normal,
//                                           fontFamily: 'GmarketSansMedium'),
//                                     ),
//                                   ),
//
//
//
//
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//
//                       SizedBox(
//                         height: 30,
//                       ),
//                     ],),
//                 )),
//
//             GestureDetector(
//               onTap:
//                   (){
//
//                 Navigator.push(
//                     context, MaterialPageRoute(
//                     builder: (context) => AlarmApply2(
//                       chickenPick: chickenPick,
//                       chickenDate: widget.chickenDate,
//                       otherStoreName: widget.otherStoreName,
//                       otherStoreNameAndDiscount: widget.otherStoreNameAndDiscount,
//                       chickenStoreNameAndDiscount: widget.chickenStoreNameAndDiscount,
//                       chickenStoreName: widget.chickenStoreName,
//                       myVisit: widget.myVisit,
//
//                     )));
//               },
//               child: Container(
//                   margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
//                   width: double.maxFinite,
//                   alignment: Alignment.center,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       color: Color(0xfffa6565),
//                       borderRadius: BorderRadius.circular(4)
//                   ),
//
//                   child: Text("다음", style: TextStyle(fontSize: 16,  fontFamily: "GmarketSansMedium", color: Color(0xffffffff)))
//               ),
//             ),
//
//
//
//
//
//
//
//           ],
//
//         ),
//       ),
//     );
//   }
// }
