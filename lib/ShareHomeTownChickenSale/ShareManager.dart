import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gohphn_2024/shareHomeTownChickenSale/shareInfo.dart';

class ShareManager {

  final List<ShareInfo> shareInfoList;
  final String selectedCity;
  final String selectedDistrict;
  final String location;

  ShareManager(this.shareInfoList, this.selectedCity, this.selectedDistrict, this.location);

  // 이미지 로딩
  Future<void> loadImagesAndHandlePage(BuildContext context, {required bool manager} ) async {
    getShareInfo(context, manager);
  }

  Future<void> getShareInfo(BuildContext context, bool manager) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('shareSaleImage').get();

    shareInfoList.clear();

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      if(manager == true) {
        shareInfoList.add(ShareInfo.fromMap(doc.id, data));

      } else {
        if (data['post'] == true) {
          shareInfoList.add(ShareInfo.fromMap(doc.id, data));
        }
      }
    }

    // Timestamp 기반으로 리스트 정렬 (최신순)
    shareInfoList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    precacheImages(context, shareInfoList);
  }

  //  이미지 사전 로딩
  void precacheImages(BuildContext context, List<ShareInfo> shareInfoList) {
    for (var shareInfo in shareInfoList) {
      final imageProvider = CachedNetworkImageProvider(shareInfo.imageUrl);

      precacheImage(imageProvider, context);

    }
  }

}