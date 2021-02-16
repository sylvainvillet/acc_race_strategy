import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './cars.dart';
import './tracks.dart';
import './race.dart';
import './race_overview.dart';
import './fuel_usage_default.dart';
import './utils.dart';
import './platform.dart';

class RaceInput extends StatefulWidget {
  RaceInput({Key key}) : super(key: key);

  @override
  RaceInputState createState() => RaceInputState();
}

class RaceInputState extends State<RaceInput> {
  Race _race = Race(carsList[0], tracksList[0], 1, 3600, true, 0, 120, 3.0,
      tracksList[0].lapTimeGT3);

  final margin = 4.0;

  int _classIndex = 0;

  List<Car> _cars = List();

  int _durationHours;
  int _durationMinutes;

  int _stintDurationHours;
  int _stintDurationMinutes;

  int _lapTimeMinutes = 0;
  int _lapTimeSeconds = 0;
  int _lapTimeMilliseconds = 0;

  bool _use2020bop;
  int _fuelUsageLiters = 1;
  int _fuelUsageCentiliters = 0;

  List<DropdownMenuItem<int>> _classDropDownMenuItems;
  List<DropdownMenuItem<Car>> _gt3CarsDropDownMenuItems;
  List<DropdownMenuItem<Car>> _gt4CarsDropDownMenuItems;
  List<DropdownMenuItem<Track>> _tracksDropDownMenuItems;
  List<DropdownMenuItem<int>> _formationLapDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationHoursDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _stintDurationHoursDropDownMenuItems;
  List<DropdownMenuItem<int>> _stintDurationMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeSecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMillisecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _mandatoryPitStopsDropDownMenuItems;
  List<DropdownMenuItem<int>> _fuelUsageLitersDropDownMenuItems;
  List<DropdownMenuItem<int>> _fuelUsageCentilitersDropDownMenuItems;

