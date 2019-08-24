import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({Key key, this.icon, this.inputField})
      : super(key: key);

  final Icon icon;
  final TextField inputField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Row(
            children: <Widget>[
              this.icon,
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: this.inputField
              ),
              )
            ],
          ),
          Divider(color: Colors.white),
        ],
      ),
    );
  }
}


