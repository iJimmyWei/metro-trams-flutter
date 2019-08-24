import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_trams/components/TextFieldInput.dart';
import 'package:metro_trams/constants.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kBackgroundColour),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            TextFieldInput(
                icon: Icon(Icons.search, color: Colors.pink),
                inputField: TextField(
                    autofocus: true,
                    onChanged: (value) => print(value),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Manchester',
                        hintStyle: TextStyle(color: Colors.white),
                    )
                ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Icon(Icons.youtube_searched_for, color: Colors.pinkAccent, size: 100)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text('Enter a few words to search a station on Metro Trams',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            )
          ],
        ),
      ),
    );
  }
}
