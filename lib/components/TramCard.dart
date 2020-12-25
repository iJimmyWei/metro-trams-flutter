import 'package:flutter/material.dart';

class TramCard extends StatelessWidget {
  TramCard({this.dest, this.line, this.waitTime, this.carriages, this.status});

  final String dest;
  final String line;
  final String waitTime;
  final String carriages;
  final String status;

  Widget build(BuildContext context) {
    return Card(
      child: (ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        trailing: RichText(
            text: TextSpan(
                children: status == "Arriving" || status == "Departing"
                    ? <TextSpan>[
                        TextSpan(
                          text: status,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ]
                    : <TextSpan>[
                        TextSpan(
                            text: "$waitTime ",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        TextSpan(
                          text: int.parse(waitTime) > 1 ? "mins" : "min",
                          style: TextStyle(color: Colors.black),
                        )
                      ])),
        title: Text('$dest', style: TextStyle(color: Colors.black)),
        subtitle: Text("$carriages Carriage"),
      )),
    );
  }
}
