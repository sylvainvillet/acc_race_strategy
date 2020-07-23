import 'package:flutter/material.dart';
import './cars.dart';
import './tracks.dart';

String getCarSettingsKey(String className) {
  return 'carName-' + className;
}

String getFuelUsageSettingsKey(Track track, Car car) {
  return 'fuelUsage-' + track.ksName + '-' + car.ksName;
}

String getLapTimeSettingsKey(Track track, Car car) {
  return 'lapTime-' + track.ksName + '-' + car.className;
}

String getLapTimeString(double lapTime) {
  int minutes = (lapTime / 60).floor();
  int seconds = (lapTime - minutes * 60).floor();
  int milliseconds = ((lapTime - lapTime.floor()) * 1000).floor();

  return minutes.toString() +
      ':' +
      seconds.toString().padLeft(2, '0') +
      '.' +
      milliseconds.toString().padLeft(3, '0');
}

String getHMMDurationString(int seconds) {
  int hours = (seconds / 3600).floor();
  int minutes = (seconds / 60 - hours * 60).floor();

  return hours.toString() + 'h' + minutes.toString().padLeft(2, '0');
}

String getHMMSSDurationString(int seconds) {
  int hours = (seconds / 3600).floor();
  int minutes = (seconds / 60 - hours * 60).floor();
  seconds = seconds % 60;

  return hours.toString() + ':' + minutes.toString().padLeft(2, '0') + ':' + seconds.toString().padLeft(2, '0');
}

Widget buildRowTitle(String text) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      Spacer(),
    ],
  );
}

Widget buildRow2Texts(String text1, String text2, {int flex = 1}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(text1),
      ),
      Expanded(
        flex: flex,
        child: Text(text2),
      ),
    ],
  );
}

Widget buildRow3Texts(String text1, String text2, String text3) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(
          text1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Text(text2),
      ),
      Expanded(
        child: Text(text3),
      ),
    ],
  );
}

Widget buildRowTextAndWidget(String text, Widget inputWidget,
    {FontWeight fontWeight = FontWeight.bold, int flex = 2}) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(text, style: TextStyle(fontWeight: fontWeight)),
      ),
      Expanded(
        flex: flex,
        child: inputWidget,
      ),
    ],
  );
}

List<DropdownMenuItem<int>> getIntDropDownMenuItems(
    int min, int max, int increment, int padding) {
  List<DropdownMenuItem<int>> items = List();

  for (int i = min; i <= max; i += increment) {
    items.add(DropdownMenuItem(value: i, child: Text(i.toString().padLeft(padding, '0'))));
  }
  return items;
}

Future<void> showSimplePopup(BuildContext context, String title, Widget content,
    {String button = 'Ok'}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              content,
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(button),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
