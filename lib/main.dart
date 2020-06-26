import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import './race_input.dart';
import './utils.dart';

void main() {
  runApp(AccStrategistApp());
}

class AccStrategistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strategist',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'ACC Strategist'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

enum PopupMenuItems { resetLapTimes, resetFuelUsages, about }

class _HomePageState extends State<HomePage> {
  final GlobalKey<RaceInputState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<PopupMenuItems>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: PopupMenuItems.resetLapTimes,
                child: Text("Reset lap times"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.resetFuelUsages,
                child: Text("Reset fuel usages"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.about,
                child: Text("About"),
              ),
            ],
            onSelected: (PopupMenuItems result) {
              switch (result) {
                case PopupMenuItems.resetLapTimes:
                  _showResetLapTimesPopup(context);
                  break;
                case PopupMenuItems.resetFuelUsages:
                  _showResetFuelUsagesPopup(context);
                  break;
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

  void _showResetLapTimesPopup(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _key.currentState.resetLapTimes();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset lap times',
            Text('Lap times have been reset to default values.'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset lap times"),
      content: Text(
          "Are you sure you want to reset the lap times to default values?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showResetFuelUsagesPopup(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _key.currentState.resetFuelUsages();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset fuel usages',
            Text('Fuel usages have been reset to default values.'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset fuel usages"),
      content: Text(
          "Are you sure you want to reset the fuel usages to default values?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showAboutPopup(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

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
            Text(packageInfo.appName + ' v' + packageInfo.version,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: margin),
            Text('Developped by Sylvain Villet'),
            SizedBox(height: margin),
            Text('Special thanks to ElderCold'),
          ],
        ));
  }
}
