import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class MessageBoardIcon extends StatelessWidget {
  MessageBoardIcon({Key key, this.message, this.onPressed}) : super(key: key);

  final String message;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.0),
      child: Badge(
          showBadge: true,
          badgeContent: Text("1"),
          badgeColor: Colors.orangeAccent,
          position: BadgePosition.topRight(right: 0, top: 0),
          child:
              IconButton(icon: Icon(Icons.warning), onPressed: this.onPressed)),
    );
  }
}
