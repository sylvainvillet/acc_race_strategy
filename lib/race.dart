import 'dart:math';
import './cars.dart';
import './tracks.dart';
import './utils.dart';

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
  int realRaceDuration;
  int maxStintDuration;
  bool maxStintDurationEnabled = false;
  bool refuelingAllowed;
  int mandatoryPitStops;
  double fuelUsage;
  double lapTime;

  // output
  int nbOfLaps;
  List<Strategy> strategies = List<Strategy>();

  String getTrackAndDuration() {
    return track.displayName + ' (' + getHMMDurationString(raceDuration) + ')';
  }

  String getCarTrackAndDuration() {
    return car.displayName + ' @ ' + getTrackAndDuration();
  }

  void computeStrategies() {
    strategies.clear();

    // Calculate the max number of laps with full tank
    final double nbOfLapsWithFullTank = car.tank / fuelUsage;

    int minimumPitStops = mandatoryPitStops;
    if (maxStintDurationEnabled) {
      minimumPitStops =
          max<int>(minimumPitStops, (raceDuration / maxStintDuration).floor());
    }

    // Calculate the number of laps
    nbOfLaps = _getNbOfLaps(raceDuration, formationLap, minimumPitStops,
        track.timeLostInPits, lapTime);

    // Number of pit stops without fuel saving
    int nbOfPitStops = minimumPitStops;
    if (refuelingAllowed && (nbOfLaps > nbOfLapsWithFullTank)) {
      while ((nbOfLaps / (nbOfPitStops + 1)).ceil() > nbOfLapsWithFullTank) {
        nbOfPitStops++;
        nbOfLaps = _getNbOfLaps(raceDuration, formationLap, nbOfPitStops,
            track.timeLostInPits, lapTime);
      }
    }

    realRaceDuration = ((nbOfLaps - formationLap) * lapTime +
            (nbOfPitStops * track.timeLostInPits))
        .ceil();

    // Allow up to 20% fuel saving
    for (int i = minimumPitStops; i <= nbOfPitStops; i++) {
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
    strategy.realLapTime =
        (realRaceDuration - nbOfPitStops * track.timeLostInPits) /
            (nbOfLaps - formationLap);

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
        pitStop.pitStopLap = lap - formationLap;
        pitStop.raceTimeLeft =
            getRaceTimeLeft(pitStop.pitStopLap, i, strategy.realLapTime);
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
        pitStop.pitStopLap = lap - formationLap;
        pitStop.raceTimeLeft =
            getRaceTimeLeft(pitStop.pitStopLap, i, strategy.realLapTime);
        strategy.pitStops.add(pitStop);
        strategy.stints.add(Stint(nbOfLapsPerStint, fuelNeeded.toDouble()));
      }
    }

    strategy.cutOffLow = _getAverageLapTime(raceDuration, formationLap,
        nbOfPitStops, track.timeLostInPits, nbOfLaps);
    strategy.cutOffHigh = _getAverageLapTime(raceDuration, formationLap,
        nbOfPitStops, track.timeLostInPits, nbOfLaps - 1);

    return strategy;
  }

  double _getAverageLapTime(int raceDuration, int formationLap,
      int nbOfPitStops, int timeLostPerPitStop, int nbOfLaps) {
    return (raceDuration - nbOfPitStops * timeLostPerPitStop) /
        (nbOfLaps - formationLap);
  }

  int getRaceTimeLeft(
      int nbOfLapsDone, int nbOfPitStopsDone, double realLapTime) {
    double timeLeft = raceDuration -
        nbOfLapsDone * realLapTime -
        nbOfPitStopsDone * track.timeLostInPits;
    if (timeLeft < 0) timeLeft = 0.0;

    return timeLeft.ceil();
  }

  int _getNbOfLaps(int raceDuration, int formationLap, int nbOfPitStops,
      int timeLostPerPitStop, double lapTime) {
    return ((raceDuration - nbOfPitStops * timeLostPerPitStop) / lapTime +
            formationLap)
        .ceil();
  }
}

class Strategy {
  int nbOfLaps = 0;
  int startingFuel = 0;
  double realLapTime = 0;
  double fuelSaving = 0;
  double cutOffLow = 0.0;
  double cutOffHigh = 0.0;
  List<Stint> stints;
  List<PitStop> pitStops;
}

class PitStop {
  int fuelToAdd = 0;
  int pitStopLap = 0;
  int raceTimeLeft = 0;
}

class Stint {
  int nbOfLaps = 0;
  double fuel = 0;

  Stint(this.nbOfLaps, this.fuel);
}
