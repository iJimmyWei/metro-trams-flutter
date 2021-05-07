import 'package:flutter/material.dart';

class SearchFieldButton extends StatelessWidget {
  const SearchFieldButton({Key key, this.text, this.icon, this.onPress})
      : super(key: key);

  final Icon icon;
  final String text;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Row(
            children: <Widget>[
              this.icon,
              Container(
                margin: EdgeInsets.only(left: 8.0),
                child: Text(
                  this.text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(color: Colors.white)),
        ],
      ),
      onPressed: this.onPress,
    );
  }
}
