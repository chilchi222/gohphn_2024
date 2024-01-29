import 'package:cloud_firestore/cloud_firestore.dart';

class ShareInfo {
  final String id;
  final String storeAddress;
  final String storePhoneNumber;
  final String fileName;
  final String imageUrl;
  final String brandName;
  final String branchName;
  final String discount;
  final String condition;
  final bool post;
  final Timestamp timestamp;

  ShareInfo({
    required this.id,
    required this.storePhoneNumber,
    required this.fileName,
    required this.imageUrl,
    required this.brandName,
    required this.branchName,
    required this.post,
    required this.timestamp,
    required this.storeAddress,
    required this.discount,
    required this.condition,
  });

  factory ShareInfo.fromMap(String id, Map<String, dynamic> data) {
    return ShareInfo(
      id: id,
      fileName: data['fileName'],
      imageUrl: data['imageUrl'],
      brandName: data['brandName'],
      branchName: data['branchName'],
      post: data['post'],
      timestamp: data['timestamp'],
      storeAddress: data['storeAddress'],
      storePhoneNumber: data['storePhoneNumber'],
      discount: data['discount'],
      condition: data['condition'],
    );
  }
}
