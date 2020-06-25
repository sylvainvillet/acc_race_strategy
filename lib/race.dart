import './cars.dart';
import './tracks.dart';

class Race {
  Race(
      this.car,
      this.track,
      this.formationLap,
      this.raceDuration,
      this.refuelingAllowed,
      this.mandatoryPitStops,
      this.fuelUsage,
      this.lapTime);

  // input
  Car car;
  Track track;
  int formationLap;
  int raceDuration;
  bool refuelingAllowed;
  int mandatoryPitStops;
  double fuelUsage;
  double lapTime;

  // output
  int nbOfLaps;
  List<Strategy> strategies = List<Strategy>();

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

  String getRaceDurationString() {
    int hours = (raceDuration / 3600).floor();
    int minutes = (raceDuration / 60 - hours * 60).floor();
    String returnValue = hours.toString() + 'h';
    if (minutes < 10) returnValue += '0';
    returnValue += minutes.toString();

    return returnValue;
  }

  String getTrackAndDuration() {
    return track.displayName + ' (' + getRaceDurationString() + ')';
  }

  String getCarTrackAndDuration() {
    return car.displayName + ' @ ' + getTrackAndDuration();
  }

  void computeStrategies() {
    strategies.clear();

    // Calculate the max number of laps with full tank
    final double nbOfLapsWithFullTank = car.tank / fuelUsage;
    print('nbOfLapsWithFullTank: ' + nbOfLapsWithFullTank.toString());

    // Calculate the number of laps
    nbOfLaps = _getNbOfLaps(raceDuration, formationLap, mandatoryPitStops, track.timeLostInPits, lapTime);
    print('nbOfLaps: ' + nbOfLaps.toString());

    // Number of pit stops without fuel saving
    int nbOfPitStops = mandatoryPitStops;
    if (refuelingAllowed && (nbOfLaps > nbOfLapsWithFullTank)) {
      while ((nbOfLaps / (nbOfPitStops + 1)).ceil() > nbOfLapsWithFullTank) {
        nbOfPitStops++;
      }
    }
    print('nbOfPitStops: ' + nbOfPitStops.toString());

    // Adjust number of laps
    nbOfLaps = _getNbOfLaps(raceDuration, formationLap, nbOfPitStops, track.timeLostInPits, lapTime);

    // Allow up to 20% fuel saving
    for (int i = mandatoryPitStops; i <= nbOfPitStops; i++) {
      if (refuelingAllowed) {
        if ((nbOfLaps / (i + 1)).ceil() <=
            (nbOfLapsWithFullTank * 1.2).ceil()) {
          strategies.insert(0, _computeStrategy(nbOfLaps, i, fuelUsage));
          strategies.first.fuelSaving =
              (fuelUsage - car.tank / (nbOfLaps / (i + 1)).ceil()) / fuelUsage;
        }
      } else {
        if (nbOfLaps <= (nbOfLapsWithFullTank * 1.2).ceil()) {
          strategies.insert(0, _computeStrategy(nbOfLaps, i, fuelUsage));
          strategies.first.fuelSaving =
              (fuelUsage - car.tank / nbOfLaps) / fuelUsage;
        }
      }
    }
  }

