import 'dart:convert';
import 'package:http/http.dart' as http;
import 'GoChickenSaleFromJson.dart';


List<Store> goChickenSaleStoreList = [];
List<Store> goChickenSaleInfoList = [];


Future readChickenSaleInfo(String uri) async {


  goChickenSaleStoreList.clear();
  goChickenSaleInfoList.clear();



  final chickenResponse = await http.get(Uri.parse(uri));
  var chickenSaleInfoJsonData = await jsonDecode(utf8.decode(chickenResponse.bodyBytes));

  chickenSaleInfoJsonData.forEach((e) {
    Store chickenSale = Store.fromJson(e);
    goChickenSaleInfoList.add(chickenSale);




  });



}