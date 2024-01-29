// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:gohphn/GoHPHN/GoPersonalInfoPolicy.dart';
// import 'package:gohphn/GoHPHN/GoReceipt.dart';
//
// class AlarmApply3 extends StatefulWidget {
//   final int myVisit;
//   final List otherStoreNameAndDiscount;
//   final List chickenStoreNameAndDiscount;
//   final List chickenStoreName;
//   final List otherStoreName;
//   final String chickenDate;
//   final List chickenPick;
//   final int alarmNum;
//
//   const AlarmApply3({
//     Key? key,
//     required this.myVisit,
//     required this.otherStoreNameAndDiscount,
//     required this.chickenStoreNameAndDiscount,
//     required this.chickenStoreName,
//     required this.otherStoreName,
//     required this.chickenDate,
//     required this.chickenPick,
//     required this.alarmNum,
//
//   }) : super(key: key);
//
//
//   @override
//   _AlarmApply3State createState() => _AlarmApply3State();
// }
//
// class _AlarmApply3State extends State<AlarmApply3> {
//
//
//  bool phoneOrId = true;
//  bool filterLoading = false;
//  String amount = "010-";
//  bool isAgree = false;
//  bool isLoading = false;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width
//                 ),
//                 Container(
//                     height: 50,
//                     color: Color(0xffffffff),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Container(
//
//                                 color: Color(0xffffffff),
//                                 alignment: Alignment.centerRight,
//                                 width: 35,
//                                 height: 50,
//                                 child: Icon(
//                                   Icons.arrow_back_ios_rounded, size: 20,
//                                   color: Color(0xff000000),
//                                 ))),
//
//                         Text(
//                           "할인봇 시작",
//                           style: TextStyle(
//                               color: const Color(0xff000000),
//                               fontFamily: "GmarketSansMedium",
//                               fontSize: 12),
//                         ),
//
//
//                         SizedBox(
//                           width: 35,
//                         )
//
//                       ],
//                     ),
//                   ),
//
//                 Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 20,),
//                         Row(
//                           children: [
//                             Container(
//                               color: Color(0xfffa6565),
//                               alignment: Alignment.centerLeft,
//                               margin: EdgeInsets.only( left: 20),
//                               height: 20,
//                               width: 7,
//                             ),
//                             Container(
//                               height: 20,
//                               alignment: Alignment.centerLeft,
//                               margin: EdgeInsets.only( left: 10, top: 1, right: 6),
//                               child: RichText(
//                                 text: TextSpan(
//                                   text: "연락처 입력",
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.normal,
//                                       fontFamily: "GmarketSansBold",
//                                       color: Color(0xff000000)),
//
//                                 ),
//                               ),
//                             ),
//
//
//                           ],
//                         ),
//
//                         // SizedBox(height: 6,),
//
//
//                         // Container(
//                         //     height: 40,
//                         //     padding: EdgeInsets.only(right: 20, left: 20),
//                         //     child: Row(
//                         //       mainAxisAlignment: MainAxisAlignment.start,
//                         //       children: [
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //         Expanded(
//                         //           child: GestureDetector(
//                         //             onTap: (){
//                         //
//                         //
//                         //               if(phoneOrId == false){
//                         //
//                         //                 setState(() {
//                         //
//                         //                   filterLoading = true;
//                         //                   phoneOrId = true;
//                         //
//                         //
//                         //                 });
//                         //
//                         //                     Future.delayed(Duration(milliseconds: 300), () {
//                         //
//                         //                       setState(() {
//                         //
//                         //
//                         //                         filterLoading = false;
//                         //                       });
//                         //                     });
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //               }
//                         //
//                         //
//                         //             },
//                         //             child: Container(
//                         //               alignment: Alignment.center,
//                         //               padding: EdgeInsets.only(top: 7),
//                         //               height: 40,
//                         //               decoration: BoxDecoration(
//                         //                   color: Color(0xffffffff).withOpacity(0.0),
//                         //                   border: Border(
//                         //                     top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
//                         //                     bottom:  BorderSide(width: 1, color: phoneOrId == true? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
//                         //                   )
//                         //               ),
//                         //               child: RichText(
//                         //                 text: TextSpan(
//                         //                   text: "휴대폰 번호",
//                         //                   style: TextStyle(
//                         //                       fontSize: 15,
//                         //                       fontWeight: FontWeight.normal,
//                         //                       fontFamily: "GmarketSansMedium",
//                         //                       color: phoneOrId == true? Color(0xff000000):Color(0xffbbbbbb)),
//                         //
//                         //
//                         //
//                         //
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         ),
//                         //
//                         //         Expanded(
//                         //           child: GestureDetector(
//                         //             onTap: (){
//                         //
//                         //               if(phoneOrId == true){
//                         //
//                         //                 setState(() {
//                         //
//                         //                   filterLoading = true;
//                         //                   phoneOrId = false;
//                         //
//                         //
//                         //                 });
//                         //
//                         //                 Future.delayed(Duration(milliseconds: 300), () {
//                         //
//                         //                   setState(() {
//                         //
//                         //
//                         //                     filterLoading = false;
//                         //                   });
//                         //                 });
//                         //
//                         //
//                         //
//                         //               }
//                         //             },
//                         //             child: Container(
//                         //               alignment: Alignment.center,
//                         //               padding: EdgeInsets.only(top: 7),
//                         //               height: 40,
//                         //               decoration: BoxDecoration(
//                         //                   color: Color(0xffffffff).withOpacity(0.0),
//                         //                   border: Border(
//                         //                     top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
//                         //                     bottom:  BorderSide(width: 1, color: phoneOrId == false? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
//                         //                   )
//                         //               ),
//                         //               child: RichText(
//                         //                 text: TextSpan(
//                         //                   text: "카카오 ID",
//                         //                   style: TextStyle(
//                         //                       fontSize: 15,
//                         //                       fontWeight: FontWeight.normal,
//                         //                       fontFamily: "GmarketSansMedium",
//                         //                       color: phoneOrId == false? Color(0xff000000):Color(0xffbbbbbb)),
//                         //
//                         //
//                         //
//                         //
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //         ),
//                         //
//                         //
//                         //
//                         //
//                         //
//                         //       ],
//                         //     )
//                         //
//                         //
//                         //
//                         // ),
//
//                         // Container(
//                         //   padding: EdgeInsets.only(left: 20, right: 20),
//                         //   child: Row(
//                         //     children: [
//                         //       Expanded(child: Container(
//                         //         height: 1,
//                         //         color: phoneOrId == true? Color(0xff000000) : Color(0xffbbbbbb),
//                         //       )),
//                         //       Expanded(child: Container(
//                         //         height: 1,
//                         //         color: phoneOrId == false? Color(0xff000000) : Color(0xffbbbbbb),
//                         //       )),
//                         //     ],
//                         //   ),
//                         // ),
//
//
//
//                       Expanded(
//                         child:  amount.length == 0 ?
//                         Container(
//                           alignment: Alignment.center,
//
//                           child: Text(
//                             "010-1234-5678", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xffc4c4c4)),
//                           ),
//
//                         )
//                             :  Container(
//                           alignment: Alignment.center,
//
//                           child: Text(
//                             amount, style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                           ),
//
//                         ),
//                       ),
//
//
//
//                         Column(
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                             ),
//
//                             Container(
//                               height: 40,
//                               decoration: BoxDecoration(
//                                   color: Color(0xffFFEFF1)
//                                 // border: Border(
//                                 //   bottom: BorderSide(color: Color(0xffe9e9e9)),
//                                 //   top: BorderSide(color: Color(0xffe9e9e9))
//                                 //
//                                 // )
//
//                               ),
//
//                               child: Container(
//                                 margin: EdgeInsets.only(left: 20),
//                                 alignment: Alignment.centerLeft,
//                                 child:  Row(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: (){
//                                         setState(() {
//                                           if(isAgree == false) {
//                                             isAgree = true;
//                                           } else {
//                                             isAgree = false;
//                                           }
//                                         });
//                                       },
//                                       child: Container(
//                                         height: 21,
//                                         width: 21,
//                                         decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color:
//                                             isAgree == false?
//                                             Color(0xffcdcdcd) : Color(0xfffa6565)
//                                         ),
//                                         child: Icon(Icons.check_rounded, size: 16,
//                                           color: Color(0xffffffff),),
//                                       ),
//                                     ),
//
//                                     SizedBox(width: 8),
//                                     GestureDetector(
//                                       onTap: (){
//
//
//                                         setState(() {
//                                           if(isAgree == false) {
//                                             isAgree = true;
//                                           } else {
//                                             isAgree = false;
//                                           }
//                                         });
//                                       },
//
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             alignment: Alignment.center,
//                                             padding: EdgeInsets.only(top: 1),
//                                             height: 40,
//                                             color: Colors.transparent,
//                                             child: Text("(필수) ", style: TextStyle(
//                                                 decoration: TextDecoration.none, fontWeight: FontWeight.normal,
//                                                 fontSize: 12, fontFamily: "GmarketSansMedium", color: Color(0xfffa6565)),),
//                                           ),
//                                           Container(
//                                             alignment: Alignment.center,
//                                             padding: EdgeInsets.only(top: 1),
//                                             height: 40,
//                                             color: Colors.transparent,
//                                             child: Text("개인정보 수집", style: TextStyle(
//                                                 decoration: TextDecoration.none, fontWeight: FontWeight.normal,
//                                                 fontSize: 12, fontFamily: "GmarketSansMedium", color: Color(0xff000000)),),
//                                           ),
//
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 1.5, right: 1.5, top: 1),
//                                             child: Icon(Icons.circle,size: 3.5,),
//                                           ),
//
//                                           Container(
//                                             alignment: Alignment.center,
//                                             padding: EdgeInsets.only(top: 1),
//                                             height: 40,
//                                             child: Text("이용 동의서", style:
//
//                                             TextStyle(
//                                                 decoration: TextDecoration.none, fontWeight: FontWeight.normal,
//                                                 fontSize: 12, fontFamily: "GmarketSansMedium", color: Color(0xff000000)),),
//                                           ),
//                                         ],
//                                       ),
//
//                                     ),
//
//                                     Spacer(),
//
//
//
//
//
//
//                                     GestureDetector(
//                                       onTap: (){
//
//
//                                         showModalBottomSheet(
//                                             backgroundColor: Color(0xffffffff),
//                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//                                             context: context, builder: (BuildContext context) {
//                                           return StatefulBuilder(builder:  (BuildContext context, StateSetter setState) {
//
//                                             return Container(
//                                               padding: EdgeInsets.only(left: 15, right: 15),
//
//                                               child: Column(
//
//                                                 children: [
//                                                   SizedBox(height: 20,),
//                                                   Expanded(
//                                                       child: Container(
//
//
//                                                         child: SingleChildScrollView(
//
//                                                           child: Container(
//                                                             width: double.maxFinite,
//                                                             padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
//                                                             child:  Column(
//                                                               children: [
//
//
//                                                                 Text(
//                                                                   "아래의 목적으로 개인정보를 수집 및 이용하며, 고객님의 개인정보를 안전하게 취급하는데 최선을 다합니다.",
//                                                                   style: TextStyle(
//                                                                       height: 1.2,
//                                                                       fontSize: 12,
//                                                                       fontWeight: FontWeight.normal,
//                                                                       fontFamily:
//                                                                       "GmarketSansMedium",
//                                                                       color: Color(
//                                                                           0xff979797)),
//
//                                                                 ),
//
//                                                                 SizedBox(height: 20,),
//
//
//                                                                 Container(
//
//                                                                   child: Column(
//
//                                                                     children: [
//                                                                       Row(
//                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                         children: [
//                                                                           Container(
//                                                                             alignment: Alignment.center,
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 36,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//                                                                             child:   Text(
//                                                                                 "목적",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 12,
//                                                                                     fontFamily:
//                                                                                     "GmarketSansMedium",
//                                                                                     color: Color(
//                                                                                         0xff979797))),
//
//                                                                           ),
//                                                                           Container(
//                                                                             alignment: Alignment.center,
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 36,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//                                                                             child:   Text(
//                                                                                 "항목",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 12,
//                                                                                     fontFamily:
//                                                                                     "GmarketSansMedium",
//                                                                                     color: Color(
//                                                                                         0xff979797))),
//
//                                                                           ),
//                                                                           Container(
//                                                                             alignment: Alignment.center,
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 36,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//                                                                             child:   Text(
//                                                                                 "보유 기간",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 12,
//                                                                                     fontFamily:
//                                                                                     "GmarketSansMedium",
//                                                                                     color: Color(
//                                                                                         0xff979797))),
//
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       Row(
//                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                         children: [
//                                                                           Container(
//                                                                             padding: EdgeInsets.only(top: 5, left: 8, right: 8),
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 100,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//
//                                                                             child: RichText(
//                                                                               text: TextSpan(
//                                                                                   text: "서비스 기본기능 제공을 위한 이용자 관리 및 비교서비스 제공",
//                                                                                   style: TextStyle(
//                                                                                       height: 1.2,
//                                                                                       fontSize: 9,
//                                                                                       fontFamily: "GmarketSansMedium",
//                                                                                       color: Color(0xff979797)),
//                                                                                   children: [
//                                                                                     TextSpan(
//                                                                                       text: "",
//                                                                                       style: TextStyle(
//                                                                                           height: 1.2,
//                                                                                           fontSize: 9,
//                                                                                           fontFamily: "GmarketSansMedium",
//                                                                                           color: Color(0xff979797)),
//
//                                                                                     ),
//                                                                                   ]
//
//                                                                               ),
//                                                                             ),
//                                                                           ),
//
//
//                                                                           Container(
//                                                                             padding: EdgeInsets.only(top: 5, left: 8, right: 8),
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 100,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//                                                                             child: RichText(
//                                                                               text: TextSpan(
//                                                                                   text: "기기정보(고유기기식별값), 비교서비스 신청내역, 배달지 정보",
//                                                                                   style: TextStyle(
//                                                                                       height: 1.2,
//                                                                                       fontSize: 9,
//                                                                                       fontFamily: "GmarketSansMedium",
//                                                                                       color: Color(0xff979797)),
//                                                                                   children: [
//                                                                                     TextSpan(
//                                                                                       text: "",
//                                                                                       style: TextStyle(
//                                                                                           height: 1.2,
//                                                                                           fontSize: 9,
//                                                                                           fontFamily: "GmarketSansMedium",
//                                                                                           color: Color(0xff979797)),
//
//                                                                                     ),
//                                                                                   ]
//
//                                                                               ),
//                                                                             ),
//
//                                                                           ),
//                                                                           Container(
//                                                                             padding: EdgeInsets.only(top: 5, left: 8, right: 8),
//                                                                             decoration: BoxDecoration(
//                                                                                 color: Color(0xffffffff),
//                                                                                 border: Border.all(
//                                                                                     color: Color(0xffe4e4e4)
//                                                                                 )
//
//                                                                             ),
//                                                                             height: 100,
//                                                                             width: (MediaQuery.of(context).size.width-55)/3,
//                                                                             child: RichText(
//                                                                               text: TextSpan(
//                                                                                   text: "동의 철회 시까지",
//                                                                                   style: TextStyle(
//                                                                                       height: 1.2,
//                                                                                       fontSize: 9,
//                                                                                       fontFamily: "GmarketSansMedium",
//                                                                                       color: Color(0xff979797)),
//                                                                                   children: [
//                                                                                     TextSpan(
//                                                                                       text: "",
//                                                                                       style: TextStyle(
//                                                                                           height: 1.2,
//                                                                                           fontSize: 9,
//                                                                                           fontFamily: "GmarketSansMedium",
//                                                                                           color: Color(0xff979797)),
//
//                                                                                     ),
//                                                                                   ]
//
//                                                                               ),
//                                                                             ),
//
//                                                                           ),
//                                                                         ],
//                                                                       ),
//
//                                                                       SizedBox(height: 6,),
//
//                                                                       Container(
//
//
//                                                                         child: Row(
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Container(
//
//                                                                               child: Icon(
//                                                                                   Icons.error_outline,
//                                                                                   size: 14,
//                                                                                   color: Color(0xff979797)),
//                                                                             ),
//                                                                             SizedBox(
//                                                                               width: 2,
//                                                                             ),
//                                                                             Container(
//                                                                               margin: EdgeInsets.only(
//                                                                                 top: 1,
//                                                                               ),
//                                                                               width: MediaQuery.of(context).size.width-60,
//
//                                                                               alignment:
//                                                                               Alignment.centerLeft,
//
//                                                                               child: Text(
//                                                                                 "위 필수 항목에 대한 동의를 거부할 권리가 있습니다.",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 12,
//                                                                                     fontFamily: "GmarketSansMedium",
//                                                                                     color: Color(0xff979797)),
//
//                                                                               ),
//
//
//                                                                             ),
//
//
//
//                                                                           ],
//                                                                         ),
//                                                                       ),
//
//                                                                       SizedBox(height: 6,),
//
//                                                                       Container(
//
//
//                                                                         child: Row(
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Container(
//
//                                                                               child: Icon(
//                                                                                   Icons.error_outline,
//                                                                                   size: 14,
//                                                                                   color: Color(0xff979797)),
//                                                                             ),
//                                                                             SizedBox(
//                                                                               width: 2,
//                                                                             ),
//                                                                             Container(
//                                                                               margin: EdgeInsets.only(
//                                                                                 top: 1,
//                                                                               ),
//                                                                               width: MediaQuery.of(context).size.width-60,
//
//                                                                               alignment:
//                                                                               Alignment.centerLeft,
//
//                                                                               child: Text(
//                                                                                 "동의를 거부하실 경우 서비스 이용이 제한될 수 있습니다.",
//                                                                                 style: TextStyle(
//                                                                                     fontSize: 12,
//                                                                                     fontFamily: "GmarketSansMedium",
//                                                                                     color: Color(0xff979797)),
//
//                                                                               ),
//
//
//                                                                             ),
//
//
//
//                                                                           ],
//                                                                         ),
//                                                                       ),
//
//                                                                       SizedBox(height: 6,),
//
//                                                                       Container(
//
//
//                                                                         child: Row(
//                                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                                           children: [
//                                                                             Container(
//
//                                                                               child: Icon(
//                                                                                   Icons.error_outline,
//                                                                                   size: 14,
//                                                                                   color: Color(0xff979797)),
//                                                                             ),
//                                                                             SizedBox(
//                                                                               width: 2,
//                                                                             ),
//                                                                             Container(
//                                                                               margin: EdgeInsets.only(
//                                                                                 top: 1,
//                                                                               ),
//                                                                               width: MediaQuery.of(context).size.width-60,
//
//                                                                               alignment:
//                                                                               Alignment.centerLeft,
//
//                                                                               child: RichText(
//                                                                                 text: TextSpan(
//                                                                                   text: "더 자세한 내용에 대해서는 ",
//                                                                                   style: TextStyle(
//
//                                                                                       fontSize: 12,
//                                                                                       fontFamily:
//                                                                                       "GmarketSansMedium",
//                                                                                       color: Color(
//                                                                                           0xff979797)),
//                                                                                   children: [
//                                                                                     TextSpan(
//                                                                                       text: "[개인정보처리방침]",
//                                                                                       recognizer: TapGestureRecognizer()..onTap = (){
//
//                                                                                         Navigator.push(
//                                                                                             context, MaterialPageRoute(builder: (context) => GoPersonalInfoPolicy()));
//
//
//                                                                                       },
//                                                                                       style: TextStyle(
//
//                                                                                           fontSize: 12,
//                                                                                           fontWeight: FontWeight.normal,
//                                                                                           fontFamily:
//                                                                                           "GmarketSansBold",
//                                                                                           color: Color(
//                                                                                               0xff979797)),
//                                                                                     ),
//                                                                                     TextSpan(
//                                                                                       text: " ",
//                                                                                       style: TextStyle(
//
//                                                                                           fontSize: 6,
//                                                                                           fontWeight: FontWeight.normal,
//                                                                                           fontFamily:
//                                                                                           "GmarketSansMedium",
//                                                                                           color: Color(
//                                                                                               0xff979797)),
//                                                                                     ),
//                                                                                     TextSpan(
//                                                                                       text: "을 참고하시길 바랍니다.",
//                                                                                       style: TextStyle(
//
//                                                                                           fontSize: 12,
//                                                                                           fontWeight: FontWeight.normal,
//                                                                                           fontFamily:
//                                                                                           "GmarketSansMedium",
//                                                                                           color: Color(
//                                                                                               0xff979797)),
//                                                                                     ),
//
//
//                                                                                   ],
//                                                                                 ),
//                                                                               ),
//
//
//                                                                             ),
//
//
//
//                                                                           ],
//                                                                         ),
//                                                                       ),
//
//
//
//                                                                       SizedBox(height: 10,),
//
//
//
//
//
//
//
//                                                                     ],
//                                                                   ),
//                                                                 ),
//
//
//
//
//
//                                                               ],
//                                                             ),
//
//                                                           ),
//                                                         ),
//                                                       )
//
//
//
//                                                   ),
//
//                                                   GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.pop(context);
//
//
//                                                     },
//
//
//                                                     child: Container(
//                                                       height: 50,
//
//                                                       alignment: Alignment.center,
//                                                       decoration: BoxDecoration(
//                                                         border: Border.all(color: Color(0xfffa6565), width: 2),
//                                                         borderRadius: BorderRadius.circular(4),
//                                                         color: Color(0xffffffff),
//                                                       ),
//
//                                                       child: Text("돌아가기", style: TextStyle(fontSize: 16,  fontFamily: "GmarketSansMedium", color: Color(0xfffa6565),),),
//                                                     ),
//                                                   ),
//
//                                                   SizedBox(height: 30,)
//                                                 ],
//                                               ),
//
//
//
//                                             );
//                                           });
//
//                                         });
//                                       },
//                                       child: Container(
//                                           color: Colors.transparent,
//                                           height: 40,
//                                           width: 30,
//                                           margin: EdgeInsets.only(right:7.5),
//                                           child: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xffc4c4c4),)
//
//
//                                       ),
//                                     ),
//
//
//                                   ],
//                                 ),
//
//
//                               ),
//
//                             ),
//
//                             Container(
//                               height: 60,
//                               child: Row(
//                                 children: [
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-1";
//                                         } else {
//                                           amount = amount + "1";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "1", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-2";
//                                         } else {
//                                           amount = amount + "2";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "2", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-3";
//                                         } else {
//                                           amount = amount + "3";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "3", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                 ],
//                               ),
//                             ),
//                             // Container(
//                             //   width: MediaQuery.of(context).size.width,
//                             //   height: 1,
//                             //   color: Color(0xffe9e9e9),
//                             // ),
//
//
//                             Container(
//                               height: 60,
//                               child: Row(
//                                 children: [
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-4";
//                                         } else {
//                                           amount = amount + "4";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "4", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-5";
//                                         } else {
//                                           amount = amount + "5";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "5", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-6";
//                                         } else {
//                                           amount = amount + "6";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "6", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                 ],
//                               ),
//                             ),
//
//                             // Container(
//                             //   width: MediaQuery.of(context).size.width,
//                             //   height: 1,
//                             //   color: Color(0xffe9e9e9),
//                             // ),
//
//                             Container(
//                               height: 60,
//                               child: Row(
//                                 children: [
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-7";
//                                         } else {
//                                           amount = amount + "7";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "7", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-8";
//                                         } else {
//                                           amount = amount + "8";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "8", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-9";
//                                         } else {
//                                           amount = amount + "9";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "9", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//
//                                 ],
//                               ),
//                             ),
//
//                             // Container(
//                             //   width: MediaQuery.of(context).size.width,
//                             //   height: 1,
//                             //   color: Color(0xffe9e9e9),
//                             // ),
//
//                             Container(
//                               height: 60,
//                               child: Row(
//                                 children: [
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       // setState(() {
//                                       //   amount = amount + "1";
//                                       // });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       // child: Text(
//                                       //   "1", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       // ),
//                                     ),
//                                   )),
//                                   Expanded(child:
//
//                                   GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         if(amount.length == 3 || amount.length == 8 ) {
//                                           amount = amount + "-0";
//                                         } else {
//                                           amount = amount + "0";
//                                         }
//
//                                       });
//                                     },
//                                     child: Container(
//                                       color: Color(0xffffffff),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         "0", style: TextStyle(fontFamily: "GmarketSansMedium", fontSize: 22, color: Color(0xff000000)),
//                                       ),
//                                     ),
//                                   )),
//                                   Expanded(
//                                       child: GestureDetector(
//                                         onTap:
//                                         amount.length > 0?
//                                             (){
//                                           setState(() {
//
//                                             if(amount=="010-"){
//                                               amount = amount.substring(0, amount.length-2);
//                                             } else if(amount.length == 5 || amount.length == 10) {
//                                               amount = amount.substring(0, amount.length-2);
//                                             } else {
//                                               amount = amount.substring(0, amount.length-1);
//
//                                             }
//
//                                           });
//                                         } : () {},
//                                         child: Container(
//                                             color: Color(0xffffffff),
//                                             alignment: Alignment.center,
//                                             child: Icon(
//                                               Icons.backspace_outlined, size: 22,
//                                             )
//                                         ),
//                                       )),
//
//                                 ],
//                               ),
//                             ),
//
//                             // Container(
//                             //   width: MediaQuery.of(context).size.width,
//                             //   height: 1,
//                             //   color: Color(0xffe9e9e9),
//                             // )
//
//                           ],
//
//                         ),
//
//
//
//
//
//
//
//                       ],)),
//
//                 Stack(
//
//                   alignment: Alignment.center,
//                   children: [
//
//
//                     GestureDetector(
//                       onTap:   amount.length < 20 && amount.length > 4 && isAgree == true?
//
//
//
//                           () {
//
//
//                         setState(() {
//                           isLoading = true;
//                         });
//
//                         Future.delayed(Duration.zero, (){
//
//                           var introDoc = FirebaseFirestore
//                               .instance
//                               .collection("goSaleBotInfo").doc();
//
//                           introDoc.set({
//                             "clickDate": "${DateTime.now().toUtc().add(Duration(hours: 9))
//                             }",
//                             "visit": widget.myVisit,
//                             "phoneNum" : "$amount",
//                             "chickenPick" : widget.chickenPick,
//                             "alarmNum" : widget.alarmNum
//
//
//                           });
//
//
//                         }).then((value) =>
//                             Navigator.push(
//                                 context, MaterialPageRoute(
//                                 builder: (context) => GoReceipt(
//
//                                   chickenDate: widget.chickenDate,
//                                   otherStoreName: widget.otherStoreName,
//                                   otherStoreNameAndDiscount: widget.otherStoreNameAndDiscount,
//                                   chickenStoreNameAndDiscount: widget.chickenStoreNameAndDiscount,
//                                   chickenStoreName: widget.chickenStoreName,
//                                   myVisit: widget.myVisit,
//
//
//
//                                 )))
//
//
//                         );
//
//
//
//
//
//
//
//
//                       } : () {},
//
//
//                       child: Container(
//                           height: 50,
//
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(4),
//                             color:
//
//                             amount.length < 20 && amount.length > 4 && isAgree == true?
//
//                             Color(0xfffa6565) : Color(0xffe9e9e9),
//                           ),
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           child: isAgree == false?
//
//                           RichText(
//                             text: TextSpan(
//                               text: "동의가 꼭 필요해요",
//                               style: TextStyle(
//                                   fontSize: 16,
//
//                                   fontFamily: "GmarketSansMedium",
//                                   color: Color(0xffc4c4c4)),
//                               children: [
//                                 TextSpan(
//                                   text: " ",
//                                   style: TextStyle(
//
//                                       fontSize: 7,
//                                       fontWeight: FontWeight.normal,
//                                       fontFamily: "GmarketSansBold",
//                                       color: Color(0xff000000)),
//                                 ),
//                                 TextSpan(
//                                   text: "!",
//                                   style: TextStyle(
//
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.normal,
//                                       fontFamily: "GmarketSansMedium",
//                                       color: Color(0xffc4c4c4)),
//                                 ),
//                               ],
//                             ),
//                           ):Icon(Icons.check_rounded, size: 40, color:
//
//                           amount.length < 20 && amount.length > 4 && isAgree == true?
//                           Color(0xffffffff) : Color(0xffc4c4c4))
//                       ),
//                     ),
//
//
//                   ],
//                 ),
//
//                 // GestureDetector(
//                 //   onTap: (){
//                 //     Navigator.push(
//                 //         context, MaterialPageRoute(
//                 //         builder: (context) => GoReceipt(
//                 //
//                 //           chickenDate: widget.chickenDate,
//                 //           otherStoreName: widget.otherStoreName,
//                 //           otherStoreNameAndDiscount: widget.otherStoreNameAndDiscount,
//                 //           chickenStoreNameAndDiscount: widget.chickenStoreNameAndDiscount,
//                 //           chickenStoreName: widget.chickenStoreName,
//                 //           myVisit: widget.myVisit,
//                 //
//                 //
//                 //
//                 //         )));
//                 //   },
//                 //   child: Container(
//                 //       margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
//                 //       width: double.maxFinite,
//                 //       alignment: Alignment.center,
//                 //       height: 50,
//                 //       decoration: BoxDecoration(
//                 //           color: Color(0xfffa6565),
//                 //           borderRadius: BorderRadius.circular(4)
//                 //       ),
//                 //
//                 //       child: Text("입력 완료", style: TextStyle(fontSize: 16,  fontFamily: "GmarketSansMedium", color: Color(0xffffffff)))
//                 //   ),
//                 // ),
//
//
//
//
//
//
//
//               ],
//
//             ),
//
//             isLoading == true?
//             Container(
//               child: Center(child: CircularProgressIndicator(
//                 color: Color(0xfffa6565).withOpacity(0.3),
//               ),),
//               color: Color(0xffffffff),
//             ): SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
// }
