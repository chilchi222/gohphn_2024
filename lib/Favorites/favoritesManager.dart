import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  List<String> userFavoriteList;
  final analytics;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool clickedFavoriteBox = false;
  String currentClickedFavoriteStore = '';
  List<Map<String, dynamic>> updatedFavorites = [];

  late ValueNotifier<List<String>> userFavoriteListNotifier;

  // 여기서부터 클래스 생성자를 정의
  FavoritesManager({
    required this.userFavoriteList,
    required this.analytics,
  }) {

  }

  void updateCountForStoreName(String storeName, bool changeValue) async {
    try {
      // 파이어베이스에 접속하고 컬렉션에 접근
      DocumentReference countingDocument = _firestore.collection('favoritesChickenBrandCounting').doc('counting');

      // 현재 storeName의 값을 가져옴
      DocumentSnapshot snapshot = await countingDocument.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // storeName에 해당하는 값을 증가 또는 감소
      if (data.containsKey(storeName)) {
        int currentCount = data[storeName] ?? 0;

        if (changeValue) {
          // changeValue가 true일 때는 +1
          int updatedCount = currentCount + 1;
          data[storeName] = updatedCount;
        } else if (currentCount > 0) {
          // changeValue가 false이고, 현재 값이 0보다 클 때만 -1 적용
          int updatedCount = currentCount - 1;
          data[storeName] = updatedCount;
        }

        // 업데이트된 데이터를 Firestore에 반영
        await countingDocument.update(data);
      }
    } catch (e) {
      print('값 업데이트 중 오류 발생: $e');
    }
  }

  Future<void> setUserFavoriteList(List<String> userFavoriteList) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList('userFavoriteList', userFavoriteList);
  }

}