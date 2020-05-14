import 'package:flutter/material.dart';
import 'package:token_system/Entities/authority.dart';
import 'package:token_system/components/shop_card.dart';
import 'package:token_system/components/tab_navigator.dart';
import 'package:token_system/screens/authority_profile/shop_view.dart';
import 'package:token_system/screens/shop_list.dart';

class MonitorShops extends StatelessWidget {
  final Authority user;
  final GlobalKey<TabNavigatorState> tn;

  MonitorShops({Key key, @required this.user, @required this.tn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Call shop list API to get all shops in a pin code
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Text(
          'Monitor and Track Shops',
          style: TextStyle(
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          itemCount: shops.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: InkWell(
                splashColor: Colors.blueGrey[300],
                onTap: () {
                  // View shop profile (from Authority view)
                  tn.currentState.push(
                    context,
                    payload: ShopProfile(user: user, shop: shops[index]),
                  );
                },
                child: SizedBox(
                  height: 80,
                  child: ShopCard(
                    shop: shops[index],
                    minimal: true,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}