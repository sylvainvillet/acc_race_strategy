import 'package:flutter/material.dart';
import './cars.dart';
import './tracks.dart';

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

  String returnValue = minutes.toString() + ':';

  if (seconds < 10) returnValue += '0';
  returnValue += seconds.toString() + '.';

  if (milliseconds < 100) returnValue += '0';
  if (milliseconds < 10) returnValue += '0';
  returnValue += milliseconds.toString();

  return returnValue;
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

Widget buildRow2Texts(String text1, String text2) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(text1),
      ),
      Expanded(
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
  String value;
  for (int i = min; i <= max; i += increment) {
    value = '';
    if (padding == 2 && i < 100) value += '0';
    if (padding >= 1 && i < 10) value += '0';
    value += i.toString();
    items.add(DropdownMenuItem(value: i, child: Text(value)));
  }
  return items;
}

Future<void> showSimplePopup(BuildContext context, String title, String content, {String button = 'Ok'}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
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