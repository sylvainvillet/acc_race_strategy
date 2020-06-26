import 'package:flutter/material.dart';
import './race.dart';
import './utils.dart';

class RaceDetails extends StatelessWidget {
  final Race race;

  RaceDetails({Key key, @required this.race}) : super(key: key);

  final margin = 10.0;

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = List<Tab>();
    List<Widget> centralWidgets = List<Widget>();

    /*
    tabs.add(Tab(text: 'Info'));
    centralWidgets.add(raceInfo(context, race));
     */

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
      length: centralWidgets.length,
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
          buildRowTitle("Parameters"),
          SizedBox(height: margin),
          buildRow2Texts("Car:", race.car.displayName),
          SizedBox(height: margin),
          buildRow2Texts("Track:", race.track.displayName),
          SizedBox(height: margin),
          buildRow2Texts("Duration:", race.getRaceDurationString()),
          SizedBox(height: margin),
          buildRow2Texts("Average lap time:", getLapTimeString(race.lapTime)),
          SizedBox(height: margin),
          buildRow2Texts(
              "Formation lap:", race.formationLap == 1 ? 'Full' : 'Short'),
          SizedBox(height: margin),
          buildRow2Texts(
              "Mandatory pit stops:", race.mandatoryPitStops.toString()),
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
            buildRowTitle("Overview"),
            SizedBox(height: margin),
            buildRow2Texts("Laps:", strategy.nbOfLaps.toString()),
            SizedBox(height: margin),
            buildRow2Texts("Pit stops:", strategy.pitStops.length.toString()),
            SizedBox(height: margin),
            buildRow2Texts("Lower cut-off:", getLapTimeString(strategy.cutOffLow)),
            SizedBox(height: margin),
            buildRow2Texts("Higher cut-off:", getLapTimeString(strategy.cutOffHigh)),
            SizedBox(height: margin),
            buildRow2Texts(
                "Starting fuel:", strategy.startingFuel.toString() + ' L'),
            SizedBox(height: margin),
            buildRowTextAndWidget(
              "Fuel saving:",
              fuelSavingRow(strategy.fuelSaving),
              fontWeight: FontWeight.normal,
              flex: 1),
            SizedBox(height: 16.0),
            Divider(),
            SizedBox(height: 16.0),
            stintsAndPits(strategy),
          ],
        ),
      ),
    );
  }

  Widget fuelSavingRow(double fuelSaving) {
    int fuelSavingPercent = (fuelSaving * 100).ceil();
    if (fuelSavingPercent <= 0) {
      return Text('No');
    } else {
      Color signColor = Colors.blue;
      if (fuelSavingPercent > 15)
        signColor = Colors.red;
      else if (fuelSavingPercent > 10)
        signColor = Colors.orange;

      return Row(
        children: <Widget>[
          Text(fuelSavingPercent.toString() + ' %  '),
          Icon(IconData(57346,
              fontFamily: 'MaterialIcons'),
              size: 15,
          color: signColor,),
        ],
      );
    }
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
        buildRow3Texts(
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
        buildRow3Texts(
            'Pit stop ' + (index + 1).toString() + ':',
            'Lap ' + pitStop.pitStopLap.toString(),
            pitStop.fuelToAdd.toString() + ' L'),
        SizedBox(height: margin),
      ],
    );
  }
}
