import 'package:flutter/material.dart';
import 'package:gohphn_2024/GoChickenSaleStoreData.dart';

class Bottom extends StatefulWidget {
  final TabController tabController;
  const Bottom({Key? key, required this.tabController}) : super(key: key);

  @override
  _BottomState createState() => _BottomState();
}

class _BottomState extends State<Bottom> {

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {

      // 탭이 바뀔 때마다 호출됩니다.
      if (widget.tabController.indexIsChanging) {

        // 여기서 원하는 인덱스를 확인하고 해당 인덱스일 경우 원하는 함수를 호출합니다.
        if (widget.tabController.index == 1) { // 예를 들면 1번 인덱스 (즐겨찾기)를 클릭했을 경우

          setState(() {
            priceOrderDelivery();
            priceOrderPickUP();
          });

        }
      }
    });
  }

  Future priceOrderDelivery() async {
    goChickenSaleStoreData.sort((a, b) =>
        b["deliveryMaxDiscount"].compareTo(a["deliveryMaxDiscount"]));
  }

  Future priceOrderPickUP() async {
    goChickenSaleStoreData.sort((a, b) =>
        b["pickUpMaxDiscount"].compareTo(a["pickUpMaxDiscount"]));
  }

  @override
  void dispose() {
    widget.tabController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Container(
        height: 60,
        child: TabBar(
          controller: widget.tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home, size: 22,),child: Text('배달앱 치킨할인', style: TextStyle(fontSize: 9),),),
            Tab(icon: Icon(Icons.discount, size: 18,),child: Text('우리동네', style: TextStyle(fontSize: 9),),),
          ],
        ),
      ),
    );
  }
}