  Strategy _computeStrategy(int nbOfLaps, int nbOfPitStops, double fuelUsage) {
    Strategy strategy = new Strategy();
    strategy.pitStops = List<PitStop>();
    strategy.stints = List<Stint>();
    strategy.nbOfLaps = nbOfLaps;

    if (nbOfPitStops == 0) {
      strategy.startingFuel = (nbOfLaps * fuelUsage).ceil();
      if (strategy.startingFuel > car.tank) strategy.startingFuel = car.tank;

      strategy.stints.add(Stint(nbOfLaps, strategy.startingFuel.toDouble()));
    } else if (!refuelingAllowed) {
      int fuelNeeded = (nbOfLaps * fuelUsage).ceil();
      strategy.startingFuel = (fuelNeeded > car.tank) ? car.tank : fuelNeeded;
      double realFuelUsage = strategy.startingFuel / nbOfLaps;

      int nbOfLapsPerStint = (nbOfLaps / (nbOfPitStops + 1)).ceil();
      int lap = 0;
      for (int i = 0; i < nbOfPitStops; i++) {
        // Add the first stint
        if (i == 0) {
          strategy.stints
              .add(Stint(nbOfLapsPerStint, realFuelUsage * nbOfLapsPerStint));
        }

        lap += nbOfLapsPerStint;

        // Adjust nb of laps and fuel needed for the next stint
        nbOfLapsPerStint = ((nbOfLaps - lap) / (nbOfPitStops - i)).ceil();

        PitStop pitStop = new PitStop();
        pitStop.fuelToAdd = 0;
        pitStop.pitStopLap = lap;
        pitStop.changeTyres = true; // TODO
        strategy.pitStops.add(pitStop);
        strategy.stints
            .add(Stint(nbOfLapsPerStint, realFuelUsage * nbOfLapsPerStint));
      }
    } else {
      int nbOfLapsPerStint = (nbOfLaps / (nbOfPitStops + 1)).ceil();
      int lap = 0;
      int fuelNeeded = 0;
      for (int i = 0; i < nbOfPitStops; i++) {
        // Add the first stint
        if (i == 0) {
          fuelNeeded = (nbOfLapsPerStint * fuelUsage).ceil();
          if (fuelNeeded > car.tank) fuelNeeded = car.tank;

          strategy.startingFuel = fuelNeeded;
          strategy.stints
              .add(Stint(nbOfLapsPerStint, strategy.startingFuel.toDouble()));
        }

        lap += nbOfLapsPerStint;

        // Adjust nb of laps and fuel needed for the next stint
        nbOfLapsPerStint = ((nbOfLaps - lap) / (nbOfPitStops - i)).ceil();
        fuelNeeded = (nbOfLapsPerStint * fuelUsage).ceil();
        if (fuelNeeded > car.tank) fuelNeeded = car.tank;

        PitStop pitStop = new PitStop();
        pitStop.fuelToAdd = fuelNeeded;
        pitStop.pitStopLap = lap;
        pitStop.changeTyres = true; // TODO
        strategy.pitStops.add(pitStop);
        strategy.stints.add(Stint(nbOfLapsPerStint, fuelNeeded.toDouble()));
      }
    }

    strategy.cutOffLow = _getAverageLapTime(raceDuration, formationLap, nbOfPitStops, track.timeLostInPits, nbOfLaps);
    strategy.cutOffHigh = _getAverageLapTime(raceDuration, formationLap, nbOfPitStops, track.timeLostInPits, nbOfLaps - 1);

    print('strategy.startingFuel: ' + strategy.startingFuel.toString());
    print('strategy.stints: ' + strategy.stints.length.toString());
    return strategy;
  }

  double _getAverageLapTime(int raceDuration, int formationLap, int nbOfPitStops, int timeLostPerPitStop, int nbOfLaps) {
    return (raceDuration - nbOfPitStops * timeLostPerPitStop) / (nbOfLaps - formationLap);
  }

  int _getNbOfLaps(int raceDuration, int formationLap, int nbOfPitStops, int timeLostPerPitStop, double lapTime) {
    return ((raceDuration - nbOfPitStops * timeLostPerPitStop) / lapTime + formationLap).ceil();
  }
}

class Strategy {
  int nbOfLaps = 0;
  int startingFuel = 0;
  double fuelSaving = 0;
  double cutOffLow = 0.0;
  double cutOffHigh = 0.0;
  List<Stint> stints;
  List<PitStop> pitStops;
}

class PitStop {
  int fuelToAdd = 0;
  bool changeTyres = false;
  bool driverSwap = false;
  int pitStopLap;

  Duration getPitStopStillDuration() {
    if (changeTyres || driverSwap) {
      return Duration(seconds: 30);
    } else {
      double durationSeconds = 3 + fuelToAdd * 0.2;
      return Duration(
          seconds: durationSeconds.floor(),
          milliseconds:
              ((durationSeconds - durationSeconds.floor()) * 1000).floor());
    }
  }
}

class Stint {
  int nbOfLaps = 0;
  double fuel = 0;

  Stint(this.nbOfLaps, this.fuel);
}
