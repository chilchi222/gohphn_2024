// import 'package:flutter/material.dart';
// import 'package:gohphn/GoHPHN/AlarmApply3.dart';
//
// class AlarmApply2 extends StatefulWidget {
//   final int myVisit;
//   final List otherStoreNameAndDiscount;
//   final List chickenStoreNameAndDiscount;
//   final List chickenStoreName;
//   final List otherStoreName;
//   final String chickenDate;
//   final List chickenPick;
//
//   const AlarmApply2({
//     Key? key,
//     required this.myVisit,
//     required this.otherStoreNameAndDiscount,
//     required this.chickenStoreNameAndDiscount,
//     required this.chickenStoreName,
//     required this.otherStoreName,
//     required this.chickenDate,
//     required this.chickenPick,
//
//
//   }) : super(key: key);
//
//
//   @override
//   _AlarmApply2State createState() => _AlarmApply2State();
// }
//
// class _AlarmApply2State extends State<AlarmApply2> {
//
//
//
//  List alarmSettings = [
//    false, false,
//  ];
//
//
//
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
//                             margin: EdgeInsets.only( left: 10, top: 1, right: 6),
//                             child: RichText(
//                               text: TextSpan(
//                                 text: "챙김 설정",
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
//
//                         ],
//                       ),
//
//                       SizedBox(height: 6,),
//
//                       GestureDetector(
//                         onTap: (){
//                           if(alarmSettings.contains(true) == true){
//
//                                 setState(() {
//                                   alarmSettings = [false, false];
//                                   alarmSettings[0] = true;
//                                 });
//                           }else{
//                             setState(() {
//                               alarmSettings[0] = true;
//                             });
//                           }
//                         },
//                         child: Container(
//
//                           height: 50,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//
//                               SizedBox(width: 20,),
//                               // 치킨집 이름
//
//                               Container(
//                                 width: 21,
//                                 height: 21,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(width: 1.5, color: Color(0xffcdcdcd)),
//                                     color: alarmSettings[0] == true? Color(0xffff0000):Color(0xffffffff)
//                                 ),
//                               ),
//
//                               SizedBox(width: 9),
//                               Container(
//                                 alignment: Alignment.centerLeft,
//                                 height: 21,
//                                 child: Text(
//                                   '할인 시작일만 챙기기',
//                                   style: TextStyle(
//                                       color: Color(0xff000000),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.normal,
//                                       fontFamily: 'GmarketSansMedium'),
//                                 ),
//                               ),
//
//
//
//
//                             ],
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: (){
//                           if(alarmSettings.contains(true) == true){
//
//                             setState(() {
//                               alarmSettings = [false, false];
//                               alarmSettings[1] = true;
//                             });
//                           }else{
//                             setState(() {
//                               alarmSettings[1] = true;
//                             });
//                           }
//                         },
//                         child: Container(
//
//                           height: 50,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//
//                               SizedBox(width: 20,),
//                               // 치킨집 이름
//
//                               Container(
//                                 width: 21,
//                                 height: 21,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(width: 1.5, color: Color(0xffcdcdcd)),
//                                     color: alarmSettings[1] == true? Color(0xffff0000):Color(0xffffffff)
//                                 ),
//                               ),
//
//                               SizedBox(width: 9),
//                               Container(
//                                 alignment: Alignment.centerLeft,
//                                 height: 21,
//                                 child: Text(
//                                   '할인기간 내내 하루에 1번 챙기기',
//                                   style: TextStyle(
//                                       color: Color(0xff000000),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.normal,
//                                       fontFamily: 'GmarketSansMedium'),
//                                 ),
//                               ),
//
//
//
//
//                             ],
//                           ),
//                         ),
//                       ),
//                       // GestureDetector(
//                       //   onTap: (){
//                       //     if(alarmSettings.contains(true) == true){
//                       //
//                       //       setState(() {
//                       //         alarmSettings = [false, false];
//                       //         alarmSettings[1] = true;
//                       //       });
//                       //     }else{
//                       //       setState(() {
//                       //         alarmSettings[1] = true;
//                       //       });
//                       //     }
//                       //   },
//                       //   child: Container(
//                       //
//                       //     height: 50,
//                       //     child: Row(
//                       //       crossAxisAlignment: CrossAxisAlignment.center,
//                       //       children: [
//                       //
//                       //         SizedBox(width: 20,),
//                       //         // 치킨집 이름
//                       //
//                       //         Container(
//                       //           width: 21,
//                       //           height: 21,
//                       //           decoration: BoxDecoration(
//                       //               border: Border.all(width: 1.5, color: Color(0xffcdcdcd)),
//                       //               color: alarmSettings[1] == true? Color(0xffff0000):Color(0xffffffff)
//                       //           ),
//                       //         ),
//                       //
//                       //         SizedBox(width: 9),
//                       //         Container(
//                       //           alignment: Alignment.centerLeft,
//                       //           height: 21,
//                       //           child: Text(
//                       //             '할인에 상관없이 매일 챙기기',
//                       //             style: TextStyle(
//                       //                 color: Color(0xff000000),
//                       //                 fontSize: 16,
//                       //                 fontWeight: FontWeight.normal,
//                       //                 fontFamily: 'GmarketSansMedium'),
//                       //           ),
//                       //         ),
//                       //
//                       //
//                       //
//                       //
//                       //       ],
//                       //     ),
//                       //   ),
//                       // )
//
//
//
//
//
//
//
//
//                     ],),
//
//                 )),
//
//             GestureDetector(
//               onTap: (){
//                 Navigator.push(
//                     context, MaterialPageRoute(
//                     builder: (context) => AlarmApply3(
//                       alarmNum: alarmSettings[0] == true? 1:2,
//                       chickenPick: widget.chickenPick,
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
