import 'package:flutter/material.dart';
import 'package:gohphn_2024/GoChickenSaleStoreData.dart';
import 'package:gohphn_2024/favorites/favoritesManager.dart';import 'package:gohphn_2024/filter/chickenSaleFilter.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class OpenFavoritesPage extends StatefulWidget {

  final FavoritesManager favoritesManager;
  final SortingManager sortingManager;
  final VoidCallback onToggleFavoritesPage;


  const OpenFavoritesPage({Key? key,
    required this.sortingManager,
    required this.favoritesManager, required this.onToggleFavoritesPage,}) : super(key: key);

  @override
  State<OpenFavoritesPage> createState() => _OpenFavoritesPageState();
}

class _OpenFavoritesPageState extends State<OpenFavoritesPage> {

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: Color(0xffffffff),
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: 20,
              ),

              Container(
                padding: EdgeInsets.only(left : 10),
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onToggleFavoritesPage,
                      child: Icon(Icons.navigate_before, size: 36,),
                    ),

                    SizedBox(
                      width: 4,
                    ),

                    Text(
                      '즐겨찾기',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'GmarketSansBold'),
                    ),

                    Spacer(),


                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // onButtonPressed('할인금액순');
                              if (widget.sortingManager.maxDiscountFilter == false) {
                                setState(() {
                                  widget.sortingManager.filterLoading = true;
                                });


                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    widget.sortingManager.priceOrderDelivery();
                                    widget.sortingManager.priceOrderPickUP();
                                  });
                                }).then((value) =>
                                    Future.delayed(Duration(
                                        milliseconds: 300), () {
                                      setState(() {
                                        widget.sortingManager.maxDiscountFilter = true;
                                        widget.sortingManager.filterLoading = false;
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
                                        Icons.sync_alt, size: 12,
                                        color: Color(0xff8f8f8f),)),
                                  SizedBox(width: 2,),
                                  Text("매장많은순", style: TextStyle(
                                      color: Color(0xff8f8f8f),
                                      fontSize: 12,
                                      fontFamily: "GmarketSansMedium"
                                  ),),
                                ],
                              ),
                            ),
                          ),

                          widget.sortingManager.maxDiscountFilter == true ?
                          GestureDetector(
                            onTap: () {
                              // onButtonPressed('매장많은순');
                              if (widget.sortingManager.maxDiscountFilter == true) {
                                setState(() {
                                  widget.sortingManager.filterLoading = true;
                                });


                                Future.delayed(Duration.zero, () {
                                  setState(() {
                                    widget.sortingManager.branchOrder();
                                  });
                                }).then((value) =>
                                    Future.delayed(Duration(
                                        milliseconds: 300), () {
                                      setState(() {
                                        widget.sortingManager.maxDiscountFilter = false;
                                        widget.sortingManager.filterLoading = false;
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
                                        Icons.sync_alt, size: 12,
                                        color: Color(0xff8f8f8f),)),
                                  SizedBox(width: 2,),
                                  Text("할인금액순", style: TextStyle(
                                      color: Color(0xff8f8f8f),
                                      fontSize: 12,
                                      fontFamily: "GmarketSansMedium"
                                  ),),
                                ],
                              ),
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                    ),


                  ],
                ),
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
                            setState(() {
                              widget.sortingManager.deliveryOrNot = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 7),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.0),
                                border: Border(
                                  top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
                                  bottom:  BorderSide(width: 1, color: widget.sortingManager.deliveryOrNot == true? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                SizedBox(width: 15,),

                                SizedBox(width: 2,),
                                RichText(
                                  text: TextSpan(
                                    text: "배달",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "GmarketSansMedium",
                                        color: widget.sortingManager.deliveryOrNot == true? Color(0xff000000):Color(0xffbbbbbb)),
                                  ),
                                ),
                                SizedBox(width: 2,),
                                SizedBox(width: 15,),




                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.sortingManager.deliveryOrNot = false;
                            });

                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 7),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.0),
                                border: Border(
                                  top: BorderSide(width: 1, color: Color(0xffffffff).withOpacity(0.0)),
                                  bottom:  BorderSide(width: 1, color: widget.sortingManager.deliveryOrNot == false? Color(0xff000000) : Color(0xffffffff).withOpacity(0)),
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 15,),
                                SizedBox(width: 2,),
                                RichText(
                                  text: TextSpan(
                                    text: "포장",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: "GmarketSansMedium",
                                        color: widget.sortingManager.deliveryOrNot == false? Color(0xff000000):Color(0xffbbbbbb)),
                                  ),
                                ),
                                SizedBox(width: 2,),

                                SizedBox(width: 15,),

                              ],
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
                      color: widget.sortingManager.deliveryOrNot == true? Color(0xff000000) : Color(0xffbbbbbb),
                    )),
                    Expanded(child: Container(
                      height: 1,
                      color: widget.sortingManager.deliveryOrNot == false? Color(0xff000000) : Color(0xffbbbbbb),
                    )),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              Stack(
                children: [
                  widget.sortingManager.deliveryOrNot == true ?
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: goChickenSaleStoreData.length,
                    itemBuilder: (BuildContext context, int index) {

                      if(widget.favoritesManager.updatedFavorites.map((e) => e['storeName']).contains(goChickenSaleStoreData[index]['storeName'])) {
                        return Container(
                          padding: EdgeInsets.only(left : 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 치킨집 이름

                              Text(
                                '${goChickenSaleStoreData[index]['storeName']}',
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'GmarketSansMedium'),
                              ),
                              SizedBox(height: 10,),


                              // 1. 배달앱
                              goChickenSaleStoreData[index]['delivery']
                                  .length != 0 ?
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xfff6f6f6),
                                    borderRadius: BorderRadius.circular(4)
                                ),

                                child: ListView.builder(
                                  itemCount: goChickenSaleStoreData[index]['delivery']
                                      .length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context,
                                      int saleIndex) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          saleIndex == 0 ?
                                          SizedBox(height: 10,) :
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: goChickenSaleStoreData[index]['delivery'][saleIndex -
                                                    1].deliveryApp
                                                    !=
                                                    goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                        .deliveryApp ?
                                                10 : 0, left: 8, right: 8),
                                            height: 1,
                                            color: goChickenSaleStoreData[index]['delivery'][saleIndex -
                                                1].deliveryApp
                                                !=
                                                goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                    .deliveryApp ?
                                            Color(0xffdddddd) : Colors.white
                                                .withOpacity(0),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,),
                                              child: Row(
                                                children: [

                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 340
                                                    ),

                                                    child: FittedBox(
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          Container(

                                                            margin: EdgeInsets
                                                                .only(left: 8),
                                                            child:
                                                            saleIndex == 0 ?
                                                            Text(
                                                              '${goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                  .deliveryApp}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily: 'GmarketSansMedium',
                                                                  color: Color(
                                                                      0xff555555)),
                                                            )
                                                                :
                                                            Text(
                                                              '${goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                  .deliveryApp}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily: 'GmarketSansMedium',
                                                                  color: goChickenSaleStoreData[index]['delivery'][saleIndex -
                                                                      1]
                                                                      .deliveryApp
                                                                      !=
                                                                      goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                          .deliveryApp
                                                                      ?
                                                                  Color(
                                                                      0xff555555)
                                                                      : Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0)),
                                                            ),
                                                          ),


                                                          goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                              .etc != null ?
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(left: 85),
                                                            width: 26,
                                                            height: 12,

                                                            decoration: BoxDecoration(
                                                                color: goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                    .etc == "첫"
                                                                    ?
                                                                Color(
                                                                    0xfffff9e6)
                                                                    : Color(
                                                                    0xffFFE3FE),
                                                                borderRadius: BorderRadius
                                                                    .circular(2)
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                  .etc == "첫" ?
                                                              "${goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                  .etc}주문"
                                                                  : "${goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                  .etc}착순",
                                                              style: TextStyle(
                                                                  fontFamily: "GmarketSansMedium",
                                                                  fontSize: 7,
                                                                  color: goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                      .etc ==
                                                                      "첫"
                                                                      ?
                                                                  Color(
                                                                      0xffff9800)
                                                                      : Color(
                                                                      0xffCC00FF)
                                                              ),


                                                            ),
                                                          ) : Container(
                                                            margin: EdgeInsets
                                                                .only(left: 85),
                                                            width: 26,),


                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                left: 115),
                                                            child: Text(
                                                              '${f.format(
                                                                  goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                      .discount)}원 할인',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                  goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                      .discount ==
                                                                      goChickenSaleStoreData[index]['deliveryMaxDiscount']
                                                                      ? const Color(
                                                                      0xfffa6565)
                                                                      : Color(
                                                                      0xff555555),
                                                                  fontFamily:
                                                                  goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                      .discount ==
                                                                      goChickenSaleStoreData[index]['deliveryMaxDiscount']
                                                                      ? 'GmarketSansBold'
                                                                      : 'GmarketSansMedium'),
                                                            ),
                                                          ),

                                                          goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                              .minimumOrder != 0
                                                              ?
                                                          Container(

                                                            margin: EdgeInsets
                                                                .only(
                                                                left: 199),
                                                            child: Text(
                                                              '(${f.format(
                                                                  goChickenSaleStoreData[index]['delivery'][saleIndex]
                                                                      .minimumOrder)}원 이상 주문시)',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                  'GmarketSansMedium',
                                                                  color:
                                                                  const Color(
                                                                      0xff999999)),
                                                            ),

                                                          )
                                                              : SizedBox()

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer()
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
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ) :
                  //
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: goChickenSaleStoreData.length,
                    itemBuilder: (BuildContext context, int index) {

                      if(widget.favoritesManager.updatedFavorites.map((e) => e['storeName']).contains(goChickenSaleStoreData[index]['storeName'])) {
                        return Container(
                          padding: EdgeInsets.only(left : 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 치킨집 이름


                              Text(
                                '${goChickenSaleStoreData[index]['storeName']}',
                                style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'GmarketSansMedium'),
                              ),
                              SizedBox(height: 10,),


                              // 1. 배달앱
                              goChickenSaleStoreData[index]['pickUp']
                                  .length != 0 ?
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xfff6f6f6),
                                    borderRadius: BorderRadius.circular(4)
                                ),

                                child: ListView.builder(
                                  itemCount: goChickenSaleStoreData[index]['pickUp']
                                      .length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context,
                                      int saleIndex) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          saleIndex == 0 ?
                                          SizedBox(height: 10,) :
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: goChickenSaleStoreData[index]['pickUp'][saleIndex -
                                                    1].deliveryApp
                                                    !=
                                                    goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                        .deliveryApp ?
                                                10 : 0, left: 8, right: 8),
                                            height: 1,
                                            color: goChickenSaleStoreData[index]['pickUp'][saleIndex -
                                                1].deliveryApp
                                                !=
                                                goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                    .deliveryApp ?
                                            Color(0xffdddddd) : Colors.white
                                                .withOpacity(0),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10,),
                                              child: Row(
                                                children: [

                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 340
                                                    ),

                                                    child: FittedBox(
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          Container(

                                                            margin: EdgeInsets
                                                                .only(left: 8),
                                                            child:
                                                            saleIndex == 0 ?
                                                            Text(
                                                              '${goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                  .deliveryApp}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily: 'GmarketSansMedium',
                                                                  color: Color(
                                                                      0xff555555)),
                                                            )
                                                                :
                                                            Text(
                                                              '${goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                  .deliveryApp}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily: 'GmarketSansMedium',
                                                                  color: goChickenSaleStoreData[index]['pickUp'][saleIndex -
                                                                      1]
                                                                      .deliveryApp
                                                                      !=
                                                                      goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                          .deliveryApp
                                                                      ?
                                                                  Color(
                                                                      0xff555555)
                                                                      : Colors
                                                                      .white
                                                                      .withOpacity(
                                                                      0)),
                                                            ),
                                                          ),


                                                          goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                              .etc != null ?
                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(left: 85),
                                                            width: 26,
                                                            height: 12,

                                                            decoration: BoxDecoration(
                                                                color: goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                    .etc == "첫"
                                                                    ?
                                                                Color(
                                                                    0xfffff9e6)
                                                                    : Color(
                                                                    0xffFFE3FE),
                                                                borderRadius: BorderRadius
                                                                    .circular(2)
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                  .etc == "첫" ?
                                                              "${goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                  .etc}주문"
                                                                  : "${goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                  .etc}착순",
                                                              style: TextStyle(
                                                                  fontFamily: "GmarketSansMedium",
                                                                  fontSize: 7,
                                                                  color: goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                      .etc ==
                                                                      "첫"
                                                                      ?
                                                                  Color(
                                                                      0xffff9800)
                                                                      : Color(
                                                                      0xffCC00FF)
                                                              ),


                                                            ),
                                                          ) : Container(
                                                            margin: EdgeInsets
                                                                .only(left: 85),
                                                            width: 26,),


                                                          Container(
                                                            margin: EdgeInsets
                                                                .only(
                                                                left: 115),
                                                            child: Text(
                                                              '${f.format(
                                                                  goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                      .discount)}원 할인',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color:
                                                                  goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                      .discount ==
                                                                      goChickenSaleStoreData[index]['pickUpMaxDiscount']
                                                                      ? const Color(
                                                                      0xfffa6565)
                                                                      : Color(
                                                                      0xff555555),
                                                                  fontFamily:
                                                                  goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                      .discount ==
                                                                      goChickenSaleStoreData[index]['pickUpMaxDiscount']
                                                                      ? 'GmarketSansBold'
                                                                      : 'GmarketSansMedium'),
                                                            ),
                                                          ),

                                                          goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                              .minimumOrder != 0
                                                              ?
                                                          Container(

                                                            margin: EdgeInsets
                                                                .only(
                                                                left: 199),
                                                            child: Text(
                                                              '(${f.format(
                                                                  goChickenSaleStoreData[index]['pickUp'][saleIndex]
                                                                      .minimumOrder)}원 이상 주문시)',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                  'GmarketSansMedium',
                                                                  color:
                                                                  const Color(
                                                                      0xff999999)),
                                                            ),

                                                          )
                                                              : SizedBox()

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer()
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
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),

                  widget.sortingManager.filterLoading == true ?
                  Container(
                    color: Color(0xffffffff),
                    alignment: Alignment.topCenter,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 187,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xfffa6565).withOpacity(0.3),
                      ),
                    ),
                  ) : SizedBox(),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
