class Store {
  int? storeNum;
  String? storeName;
  String? deliveryApp;
  int? discount;
  int? minimumOrder;
  bool? delivery;
  bool? pickUp;
  bool? today;
  String? etc;

  Store(
      {
        this.storeNum,
        this.storeName,
        this.deliveryApp,
        this.discount,
        this.minimumOrder,
        this.delivery,
        this.pickUp,
        this.today,
        this.etc
      });

  Store.fromJson(Map<String, dynamic> json) {
    storeNum = json['storeNum'];
    storeName = json['store'];
    deliveryApp = json['deliveryApp'];
    discount = json['discount'];
    minimumOrder = json['minimumOrder'];
    delivery = json['delivery'];
    pickUp = json['pickUp'];
    today = json['today'];
    etc = json['etc'];
  }


}