import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metro_trams/components/textFieldButton.dart';
import 'package:metro_trams/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            TextFieldButton(
                text: 'Manchester',
                icon: Icon(Icons.search, color: Colors.pink),
                onPress: () => Navigator.pushNamed(context, '/search')),
            Text('You have pushed the button this many times:',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
