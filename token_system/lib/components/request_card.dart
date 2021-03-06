import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String openingTime;
  final String closingTime;
  final int maxCapacity;
  final String timestamp;
  final int status;
  final String authMobile;

  RequestCard({
    Key key,
    @required this.openingTime,
    @required this.closingTime,
    @required this.maxCapacity,
    @required this.timestamp,
    @required this.status,
    @required this.authMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderColor;
    var statusText;
    var icon;
    switch (this.status) {
      case 0:
        borderColor = Colors.lightBlue[100];
        statusText = 'Rejected';
        icon = Icons.do_not_disturb_alt;
        break;
      case 1:
        borderColor = Colors.greenAccent;
        statusText = 'Accepted';
        icon = Icons.done_all;
        break;
      case 2:
        borderColor = Colors.amber[300];
        statusText = 'Pending';
        icon = Icons.done;
        break;
      default:
    }

    return Card(
      child: DottedBorder(
        color: borderColor,
        dashPattern: [8, 4],
        strokeWidth: 2,
        padding: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          Ink(
            child: ListTile(
                leading: Icon(
                  icon,
                  size: 36,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      maxCapacity == 0
                          ? 'Timings:  ' + openingTime + ' - ' + closingTime
                          : 'Capacity: ' + maxCapacity.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
//                    Text(
//                      'Close: ' + closeTime,
//                      style: TextStyle(fontSize: 18),
//                    ),
                  ],
                ),
                subtitle: Visibility(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.phone, size:20),
                          Text(' Authority')
                        ]
                      ),
                      Row(
                        children: <Widget>[
                          Text(authMobile),
                        ],
                      ),
                    ],
                  ),
                  visible: status != 2,)
            ),
            color: borderColor,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Chip(
                backgroundColor: Colors.grey[400],
                label: Text(statusText),
                padding: EdgeInsets.all(5),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Chip(
                backgroundColor: Colors.grey[400],
                label: Text(timestamp),
                padding: EdgeInsets.all(5),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
