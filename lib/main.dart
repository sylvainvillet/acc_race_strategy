import 'package:flutter/material.dart';
import './race_input.dart';
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
        ),
        debugShowCheckedModeBanner: false,
        home: Center(
          child: AspectRatio(
            aspectRatio: 0.6,
            child: HomePage(title: 'ACC Strategist'),
          ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<PopupMenuItems>(
            itemBuilder: (context) =>
            [
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
      body: RaceInput(key: _key),
    );
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
