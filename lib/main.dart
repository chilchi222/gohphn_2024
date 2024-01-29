import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:gohphn_2024/Root.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/ShareManager.dart';
import 'package:gohphn_2024/ShareHomeTownChickenSale/shareHomeTownChickenSale.dart';
import 'package:gohphn_2024/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );




  runApp(MyApp());


}



class MyApp extends StatelessWidget {
  // This widget is the root of your application


 static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
 static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [observer],
        title: '고픈, 오늘 할인하는 치킨은?',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
          primaryColor: Color(0xfff5f5f5),
          primarySwatch: ColorService.createMaterialColor(const Color(0xFFf5f5f5)),
          canvasColor: Color(0xffffffff)
        ),
      home: Root(analytics: analytics,),
      );
  }
}

class ColorService {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }



}