import 'package:flutter/material.dart';

class Track {
  const Track(this.ksName, this.displayName, this.length, this.lapTimeGT3,
      this.lapTimeGT4, this.lapTimeCUP, this.timeLostInPits);

  final String ksName;
  final String displayName;
  final int length;
  final double lapTimeGT3;
  final double lapTimeGT4;
  final double lapTimeCUP;
  final int timeLostInPits;

  double getLapTime(String className)
  {
    if (className == 'GT3')
      return lapTimeGT3;
    else if (className == 'GT4')
      return lapTimeGT4;
    else if (className == 'CUP')
      return lapTimeCUP;
    else if (className == 'ST')
      return lapTimeGT3 * 1.03;
    else
      return 0.0;
  }
}

Track getTrack(String ksName)
{
  Track returnValue = tracksList[0];
  for (Track track in tracksList)
    if (track.ksName == ksName)
      returnValue = track;

  return returnValue;
}

const List<Track> tracksList = [
  Track("monza",          "Monza",          5793, 106.7, 117.4, 109.9, 60),
  Track("Brands_Hatch",   "Brands Hatch",   3908, 83.9,  90.7,  85.6,  60),
  Track("Silverstone",    "Silverstone",    5891, 117.8, 130.2, 122.4, 60),
  Track("Paul_Ricard",    "Paul Ricard",    5842, 114.2, 124.0, 116.6, 60),
  Track("misano",         "Misano",         4226, 93.8,  102.3, 96.6,  60),
  Track("zandvoort",      "Zandvoort",      4252, 95.0,  104.8, 98.4,  60),
  Track("Spa",            "Spa",            7004, 138.0, 151.4, 142.7, 90),
  Track("nurburgring",    "Nürburgring",    5137, 114.1, 125.4, 117.7, 60),
  Track("hungaroring",    "Hungaroring",    4381, 104.5, 113.3, 106.8, 60),
  Track("barcelona",      "Barcelona",      4665, 104.1, 114.2, 107.7, 60),
  Track("zolder",         "Zolder",         4011, 87.8,  95.1,  91.8,  60),
  Track("mont_panorama",  "Mount Panorama", 6213, 120.6, 133.5, 125.3, 60),
  Track("Laguna_Seca",    "Laguna Seca",    3602, 82.6,  90.0,  84.9,  60),
  Track("Suzuka",         "Suzuka",         5807, 119.7, 131.2, 123.5, 60),
  Track("Kyalami",        "Kyalami",        4522, 101.0, 110.4, 104.3, 60),
];