  @override
  void initState() {
    _cars.add(getFirstCar('GT3'));
    _cars.add(getFirstCar('GT4'));
    _cars.add(getFirstCar('CUP'));
    _cars.add(getFirstCar('ST'));

    _classDropDownMenuItems = getClassDropDownMenuItems();
    _gt3CarsDropDownMenuItems = getCarsDropDownMenuItems('GT3');
    _gt4CarsDropDownMenuItems = getCarsDropDownMenuItems('GT4');
    _tracksDropDownMenuItems = getTracksDropDownMenuItems();
    _formationLapDropDownMenuItems = getFormationLapDropDownMenuItems();
    _durationHoursDropDownMenuItems = getIntDropDownMenuItems(0, 24, 1, 0);
    _durationMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 55, 5, 2);
    _stintDurationHoursDropDownMenuItems = getIntDropDownMenuItems(0, 1, 1, 0);
    _stintDurationMinutesDropDownMenuItems =
        getIntDropDownMenuItems(0, 55, 5, 2);
    _lapTimeMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 2, 1, 0);
    _lapTimeSecondsDropDownMenuItems = getIntDropDownMenuItems(0, 59, 1, 2);
    _lapTimeMillisecondsDropDownMenuItems =
        getIntDropDownMenuItems(0, 900, 100, 3);
    _mandatoryPitStopsDropDownMenuItems = getIntDropDownMenuItems(0, 23, 1, 0);
    _fuelUsageLitersDropDownMenuItems = getIntDropDownMenuItems(0, 4, 1, 0);
    _fuelUsageCentilitersDropDownMenuItems =
        getIntDropDownMenuItems(0, 99, 1, 2);

    _race.car = carsList[0];
    _race.track = _tracksDropDownMenuItems[0].value;
    _race.formationLap = 1;
    _race.raceDuration = 3600;
    _race.maxStintDuration = 6900; // 1h55
    _race.refuelingAllowed = true;
    _race.mandatoryPitStops = 0;
    _use2020bop = true;

    _durationHours = (_race.raceDuration / 3600).floor();
    _durationMinutes =
        ((_race.raceDuration / 60) - _durationHours * 60).floor();
    _stintDurationHours = (_race.maxStintDuration / 3600).floor();
    _stintDurationMinutes =
        ((_race.maxStintDuration / 60) - _stintDurationHours * 60).floor();

    _loadLapTime();
    _loadFuelUsage();

    super.initState();
  }

  void _loadLapTime() {
    _race.lapTime = _race.track.getLapTime(_cars[_classIndex].className);

    _lapTimeMinutes = (_race.lapTime / 60).floor();
    _lapTimeSeconds = (_race.lapTime - _lapTimeMinutes * 60).floor();
    _lapTimeMilliseconds = ((_race.lapTime * 10).round() % 10) * 100;
  }

  void _loadFuelUsage() {
    _race.fuelUsage = getFuelUsageDefault(_cars[_classIndex], _race.track);
    _fuelUsageLiters = _race.fuelUsage.floor();
    _fuelUsageCentiliters = (_race.fuelUsage * 100).floor() % 100;
  }

  @override
  Widget build(BuildContext context) {
    Platform platform = Platform();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildCard(
                'Event',
                Column(
                  children: [
                    trackRow(),
                    durationRow(),
                    formationLapRow(),
                  ],
                ),
              ),
              _buildCard(
                'Event rules',
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 4, child: mandatoryPitStopRow()),
                        Spacer(),
                        Expanded(flex: 3, child: refuelingAllowedRow()),
                      ],
                    ),
                    maxStintDurationRow(),
                  ],
                ),
              ),
              _buildCard(
                'Car',
                carRow(),
              ),
              _buildCard(
                'Variables',
                Column(
                  children: [
                    lapTimeRow(),
                    fuelUsageRow(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _openPlayStore();
                    }, // handle your image tap here
                    child: Image.asset(
                      'assets/google_play_badge.png',
                      width: 150,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _race.car = _cars[_classIndex];
                      _race.tankCapacity = _use2020bop &&
                              get2020bopFuelCapacity(_race.car, _race.track) !=
                                  null
                          ? get2020bopFuelCapacity(_race.car, _race.track)
                          : _race.car.tank;
                      _race.computeStrategies();
                      FocusScope.of(context).unfocus();

                      if (_race.raceDuration == 0 ||
                          _race.strategies.length == 0 ||
                          (_race.strategies[0].nbOfLaps <=
                              _race.strategies[0].pitStops.length)) {
                        if (_race.refuelingAllowed) {
                          _showErrorDialog(
                              'Please check race length and mandatory pit stops.');
                        } else {
                          _showErrorDialog('Please try to enable refueling.');
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Center(
                              child: AspectRatio(
                                aspectRatio: platform.isMobile()
                                    ? MediaQuery.of(context).size.width /
                                        MediaQuery.of(context).size.height
                                    : 0.6,
                                child: RaceDetails(race: _race),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Go!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              child,
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> getClassDropDownMenuItems() {
    return [
      DropdownMenuItem(value: 0, child: Text('GT3')),
      DropdownMenuItem(value: 1, child: Text('GT4')),
      DropdownMenuItem(value: 2, child: Text('CUP')),
      DropdownMenuItem(value: 3, child: Text('ST')),
    ];
  }

  List<DropdownMenuItem<Car>> getCarsDropDownMenuItems(String className) {
    List<DropdownMenuItem<Car>> items = List();
    for (Car car in carsList) {
      if (car.className == className)
        items.add(DropdownMenuItem(value: car, child: Text(car.displayName)));
    }
    return items;
  }

  Widget carRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: DropdownButton(
                value: _classIndex,
                items: _classDropDownMenuItems,
                onChanged: (int classIndex) {
                  setState(() {
                    _classIndex = classIndex;
                    _loadLapTime();
                    _loadFuelUsage();
                  });
                },
                isExpanded: true,
              ),
            ),
            Spacer(),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              flex: 8,
              child: Container(
                  child: IndexedStack(
                index: _classIndex,
                alignment: Alignment.centerLeft,
                children: [
                  DropdownButton(
                    value: _cars[0],
                    items: _gt3CarsDropDownMenuItems,
                    onChanged: carChanged,
                    isExpanded: true,
                  ),
                  DropdownButton(
                    value: _cars[1],
                    items: _gt4CarsDropDownMenuItems,
                    onChanged: carChanged,
                    isExpanded: true,
                  ),
                  Text(_cars[2].displayName,
                      style: Theme.of(context).textTheme.subtitle1),
                  Text(_cars[3].displayName,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              )),
            ),
          ],
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              get2020bopFuelCapacity(_cars[_classIndex], _race.track) == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: Container(),
          secondChild: buildRowTextAndWidget(
            "Use 2020 BOP:",
            Row(
              children: [
                Checkbox(
                  value: _use2020bop,
                  onChanged: (value) {
                    setState(() {
                      _use2020bop = value;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.help,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Use 2020 BOP'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'BOP-regulated fuel tank limitation in 2020-season for Paul Ricard and Spa.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<Track>> getTracksDropDownMenuItems() {
    List<DropdownMenuItem<Track>> items = List();
    for (Track track in tracksList) {
      items.add(DropdownMenuItem(value: track, child: Text(track.displayName)));
    }
    return items;
  }

  Widget trackRow() {
    return buildRowTextAndWidget(
      "Track:",
      DropdownButton(
        value: _race.track,
        items: _tracksDropDownMenuItems,
        onChanged: trackChanged,
        isExpanded: true,
      ),
    );
  }

  Widget durationRow() {
    return buildRowTextAndWidget(
      "Race length:",
      Row(
        children: <Widget>[
          Expanded(
            child: DropdownButton(
              value: _durationHours,
              items: _durationHoursDropDownMenuItems,
              onChanged: hoursChanged,
              isExpanded: true,
            ),
          ),
          Expanded(child: Text('h', textAlign: TextAlign.center)),
          Expanded(
            child: DropdownButton(
              value: _durationMinutes,
              items: _durationMinutesDropDownMenuItems,
              onChanged: minutesChanged,
              isExpanded: true,
            ),
          ),
          Expanded(child: Text('min', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> getFormationLapDropDownMenuItems() {
    List<DropdownMenuItem<int>> items = List();
    items.add(DropdownMenuItem(value: 1, child: Text('Full')));
    items.add(DropdownMenuItem(value: 0, child: Text('Short')));
    return items;
  }

  Widget lapTimeRow() {
    return buildRowTextAndWidget(
      "Average\nlap time:",
      Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: DropdownButton(
              value: _lapTimeMinutes,
              items: _lapTimeMinutesDropDownMenuItems,
              onChanged: (int value) {
                setState(() {
                  _lapTimeMinutes = value;
                  _race.lapTime = _lapTimeMinutes * 60 +
                      _lapTimeSeconds +
                      _lapTimeMilliseconds / 1000;
                });
              },
              isExpanded: true,
            ),
          ),
          Expanded(child: Text(':', textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: DropdownButton(
              value: _lapTimeSeconds,
              items: _lapTimeSecondsDropDownMenuItems,
              onChanged: (int value) {
                setState(() {
                  _lapTimeSeconds = value;
                  _race.lapTime = _lapTimeMinutes * 60 +
                      _lapTimeSeconds +
                      _lapTimeMilliseconds / 1000;
                });
              },
              isExpanded: true,
            ),
          ),
          Expanded(child: Text('.', textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: DropdownButton(
              value: _lapTimeMilliseconds,
              items: _lapTimeMillisecondsDropDownMenuItems,
              onChanged: (int value) {
                setState(() {
                  _lapTimeMilliseconds = value;
                  _race.lapTime = _lapTimeMinutes * 60 +
                      _lapTimeSeconds +
                      _lapTimeMilliseconds / 1000;
                });
              },
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget formationLapRow() {
    return buildRowTextAndWidget(
      "Formation lap:",
      DropdownButton(
        value: _race.formationLap,
        items: _formationLapDropDownMenuItems,
        onChanged: formationLapChanged,
        isExpanded: true,
      ),
    );
  }

  Widget refuelingAllowedRow() {
    return Row(children: [
      Text("Refueling:"),
      Checkbox(
        value: _race.refuelingAllowed,
        onChanged: (bool value) {
          setState(() {
            _race.refuelingAllowed = value;
          });
        },
      ),
    ]);
  }

  Widget mandatoryPitStopRow() {
    return Row(
      children: [
        Expanded(flex: 2, child: Text("Mandatory pit stops:")),
        SizedBox(
          width: 4.0,
        ),
        Expanded(
          child: DropdownButton(
            value: _race.mandatoryPitStops,
            items: _mandatoryPitStopsDropDownMenuItems,
            onChanged: mandatoryPitStopChanged,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget maxStintDurationRow() {
    return Column(
      children: [
        buildRowTextAndWidget(
          "Max. stint duration:",
          Row(
            children: [
              Checkbox(
                value: _race.maxStintDurationEnabled,
                onChanged: (value) {
                  setState(() {
                    _race.maxStintDurationEnabled = value;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.help,
                  color: Colors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Maximum stint duration'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'Enable \"Max. stint duration\" if the event defines the maximum time a driver can stay out without getting a penalty.\n'
                                  'This can be used to balance fuel efficient cars in endurance races.'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 2,
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton(
                        value: _stintDurationHours,
                        items: _stintDurationHoursDropDownMenuItems,
                        onChanged: stintHoursChanged,
                        isExpanded: true,
                      ),
                    ),
                    Expanded(child: Text('h', textAlign: TextAlign.center)),
                    Expanded(
                      child: DropdownButton(
                        value: _stintDurationMinutes,
                        items: _stintDurationMinutesDropDownMenuItems,
                        onChanged: stintMinutesChanged,
                        isExpanded: true,
                      ),
                    ),
                    Expanded(child: Text('min', textAlign: TextAlign.center)),
                  ],
                ),
                secondChild: Container(),
                crossFadeState: _race.maxStintDurationEnabled
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget fuelUsageRow() {
    return buildRowTextAndWidget(
      "Fuel usage:",
      Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: DropdownButton(
              value: _fuelUsageLiters,
              items: _fuelUsageLitersDropDownMenuItems,
              onChanged: (int value) {
                setState(() {
                  _fuelUsageLiters = value;
                  _race.fuelUsage =
                      _fuelUsageLiters + _fuelUsageCentiliters / 100;
                });
              },
              isExpanded: true,
            ),
          ),
          Expanded(child: Text('.', textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: DropdownButton(
              value: _fuelUsageCentiliters,
              items: _fuelUsageCentilitersDropDownMenuItems,
              onChanged: (int value) {
                setState(() {
                  _fuelUsageCentiliters = value;
                  _race.fuelUsage =
                      _fuelUsageLiters + _fuelUsageCentiliters / 100;
                });
              },
              isExpanded: true,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(' L/lap'),
          ),
        ],
      ),
    );
  }

  void carChanged(Car newCar) async {
    setState(() {
      _cars[_classIndex] = newCar;
    });
    _loadLapTime();
    _loadFuelUsage();
  }

  void trackChanged(Track newTrack) {
    print("Selected ${newTrack.ksName}");
    setState(() {
      _race.track = newTrack;
    });
    _loadLapTime();
    _loadFuelUsage();
  }

  void hoursChanged(int value) {
    setState(() {
      _durationHours = value;
      _race.raceDuration = _durationHours * 3600 + _durationMinutes * 60;
    });
  }

  void minutesChanged(int value) {
    setState(() {
      _durationMinutes = value;
      _race.raceDuration = _durationHours * 3600 + _durationMinutes * 60;
    });
  }

  void stintHoursChanged(int value) {
    setState(() {
      _stintDurationHours = value;
      _race.maxStintDuration =
          _stintDurationHours * 3600 + _stintDurationMinutes * 60;
    });
  }

  void stintMinutesChanged(int value) {
    setState(() {
      _stintDurationMinutes = value;
      _race.maxStintDuration =
          _stintDurationHours * 3600 + _stintDurationMinutes * 60;
    });
  }

  void formationLapChanged(int formationLap) {
    setState(() {
      _race.formationLap = formationLap;
    });
  }

  void mandatoryPitStopChanged(int value) {
    setState(() {
      _race.mandatoryPitStops = value;
    });
  }

  Future<void> _showErrorDialog(String troubleshooting) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No strategies found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(troubleshooting),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _openPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.svillet.accstrategist';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
