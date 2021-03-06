class Track {
  const Track(this.ksName, this.displayName, this.length, this.lapTimeGT3,
      this.lapTimeGT4, this.lapTimeCUP, this.lapTimeST, this.timeLostInPits);

  final String ksName;
  final String displayName;
  final int length;
  final double lapTimeGT3;
  final double lapTimeGT4;
  final double lapTimeCUP;
  final double lapTimeST;
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
      return lapTimeST;
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

const List<Track> tracksList = [       // Length, GT3,   GT4,   Cup,   ST,    Pit stop duration
  Track("barcelona",      "Barcelona",      4665, 104.1, 114.2, 107.7, 108.6, 60),
  Track("Brands_Hatch",   "Brands Hatch",   3908, 83.9,  90.7,  85.6,  86.5,  60),
  Track("donington",      "Donington Park", 4020, 88.0,  95.5,  89.8,  91.2,  60),
  Track("hungaroring",    "Hungaroring",    4381, 104.5, 113.3, 106.8, 108.2, 60),
  Track("Imola",          "Imola",          4959, 104.0, 111.8, 105.6, 108.3, 60),
  Track("Kyalami",        "Kyalami",        4522, 101.0, 110.4, 104.3, 105.5, 60),
  Track("Laguna_Seca",    "Laguna Seca",    3602, 82.6,  90.0,  84.9,  85.5,  60),
  Track("misano",         "Misano",         4226, 93.8,  102.3, 96.6,  97.6,  60),
  Track("mont_panorama",  "Mount Panorama", 6213, 120.6, 133.5, 125.3, 127.9, 60),
  Track("monza",          "Monza",          5793, 106.7, 117.4, 109.9, 111.9, 60),
  Track("nurburgring",    "Nürburgring",    5137, 114.1, 125.4, 117.7, 119.3, 60),
  Track("oulton_park",    "Oulton Park",    4307, 94.1,  102.7, 96.8,  97.9,  60),
  Track("Paul_Ricard",    "Paul Ricard",    5842, 114.2, 124.0, 116.6, 119.0, 60),
  Track("Silverstone",    "Silverstone",    5891, 117.8, 130.2, 122.4, 122.8, 60),
  Track("snetterton",     "Snetterton",     4779, 106.3, 116.0, 109.1, 110.5, 60),
  Track("Spa",            "Spa",            7004, 138.0, 151.4, 142.7, 145.2, 90),
  Track("Suzuka",         "Suzuka",         5807, 119.7, 131.2, 123.5, 125.6, 60),
  Track("zandvoort",      "Zandvoort",      4252, 95.0,  104.8, 98.4,  99.6,  60),
  Track("zolder",         "Zolder",         4011, 87.8,  95.1,  91.8,  92.8,  60),
];