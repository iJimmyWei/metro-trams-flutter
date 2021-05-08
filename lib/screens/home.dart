import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_trams/components/message_board_button.dart';
import 'package:metro_trams/components/search_field_button.dart';
import 'package:metro_trams/components/tram_card.dart';
import 'package:metro_trams/constants.dart';

import '../services/network.dart';
import '../services/responseDto.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  NetworkHelper networkHelper = NetworkHelper();
  String stationLocation = "Manchester Airport";
  List<Station> stationPlatforms;
  Timer timer;

  @override
  void initState() {
    super.initState();

    getLatestStationData();

    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => getLatestStationData());

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer.cancel();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> getLatestStationData() async {
    var data = await networkHelper.getStationData(this.stationLocation);

    this.setState(() => stationPlatforms = data);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var appInBackground = state != AppLifecycleState.resumed;
    if (appInBackground) {
      timer.cancel();
      return;
    }

    setState(() {
      timer = Timer.periodic(
          Duration(seconds: 10), (Timer t) => getLatestStationData());
    });
  }

  void getStationName() async {
    var name = await Navigator.pushNamed(context, '/search');

    if (name != null) {
      this.setState(() => stationLocation = name);

      // Force update
      getLatestStationData();
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 5),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var showMessageBoardIcon = stationPlatforms != null &&
        stationPlatforms[0].messageBoard.length > 0 &&
        stationPlatforms[0].messageBoard !=
            "<no message>"; // Bug in the manchester API showing this

    return Scaffold(
      backgroundColor: Color(kBackgroundColour),
      appBar: AppBar(
        title: Text(widget.title),
        actions: showMessageBoardIcon
            ? <Widget>[
                MessageBoardIcon(
                    message: stationPlatforms[0].messageBoard,
                    onPressed: () =>
                        showInSnackBar(stationPlatforms[0].messageBoard))
              ]
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: getLatestStationData,
        child: Column(
          children: <Widget>[
            SearchFieldButton(
              text: stationLocation,
              icon: Icon(Icons.search, color: Colors.pink),
              onPress: getStationName,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    stationPlatforms != null ? stationPlatforms.length : 0,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: Text(
                              "Platform ${index + 1}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 32.0),
                            child: Column(children: <Widget>[
                              for (var t in stationPlatforms[index]
                                  .trams
                                  .where((t) => t.dest != ""))
                                TramCard(
                                    dest: t.dest,
                                    line: stationPlatforms[index].line,
                                    waitTime: t.waitTime,
                                    carriages: t.carriages,
                                    status: t.status)
                            ]),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
