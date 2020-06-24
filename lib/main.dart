import 'package:accracestrategy/race_overview.dart';
import 'package:flutter/material.dart';
import './race_input.dart';
import './race.dart';
import './tracks.dart';
import './cars.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACC Race Strategy',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ACC Race Strategy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /*
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 2,
                child: Text("Lap times"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Fuel usage"),
              ),
              PopupMenuItem(
                value: 4,
                child: Text("Strategy parameters"),
              ),
              PopupMenuItem(
                value: 5,
                child: Text("About"),
              ),
            ],
          )
        ],*/
      ),
      body: RaceInput(),
    );
  }
/*
  Widget _raceList() {
    if (_races.isEmpty) {
      return Center(
          child: Text('Tap the "+" button to enter a new race.')
          );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _races.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          // Reverse order to have the most recent on top
          final index = _races.length - i ~/ 2 - 1;

          return ListTile(
            title: Text(_races[index].getCarTrackAndDuration()),
            onTap: () {
              _editRace(_races[index]);
            },
          );
        },
      );
    }
  }*/
}