import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import './mod/my_open_container.dart';
import './race.dart';
import './stint_details.dart';
import './utils.dart';

class RaceDetails extends StatelessWidget {
  final Race race;

  RaceDetails({Key key, @required this.race}) : super(key: key);

  final margin = 4.0;

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = List<Tab>();
    List<Widget> centralWidgets = List<Widget>();

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
      centralWidgets.add(strategyDetails(context, race.strategies[i]));
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

  Widget strategyDetails(BuildContext context, Strategy strategy) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.only(),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                leading: Icon(Icons.info_outline),
                title: Column(
                  children: <Widget>[
                    buildRow2Texts(
                        "Laps:",
                        ((race.formationLap == 1) ? 'Formation lap + ' : '') +
                            (strategy.nbOfLaps - race.formationLap).toString()),
                    SizedBox(height: margin),
                    buildRow2Texts(
                        "Pit stops:", strategy.pitStops.length.toString()),
                    SizedBox(height: margin),
                    buildRow2Texts(
                        "Race duration:", getHMMSSDurationString(race.realRaceDuration)),
                    SizedBox(height: margin),
                    buildRow2Texts(
                        "Average lap time:", getLapTimeString(strategy.realLapTime)),
                    SizedBox(height: margin),
                    buildRow2Texts(
                        "Lower cut-off:", getLapTimeString(strategy.cutOffLow)),
                    SizedBox(height: margin),
                    buildRow2Texts("Higher cut-off:",
                        getLapTimeString(strategy.cutOffHigh)),
                    SizedBox(height: margin),
                    buildRowTextAndWidget(
                        "Fuel saving:", fuelSavingRow(strategy.fuelSaving),
                        fontWeight: FontWeight.normal, flex: 1)
                  ],
                ),
              ),
            ),
            stintsAndPits(context, strategy),
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
      else if (fuelSavingPercent > 10) signColor = Colors.orange;

      return Row(
        children: <Widget>[
          Text(fuelSavingPercent.toString() + ' %  '),
          Icon(
            Icons.warning,
            size: 15,
            color: signColor,
          ),
        ],
      );
    }
  }

  Widget stintsAndPits(BuildContext context, Strategy strategy) {
    List<Widget> cards = [
      SizedBox(height: 4.0,),
      Card(
        margin: const EdgeInsets.only(),
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.flag, color: Colors.lightGreen),
          title: Text('Race start'),
          trailing: Text(strategy.startingFuel.toString() + ' L'),
        ),
      ),
    ];

    int rows = strategy.stints.length + strategy.pitStops.length;

    for (int i = 0; i < rows; i++) {
      cards.add(SizedBox(height: 4.0,));

      if (i % 2 == 0) {
        int stintIndex = (i / 2).floor();
        cards.add(stintWidget(
            context, strategy, stintIndex, strategy.stints[stintIndex]));
      } else {
        int pitStopIndex = (i / 2).floor();
        cards.add(pitStopWidget(pitStopIndex, strategy.pitStops[pitStopIndex]));
      }
    }

    return Container(
        child: Column(
      children: cards,
    ));
  }

  Widget stintWidget(
      BuildContext context, Strategy strategy, int index, Stint stint) {
    return MyOpenContainer(
      closedElevation: 5.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return ListTile(
          leading: Icon(Icons.directions_car),
          title: Text('Stint ' + (index + 1).toString()),
          subtitle: Text(((race.formationLap == 1 && index == 0)
                  ? 'Formation lap + ' + (stint.nbOfLaps - 1).toString()
                  : stint.nbOfLaps.toString()) +
              " laps"),
          trailing: Text(
              (stint.fuel / stint.nbOfLaps).toStringAsFixed(2) + ' L/lap'),
        );
      },
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return ThemeConsumer(
          child: StintDetails(
            race: race,
            strategy: strategy,
            stint: stint,
            stintIndex: index,
          ),
        );
      },
    );
  }

  Card pitStopWidget(int index, PitStop pitStop) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(),
      child: ListTile(
        leading: Icon(Icons.local_gas_station),
        title: Text('Pit stop ' + (index + 1).toString()),
        subtitle: Text('Lap ' +
            pitStop.pitStopLap.toString() +
            ', ' +
            getHMMSSDurationString(pitStop.raceTimeLeft) +
            ' left'),
        trailing: Text(pitStop.fuelToAdd.toString() + ' L'),
      ),
    );
  }
}
