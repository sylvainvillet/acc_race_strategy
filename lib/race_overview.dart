import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './cars.dart';
import './tracks.dart';
import './race.dart';
import './race_input.dart';

class RaceDetails extends StatelessWidget {
  final Race race;

  RaceDetails({Key key, @required this.race}) : super(key: key);

  final margin = 10.0;

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = List<Tab>();
    List<Widget> centralWidgets = List<Widget>();

    tabs.add(Tab(text: 'Info'));
    centralWidgets.add(raceInfo(context, race));

    if (race.strategies.length == 1) {
      tabs.add(Tab(text: 'Strategy'));
    } else if (race.strategies.length == 2) {
      tabs.add(Tab(text: 'Strategy 1'));
      tabs.add(Tab(text: 'Strategy 2'));
    } else if (race.strategies.length > 2) {
      for (int i = 1; i <= race.strategies.length; i++) {
        tabs.add(Tab(text: i.toString()));
      }
    }

    for (int i = 0; i < race.strategies.length; i++) {
      centralWidgets.add(strategyDetails(race.strategies[i]));
    }

    return DefaultTabController(
      length: race.strategies.length + 1,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs,
          ),
          title: Text(race.getTrackAndDuration()),
        ),
        body: TabBarView(
          children: centralWidgets,
        ),
      ),
    );
  }

  Widget raceInfo(BuildContext context, Race race) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: <Widget>[
          _buildRowTitle("Parameters"),
          SizedBox(height: margin),
          _buildRow2("Car:", race.car.displayName),
          SizedBox(height: margin),
          _buildRow2("Track:", race.track.displayName),
          SizedBox(height: margin),
          _buildRow2("Duration:", race.getRaceDurationString()),
          SizedBox(height: margin),
          _buildRow2("Average lap time:", race.getLapTimeString()),
          SizedBox(height: margin),
          _buildRow2("Formation lap:", race.formationLap),
          SizedBox(height: margin),
          _buildRow2("Mandatory pit stops:", race.mandatoryPitStops.toString()),
          SizedBox(height: margin),
        ],
      ),
    );
  }

  Widget strategyDetails(Strategy strategy) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            _buildRowTitle("Overview"),
            SizedBox(height: margin),
            _buildRow2("Laps:", strategy.nbOfLaps.toString()),
            SizedBox(height: margin),
            _buildRow2("Pit stops:", strategy.pitStops.length.toString()),
            SizedBox(height: margin),
            _buildRow2(
                "Starting fuel:", strategy.startingFuel.toString() + ' L'),
            SizedBox(height: margin),
            _buildRow2(
                "Fuel saving:",
                strategy.fuelSaving > 0
                    ? (strategy.fuelSaving * 100).toStringAsFixed(0) + ' %'
                    : 'No'),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            stintsAndPits(strategy),
          ],
        ),
      ),
    );
  }

  Widget stintsAndPits(Strategy strategy) {
    List<Widget> widgets = List<Widget>();

    int rows = strategy.stints.length + strategy.pitStops.length;

    for (int i = 0; i < rows; i++) {
      if (i % 2 == 0) {
        int stintIndex = (i / 2).floor();
        widgets.add(stintWidget(stintIndex, strategy.stints[stintIndex]));
      } else {
        int pitStopIndex = (i / 2).floor();
        widgets
            .add(pitStopWidget(pitStopIndex, strategy.pitStops[pitStopIndex]));
      }
      widgets.add(SizedBox(height: margin));
    }

    return Container(
        child: Column(
      children: widgets,
    ));
  }

  Widget stintWidget(int index, Stint stint) {
    return Column(
      children: <Widget>[
        _buildRow3(
            'Stint ' + (index + 1).toString() + ':',
            stint.nbOfLaps.toString() + " laps",
            (stint.fuel / stint.nbOfLaps).toStringAsFixed(2) + ' L/lap'),
        SizedBox(height: margin),
      ],
    );
  }

  Widget pitStopWidget(int index, PitStop pitStop) {
    return Column(
      children: <Widget>[
        _buildRow3(
            'Pit stop ' + (index + 1).toString() + ':',
            'Lap ' + pitStop.pitStopLap.toString(),
            pitStop.fuelToAdd.toString() + ' L'),
        SizedBox(height: margin),
      ],
    );
  }

  Widget _buildRowTitle(String text) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildRow2(String text1, String text2) {
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

  Widget _buildRow3(String text1, String text2, String text3) {
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

}
