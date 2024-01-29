import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/BottomNavigationBar/bottom_bar.dart';
import 'package:gohphn_2024/MobileHome.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/ShareManager.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/shareHomeTownChickenSale.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BottomNavigationPage extends StatefulWidget {
  final int? startApp;
  final goHome;
  final int myVisit;
  final analytics;
  final Map<String, dynamic> deliveryAppUrls;
  final List<String> userFavoriteList;

  const BottomNavigationPage({
    Key? key,
    required this.startApp,
    required this.goHome,
    required this.myVisit,
    required this.analytics,
    required this.userFavoriteList,
    required this.deliveryAppUrls,
  }) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  // 할인정보 공유
  late ShareManager _ShareManager;

  List<ShareInfo> shareInfoList = [];
  String selectedCity = '';
  String selectedDistrict = '';
  String location = '';

  // SharedPreferences에서 저장된 지역 정보를 불러오는 함수
  Future<void> getUpdatedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCity = prefs.getString('selectedCity') ?? '전체';
      selectedDistrict = prefs.getString('selectedDistrict') ?? '';
      location = selectedCity == '전체' ? '전체' : '$selectedCity $selectedDistrict';
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    // 치킨할인정보 공유 클래스
    getUpdatedLocation();
    _ShareManager = ShareManager(shareInfoList, selectedCity, selectedDistrict, location);
    _ShareManager.loadImagesAndHandlePage(context, manager: false, );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          MobileHome(startApp: widget.startApp!,
              goHome: widget.goHome,
              myVisit: widget.myVisit,
              analytics: widget.analytics,
              deliveryAppUrls: widget.deliveryAppUrls,
              userFavoriteList: widget.userFavoriteList,
              tabController: _tabController, shareInfoList: shareInfoList,),

          ShareHomeTownChickenSale(shareInfoList: shareInfoList,
              selectedCity: selectedCity,
              selectedDistrict: selectedDistrict,
              location: location),
        ],
      ),
      bottomNavigationBar: Bottom(tabController: _tabController),
    );
  }
}
