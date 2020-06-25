import 'package:flutter/material.dart';

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
