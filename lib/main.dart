import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './race_input.dart';
import './platform.dart';
import './utils.dart';

void main() {
  runApp(AccStrategistApp());
}

class AccStrategistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACC Strategist',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Center(
        child: HomePage(title: 'ACC Strategist'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

enum PopupMenuItems { about }

class _HomePageState extends State<HomePage> {
  final GlobalKey<RaceInputState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Platform platform = Platform();

    return AspectRatio(
      aspectRatio: platform.isMobile()
          ? MediaQuery.of(context).size.width /
              MediaQuery.of(context).size.height
          : 0.6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<PopupMenuItems>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: PopupMenuItems.about,
                  child: Text("About"),
                ),
              ],
              onSelected: (PopupMenuItems result) {
                switch (result) {
                  case PopupMenuItems.about:
                    _showAboutPopup(context);
                    break;
                }
              },
            )
          ],
        ),
        body: Column(
          children: [
            RaceInput(key: _key),
            SizedBox(height: 24.0,),
            InkWell(
              onTap: () {
                _openPlayStore();
              }, // handle your image tap here
              child: Image.asset(
                'assets/google_play_badge.png',
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openPlayStore() async {
    const url = 'https://play.google.com/store/apps/details?id=com.svillet.accstrategist';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showAboutPopup(BuildContext context) async {
    double margin = 10.0;
    showSimplePopup(
        context,
        'About',
        Column(
          children: <Widget>[
            Image(
              image: AssetImage('assets/lollipop_man.png'),
              width: 200,
              height: 200,
            ),
            SizedBox(height: margin),
            Text('Developed by Sylvain Villet'),
            SizedBox(height: margin),
            Text('Special thanks to ElderCold'),
          ],
        ));
  }
}
