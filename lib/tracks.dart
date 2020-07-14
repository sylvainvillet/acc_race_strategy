import 'package:flutter/material.dart';

class Track {
  const Track(this.ksName, this.displayName, this.length, this.lapTimeGT3,
      this.lapTimeGT4, this.timeLostInPits);

  final String ksName;
  final String displayName;
  final int length;
  final double lapTimeGT3;
  final double lapTimeGT4;
  final int timeLostInPits;

  double getLapTime(String className)
  {
    if (className == 'GT3')
      return lapTimeGT3;
    else if (className == 'GT4')
      return lapTimeGT4;
    else if (className == 'CUP')
      return lapTimeGT3 * 1.025;
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
  Track("barcelona",      "Barcelona",      4665, 104.1, 104.1, 60),
  Track("Brands_Hatch",   "Brands Hatch",   3908, 83.9,  90.7,  60), // Peach
  Track("hungaroring",    "Hungaroring",    4381, 104.5, 104.5, 60),
  Track("Kyalami",        "Kyalami",        4522, 101.0, 101.0, 60),
  Track("Laguna_Seca",    "Laguna Seca",    3602, 82.6,  82.6,  60),
  Track("misano",         "Misano",         4226, 93.8,  102.5, 60), // IRL
  Track("mont_panorama",  "Mount Panorama", 6213, 120.6, 120.6, 60),
  Track("monza",          "Monza",          5793, 106.7, 119.0, 60), // IRL
  Track("nurburgring",    "Nürburgring",    5137, 114.1, 123.9, 60), // IRL
  Track("Paul_Ricard",    "Paul Ricard",    5842, 114.2, 132.2, 60), // IRL
  Track("Silverstone",    "Silverstone",    5891, 117.8, 117.8, 60),
  Track("Spa",            "Spa",            7004, 138.0, 138.0, 90),
  Track("Suzuka",         "Suzuka",         5807, 119.7, 119.7, 60),
  Track("zandvoort",      "Zandvoort",      4252, 95.0,  95.0,  60),
  Track("zolder",         "Zolder",         4011, 87.8,  95.1,  60), // Peach
];