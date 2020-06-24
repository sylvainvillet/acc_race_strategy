class Track {
  const Track(this.ksName, this.displayName, this.length, this.lapTime);

  final String ksName;
  final String displayName;
  final int length;
  final double lapTime;
}

const List<Track> tracksList = [
  Track("monza", "Monza", 5793, 106.7),
  Track("Brands_Hatch", "Brands Hatch", 3908, 83.9),
  Track("Silverstone", "Silverstone", 5891, 117.8),
  Track("Paul_Ricard", "Paul Ricard", 5842, 114.2),
  Track("misano", "Misano", 4226, 93.8),
  Track("zandvoort", "Zandvoort", 4252, 95.0),
  Track("Spa", "Spa", 7004, 138.0),
  Track("nurburgring", "Nürburgring", 5137, 94.1),
  Track("hungaroring", "Hungaroring", 4381, 104.5),
  Track("barcelona", "Barcelona", 4665, 104.1),
  Track("zolder", "Zolder", 4011, 87.8),
  Track("mont_panorama", "Mount Panorama", 6213, 120.6),
  Track("Laguna_Seca", "Laguna Seca", 3602, 82.6),
  Track("Suzuka", "Suzuka", 5807, 139.7),
  Track("Kyalami", "Kyalami", 4522, 101.0),
];