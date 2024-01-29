import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showCustomBottomSheet(BuildContext context, int index, int saleIndex, List chickenSaleData,  Function(bool) onVOCChanged, Map<String, dynamic> deliveryAppUrls) {

  // 배달앱 url 이동
  // void launchDeliveryApp(String appName) async {
  //   String? url;
  //
  //   bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  //   bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  //
  //   switch (appName) {
  //     case '배달의민족':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.sampleapp&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B0%B0%EB%8B%AC%EC%9D%98%EB%AF%BC%EC%A1%B1/id378084485?ppid=c30fb1ac-eb56-46ca-a0fe-8079ce20fde9'
  //           : 'https://play.google.com/store/apps/details?id=com.sampleapp&pcampaignid=web_share');
  //       break;
  //     case '배민1':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.sampleapp&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B0%B0%EB%8B%AC%EC%9D%98%EB%AF%BC%EC%A1%B1/id378084485?ppid=c30fb1ac-eb56-46ca-a0fe-8079ce20fde9'
  //           : 'https://play.google.com/store/apps/details?id=com.sampleapp&pcampaignid=web_share');
  //       break;
  //     case '요기요':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.fineapp.yogiyo&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B0%B0%EB%8B%AC%EC%9A%94%EA%B8%B0%EC%9A%94-%EA%B8%B0%EB%8B%A4%EB%A6%BC-%EC%97%86%EB%8A%94-%EB%A7%9B%EC%A7%91-%EB%B0%B0%EB%8B%AC%EC%95%B1/id543831532'
  //           : 'https://play.google.com/store/apps/details?id=com.fineapp.yogiyo&pcampaignid=web_share');
  //       break;
  //
  //     case '쿠팡이츠':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.coupang.mobile.eats&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EC%BF%A0%ED%8C%A1%EC%9D%B4%EC%B8%A0-%EB%B0%B0%EB%8B%AC%EC%95%B1/id1445504255'
  //           : 'https://play.google.com/store/apps/details?id=com.coupang.mobile.eats&pcampaignid=web_share');
  //       break;
  //
  //     case '위메프오':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wemakeprice.cupping&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EC%9C%84%EB%A9%94%ED%94%84%EC%98%A4/id1225077702'
  //           : 'https://play.google.com/store/apps/details?id=com.wemakeprice.cupping&pcampaignid=web_share');
  //       break;
  //
  //     case '땡겨요':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.shinhan.o2o.store&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%95%A1%EA%B2%A8%EC%9A%94/id1598850912'
  //           : 'https://play.google.com/store/apps/details?id=com.shinhan.o2o.store&pcampaignid=web_share');
  //       break;
  //
  //     case '배달특급':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kgcbrand.com.kgcdelivery_android&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B0%B0%EB%8B%AC%ED%8A%B9%EA%B8%89/id1530874203'
  //           : 'https://play.google.com/store/apps/details?id=kgcbrand.com.kgcdelivery_android&pcampaignid=web_share');
  //       break;
  //
  //     case 'BBQ앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kr.co.genesiskorea.bbqchicken&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/bbq-%EC%B9%98%ED%82%A8/id6463020512'
  //           : 'https://play.google.com/store/apps/details?id=kr.co.genesiskorea.bbqchicken&pcampaignid=web_share');
  //       break;
  //
  //     case 'BHC앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.foodtechkorea.bhc&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/bhc/id1559840791'
  //           : 'https://play.google.com/store/apps/details?id=com.foodtechkorea.bhc&pcampaignid=web_share');
  //       break;
  //
  //     case '교촌치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.order.kyochonchicken&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EA%B5%90%EC%B4%8C%EC%B9%98%ED%82%A8/id1540029579'
  //           : 'https://play.google.com/store/apps/details?id=com.order.kyochonchicken&pcampaignid=web_share');
  //       break;
  //     case '꾸브라꼬앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.kkubeurakko&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EA%BE%B8%EB%B8%8C%EB%9D%BC%EA%BC%AC%EC%88%AF%EB%B6%88%EB%91%90%EB%A7%88%EB%A6%AC%EC%B9%98%ED%82%A8/id1631965959'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.kkubeurakko&pcampaignid=web_share');
  //       break;
  //
  //     case '네네치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.fuse_smart_nene&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%84%A4%EB%84%A4%EC%B9%98%ED%82%A8/id1541274219'
  //           : 'https://play.google.com/store/apps/details?id=com.fuse_smart_nene&pcampaignid=web_share');
  //       break;
  //     case '순살만공격앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.sunsalmanattack&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EC%88%9C%EC%82%B4%EB%A7%8C%EA%B3%B5%EA%B2%A9/id1637753055'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.sunsalmanattack&pcampaignid=web_share');
  //       break;
  //
  //     case '처갓집치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.cheogajip&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EC%B2%98%EA%B0%93%EC%A7%91%EC%96%91%EB%85%90%EC%B9%98%ED%82%A8/id1660491555'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.cheogajip&pcampaignid=web_share');
  //       break;
  //
  //     case '푸라닭치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.puradakchicken&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%ED%91%B8%EB%9D%BC%EB%8B%AD-%EC%B9%98%ED%82%A8/id6444139679'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.puradakchicken&pcampaignid=web_share');
  //       break;
  //
  //     case '굽네치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kr.co.goobne.chicken&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EA%B5%BD%EB%84%A4%EC%B9%98%ED%82%A8/id6444176130'
  //           : 'https://play.google.com/store/apps/details?id=kr.co.goobne.chicken&pcampaignid=web_share');
  //       break;
  //
  //     case 'KFC앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kfc_ko.kore.kg.kfc_korea&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/kfc-korea/id1255799839'
  //           : 'https://play.google.com/store/apps/details?id=kfc_ko.kore.kg.kfc_korea&pcampaignid=web_share');
  //       break;
  //
  //     case '멕시카나앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kr.sponge.mexicanadelivery&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%A9%95%EC%8B%9C%EC%B9%B4%EB%82%98%EC%B9%98%ED%82%A8/id1560262136'
  //           : 'https://play.google.com/store/apps/details?id=kr.sponge.mexicanadelivery&pcampaignid=web_share');
  //       break;
  //
  //     case '치킨플러스앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=co.kr.waldlust.chickenplus&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EC%B9%98%ED%82%A8%ED%94%8C%EB%9F%AC%EC%8A%A4-%EB%A7%88%EC%9D%B4%EC%B9%98%ED%94%8C/id1643666724'
  //           : 'https://play.google.com/store/apps/details?id=co.kr.waldlust.chickenplus&pcampaignid=web_share');
  //       break;
  //
  //     case '걸작떡볶이앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.eguljak&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EA%B1%B8%EC%9E%91%EB%96%A1%EB%B3%B6%EC%9D%B4%EC%B9%98%ED%82%A8/id6447655816'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.eguljak&pcampaignid=web_share');
  //       break;
  //
  //     case '맘스터치앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=kr.co.haimarrow.moms&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%A7%98%EC%8A%A4%ED%84%B0%EC%B9%98/id1535574554'
  //           : 'https://play.google.com/store/apps/details?id=kr.co.haimarrow.moms&pcampaignid=web_share');
  //       break;
  //
  //     case '60계치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.jangsfood.order60ck&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/60%EA%B3%84%EC%B9%98%ED%82%A8/id6446163806'
  //           : 'https://play.google.com/store/apps/details?id=com.jangsfood.order60ck&pcampaignid=web_share');
  //       break;
  //
  //     case '또래오래앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.toreore&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%98%90%EB%9E%98%EC%98%A4%EB%9E%98/id6448499435'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.toreore&pcampaignid=web_share');
  //       break;
  //
  //     case '바른치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.barunchicken&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B0%94%EB%A5%B8%EC%B9%98%ED%82%A8/id6447659189'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.barunchicken&pcampaignid=web_share');
  //       break;
  //
  //     case '부어치킨앱':
  //       url = isAndroid
  //           ? 'https://play.google.com/store/apps/details?id=com.wmpoplus.boor&pcampaignid=web_share'
  //           : (isIOS
  //           ? 'https://apps.apple.com/kr/app/%EB%B6%80%EC%96%B4%EC%B9%98%ED%82%A8/id1592229750'
  //           : 'https://play.google.com/store/apps/details?id=com.wmpoplus.boor&pcampaignid=web_share');
  //       break;
  //
  //     default:
  //       print('Unknown delivery app: $appName');
  //       return;
  //   }
  //
  //   if (url != null && await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }

  // 앱 링크를 실행하는 함수 (파이어베이스의 링크값을 Map형태로 읽은 값을 사용)
  void launchDeliveryApp(String appName) async {
      String? url;

      deliveryAppUrls['배달의민족']['ios'];
      bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
      bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

      switch (appName) {
        case '배달의민족':
          url = isAndroid
              ? '${deliveryAppUrls['배달의민족']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['배달의민족']['ios']}'
              : '${deliveryAppUrls['배달의민족']['android']}');
          break;
        case '배민1':
          url = isAndroid
              ? '${deliveryAppUrls['배달의민족']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['배달의민족']['ios']}'
              : '${deliveryAppUrls['배달의민족']['android']}');
          break;
        case '요기요':
          url = isAndroid
              ? '${deliveryAppUrls['요기요']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['요기요']['ios']}'
              : '${deliveryAppUrls['요기요']['android']}');
          break;

        case '쿠팡이츠':
          url = isAndroid
              ? '${deliveryAppUrls['쿠팡이츠']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['쿠팡이츠']['ios']}'
              : '${deliveryAppUrls['쿠팡이츠']['android']}');
          break;

        case '위메프오':
          url = isAndroid
              ? '${deliveryAppUrls['위메프오']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['위메프오']['ios']}'
              : '${deliveryAppUrls['위메프오']['android']}');
          break;

        case '땡겨요':
          url = isAndroid
              ? '${deliveryAppUrls['땡겨요']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['땡겨요']['ios']}'
              : '${deliveryAppUrls['땡겨요']['android']}');
          break;

        case '배달특급':
          url = isAndroid
              ? '${deliveryAppUrls['배달특급']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['배달특급']['ios']}'
              : '${deliveryAppUrls['배달특급']['android']}');
          break;

        case 'BBQ앱':
          url = isAndroid
              ? '${deliveryAppUrls['BBQ앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['BBQ앱']['ios']}'
              : '${deliveryAppUrls['BBQ앱']['android']}');
          break;

        case 'BHC앱':
          url = isAndroid
              ? '${deliveryAppUrls['BHC앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['BHC앱']['ios']}'
              : '${deliveryAppUrls['BHC앱']['android']}');
          break;

        case '교촌치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['교촌치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['교촌치킨앱']['ios']}'
              : '${deliveryAppUrls['교촌치킨앱']['android']}');
          break;
        case '꾸브라꼬앱':
          url = isAndroid
              ? '${deliveryAppUrls['꾸브라꼬앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['꾸브라꼬앱']['ios']}'
              : '${deliveryAppUrls['꾸브라꼬앱']['android']}');
          break;

        case '네네치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['네네치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['네네치킨앱']['ios']}'
              : '${deliveryAppUrls['네네치킨앱']['android']}');
          break;
        case '순살만공격앱':
          url = isAndroid
              ? '${deliveryAppUrls['순살만공격앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['순살만공격앱']['ios']}'
              : '${deliveryAppUrls['순살만공격앱']['android']}');
          break;

        case '처갓집치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['처갓집치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['처갓집치킨앱']['ios']}'
              : '${deliveryAppUrls['처갓집치킨앱']['android']}');
          break;

        case '푸라닭치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['푸라닭치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['푸라닭치킨앱']['ios']}'
              : '${deliveryAppUrls['푸라닭치킨앱']['android']}');
          break;

        case '굽네치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['굽네치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['굽네치킨앱']['ios']}'
              : '${deliveryAppUrls['굽네치킨앱']['android']}');
          break;

        case 'KFC앱':
          url = isAndroid
              ? '${deliveryAppUrls['KFC앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['KFC앱']['ios']}'
              : '${deliveryAppUrls['KFC앱']['android']}');
          break;

        case '멕시카나앱':
          url = isAndroid
              ? '${deliveryAppUrls['멕시카나앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['멕시카나앱']['ios']}'
              : '${deliveryAppUrls['멕시카나앱']['android']}');
          break;

        case '치킨플러스앱':
          url = isAndroid
              ? '${deliveryAppUrls['치킨플러스앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['치킨플러스앱']['ios']}'
              : '${deliveryAppUrls['치킨플러스앱']['android']}');
          break;

        case '걸작떡볶이앱':
          url = isAndroid
              ? '${deliveryAppUrls['걸작떡볶이앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['걸작떡볶이앱']['ios']}'
              : '${deliveryAppUrls['걸작떡볶이앱']['android']}');
          break;

        case '맘스터치앱':
          url = isAndroid
              ? '${deliveryAppUrls['맘스터치앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['맘스터치앱']['ios']}'
              : '${deliveryAppUrls['맘스터치앱']['android']}');
          break;

        case '60계치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['60계치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['60계치킨앱']['ios']}'
              : '${deliveryAppUrls['60계치킨앱']['android']}');
          break;

        case '또래오래앱':
          url = isAndroid
              ? '${deliveryAppUrls['또래오래앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['또래오래앱']['ios']}'
              : '${deliveryAppUrls['또래오래앱']['android']}');
          break;

        case '바른치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['바른치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['바른치킨앱']['ios']}'
              : '${deliveryAppUrls['바른치킨앱']['android']}');
          break;

        case '부어치킨앱':
          url = isAndroid
              ? '${deliveryAppUrls['부어치킨앱']['android']}'
              : (isIOS
              ? '${deliveryAppUrls['부어치킨앱']['ios']}'
              : '${deliveryAppUrls['부어치킨앱']['android']}');
          break;

        default:
          print('Unknown delivery app: $appName');
          return;
      }

      if (url != null && await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch $url');
      }
  }

  String _appName = chickenSaleData[index]['delivery'][saleIndex].deliveryApp;

  showBottomSheet(
    context: context,
    builder: (context) {
      return Stack(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '바로가기',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'GmarketSansBold',
                          color: Color(0xff000000),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          onVOCChanged(false);
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Container(
                    height: 220,
                    color: Color(0xfff5f5f5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              Container(
                                width : 18,
                                height : 18,
                                decoration: BoxDecoration(
                                    color: Color(0xfffa6565),
                                    shape: BoxShape.circle
                                ),
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              //앱명 옆에 앱 표시 (자사앱은 이미 뒤에 앱이 적혀있음)
                              Text('${_appName == '배민1'
                                  ? '배달의민족 앱'
                                  : _appName == '배달의민족'
                                  ?  '배달의민족 앱'
                                  : _appName == '요기요' ? '요기요 앱'
                                  : _appName == '쿠팡이츠'
                                  ? '쿠팡이츠 앱'
                                  : _appName == '땡겨요'
                                  ? '땡겨요 앱'
                                  : _appName == '위메프오'
                                  ? '위메프오 앱'
                                  : _appName == '배달특급'
                                  ? '배달특급 앱'
                                  : _appName}',

                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "GmarketSansMedium",
                                    color: Color(
                                        0xfffa6565)), ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    launchDeliveryApp(chickenSaleData[index]['delivery'][saleIndex].deliveryApp);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width > 450 ? 400 : 320,
                    height: MediaQuery.of(context).size.width > 450 ? 72 : 60,
                    color: Color(0xfffa6565),
                    child: Center(child: Text('GO-')),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      );
    },
  );



}