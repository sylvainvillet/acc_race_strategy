class Track {
  const Track(this.ksName, this.displayName, this.length, this.lapTime, this.timeLostInPits);

  final String ksName;
  final String displayName;
  final int length;
  final double lapTime;
  final int timeLostInPits;
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
  Track("monza", "Monza", 5793, 106.7, 60),
  Track("Brands_Hatch", "Brands Hatch", 3908, 83.9, 60),
  Track("Silverstone", "Silverstone", 5891, 117.8, 60),
  Track("Paul_Ricard", "Paul Ricard", 5842, 114.2, 60),
  Track("misano", "Misano", 4226, 93.8, 60),
  Track("zandvoort", "Zandvoort", 4252, 95.0, 60),
  Track("Spa", "Spa", 7004, 138.0, 90),
  Track("nurburgring", "Nürburgring", 5137, 114.1, 60),
  Track("hungaroring", "Hungaroring", 4381, 104.5, 60),
  Track("barcelona", "Barcelona", 4665, 104.1, 60),
  Track("zolder", "Zolder", 4011, 87.8, 60),
  Track("mont_panorama", "Mount Panorama", 6213, 120.6, 60),
  Track("Laguna_Seca", "Laguna Seca", 3602, 82.6, 60),
  Track("Suzuka", "Suzuka", 5807, 119.7, 60),
  Track("Kyalami", "Kyalami", 4522, 101.0, 60),
];