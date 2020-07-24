import 'package:flutter/material.dart';
import './race.dart';
import './utils.dart';

class StintDetails extends StatelessWidget {
  final Race race;
  final Strategy strategy;
  final Stint stint;
  final int stintIndex;

  StintDetails(
      {Key key,
      @required this.race,
      @required this.strategy,
      @required this.stint,
      @required this.stintIndex})
      : super(key: key);

  final margin = 4.0;

  @override
  Widget build(BuildContext context) {
    final fuelPerLap = stint.fuel / stint.nbOfLaps;

    return Scaffold(
      appBar: AppBar(
        title: Text('Stint ' + (stintIndex + 1).toString()),
      ),
      body: PageView(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0,),
            reverse: false,
            itemCount: stint.nbOfLaps * 2 - 1,
            itemBuilder: (_, int index) {
              String lapString;
              int timeLeft;
              int lapNumber = 0;

              if (index % 2 == 1) return Divider();

              index = (index / 2).floor();

              if (stintIndex == 0) {
                if (race.formationLap == 1 && index == 0) {
                  lapString = "Formation lap";
                  timeLeft = race.raceDuration;
                } else {
                  lapNumber = index + 1 - race.formationLap;
                  timeLeft = race.getRaceTimeLeft(
                      lapNumber, stintIndex, strategy.realLapTime);
                  lapString = 'Lap ' + (lapNumber).toString();
                }
              } else {
                lapNumber =
                    index + 1 + strategy.pitStops[stintIndex - 1].pitStopLap;
                lapString = 'Lap ' + lapNumber.toString();
                timeLeft = race.getRaceTimeLeft(
                    lapNumber, stintIndex, strategy.realLapTime);
              }

              if (timeLeft < 0) timeLeft = 0;

              double fuelLeft;
              if (race.refuelingAllowed) {
                fuelLeft = stint.fuel - fuelPerLap * (index + 1);
              } else {
                fuelLeft = strategy.startingFuel -
                    fuelPerLap * (lapNumber + race.formationLap);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0,),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft, child: Text(lapString)),
                    ),
                    Expanded(
                      child: Center(
                          child: Text(
                              getHMMSSDurationString(timeLeft.ceil()) + ' left')),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text((fuelLeft).toStringAsFixed(1) + ' L')),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
