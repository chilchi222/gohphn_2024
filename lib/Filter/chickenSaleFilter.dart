import 'package:gohphn_2024/GoChickenSaleStoreData.dart';
import 'package:gohphn_2024/GoChickenSaleStoreTop20Data.dart';

class SortingManager {

  bool deliveryOrNot = true;
  bool top20 = true;
  bool maxDiscountFilter = true;
  bool filterLoading = false;

  Future priceOrderTop20Delivery() async {
    goChickenSaleStoreTop20Data.sort((a,b) => b["deliveryMaxDiscount"].compareTo(a["deliveryMaxDiscount"]));
  }

  Future priceOrderTop20PickUP() async {
    goChickenSaleStoreTop20Data.sort((a,b) => b["pickUpMaxDiscount"].compareTo(a["pickUpMaxDiscount"]));
  }

  Future priceOrderDelivery()async{
    goChickenSaleStoreData.sort((a,b) => b["deliveryMaxDiscount"].compareTo(a["deliveryMaxDiscount"]));
  }

  Future priceOrderPickUP()async{
    goChickenSaleStoreData.sort((a,b) => b["pickUpMaxDiscount"].compareTo(a["pickUpMaxDiscount"]));
  }

  Future branchOrderTop20()async{
    goChickenSaleStoreTop20Data.sort((a,b) => a["storeNum"].compareTo(b["storeNum"]));
  }

  Future branchOrder()async{
    goChickenSaleStoreData.sort((a,b) => a["storeNum"].compareTo(b["storeNum"]));
  }
}