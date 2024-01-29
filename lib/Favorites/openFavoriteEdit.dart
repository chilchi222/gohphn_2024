import 'package:flutter/material.dart';
import 'package:gohphn_2024/GoChickenSaleStoreData.dart';
import 'package:gohphn_2024/favorites/favoritesManager.dart';
import 'package:gohphn_2024/filter/chickenSaleFilter.dart';

class OpenFavoriteEdit extends StatefulWidget {

  final FavoritesManager favoritesManager;
  final SortingManager sortingManager;
  final VoidCallback onToggleFavoritesEditPage;

  const OpenFavoriteEdit({Key? key, required this.favoritesManager, required this.sortingManager, required this.onToggleFavoritesEditPage}) : super(key: key);

  @override
  State<OpenFavoriteEdit> createState() => _OpenFavoriteEditState();
}

class _OpenFavoriteEditState extends State<OpenFavoriteEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [

                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: widget.onToggleFavoritesEditPage,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,),
                        child: Icon(Icons.navigate_before, size: 36,),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: goChickenSaleStoreData.length,
                  itemBuilder: (BuildContext context, int index) {

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4,0,0,10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 치킨집 이름
                          Padding(
                            padding: const EdgeInsets.only(bottom : 12.0),
                            child: Row(
                              children: [
                                Text(
                                  '${goChickenSaleStoreData[index]['storeName']}',
                                  style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'GmarketSansMedium'),
                                ),

                                Spacer(),

                                GestureDetector(
                                    behavior: HitTestBehavior
                                        .translucent,
                                    onTap: () {

                                      setState(() {

                                        if (!widget.favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])) {

                                          widget.favoritesManager.userFavoriteList.add(goChickenSaleStoreData[index]['storeName']);
                                          widget.favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], true);
                                          widget.favoritesManager.setUserFavoriteList(widget.favoritesManager.userFavoriteList);

                                        } else {

                                          widget.favoritesManager.userFavoriteList.remove(goChickenSaleStoreData[index]['storeName']);
                                          widget.favoritesManager.updateCountForStoreName(goChickenSaleStoreData[index]['storeName'], false);
                                          widget.favoritesManager.setUserFavoriteList(widget.favoritesManager.userFavoriteList);

                                        }
                                      });

                                    },
                                    child: Icon(
                                      Icons.favorite, size: 20,
                                      color:
                                      widget.favoritesManager.userFavoriteList.contains(goChickenSaleStoreData[index]['storeName'])
                                          ? Color(0xfffa6565)
                                          : Color(0xffcdcdcd),)),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xffcdcdcd),
                            height: 0.5,
                          ),




                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
