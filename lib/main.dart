import 'package:flutter/material.dart';
import './race_input.dart';
import './utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strategist',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ACC Strategist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum PopupMenuItems { resetLapTimes, resetFuelUsages, about }

class _MyHomePageState extends State<MyHomePage> {
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
                  showSimplePopup(context, 'About', 'ACC Strategist v1.0.0\nDevelopped by Sylvain Villet');
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
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        _key.currentState.resetLapTimes();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset lap times', 'Lap times have been reset to default values.');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset lap times"),
      content: Text("Are you sure you want to reset the lap times to default values?"),
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
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        _key.currentState.resetFuelUsages();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset fuel usages', 'Fuel usages have been reset to default values.');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset fuel usages"),
      content: Text("Are you sure you want to reset the fuel usages to default values?"),
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
}
