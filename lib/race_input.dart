import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_provider/theme_provider.dart';
import './cars.dart';
import './tracks.dart';
import './race.dart';
import './race_overview.dart';
import './fuel_usage_default.dart';
import './utils.dart';

class RaceInput extends StatefulWidget {
  RaceInput({Key key}) : super(key: key);

  @override
  RaceInputState createState() => RaceInputState();
}

class RaceInputState extends State<RaceInput> {
  Race _race = Race(
      carsList[0], tracksList[0], 1, 3600, true, 0, 3.0, tracksList[0].lapTimeGT3);

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
    _stintDurationMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 55, 5, 2);
    _lapTimeMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 2, 1, 0);
    _lapTimeSecondsDropDownMenuItems = getIntDropDownMenuItems(0, 59, 1, 2);
    _lapTimeMillisecondsDropDownMenuItems =
        getIntDropDownMenuItems(0, 900, 100, 3);
    _mandatoryPitStopsDropDownMenuItems = getIntDropDownMenuItems(0, 23, 1, 0);
    _fuelUsageLitersDropDownMenuItems = getIntDropDownMenuItems(0, 4, 1, 0);
    _fuelUsageCentilitersDropDownMenuItems =
        getIntDropDownMenuItems(0, 99, 1, 2);

    _loadSettings();

    super.initState();
  }

  void _loadSettings() async {
    final settings = await SharedPreferences.getInstance();

    _classIndex = settings.getInt('classIndex') ?? 0;

    _cars[0] = getCar('GT3', settings.getString(getCarSettingsKey('GT3')) ?? '');
    _cars[1] = getCar('GT4', settings.getString(getCarSettingsKey('GT4')) ?? '');

    final trackName = settings.getString('trackName') ?? '';

    setState(() {
      _race.car = _cars[_classIndex];
      _race.track = getTrack(trackName);
      _race.formationLap = settings.getInt('formationLap') ?? 1;
      _race.raceDuration = settings.getInt('raceDuration') ?? 3600;
      _race.maxStintDuration = settings.getInt('maxStintDuration') ?? 6900; // 1h55
      _race.refuelingAllowed = settings.getBool('refuelingAllowed') ?? true;
      _race.mandatoryPitStops = settings.getInt('mandatoryPitStops') ?? 0;
      _loadLapTime();
      _loadFuelUsage();

      _durationHours = (_race.raceDuration / 3600).floor();
      _durationMinutes =
          ((_race.raceDuration / 60) - _durationHours * 60).floor();
      _stintDurationHours = (_race.maxStintDuration / 3600).floor();
      _stintDurationMinutes =
          ((_race.maxStintDuration / 60) - _stintDurationHours * 60).floor();
      _lapTimeMinutes = (_race.lapTime / 60).floor();
      _lapTimeSeconds = (_race.lapTime - _lapTimeMinutes * 60).floor();
      _lapTimeMilliseconds = ((_race.lapTime * 10).round() % 10) * 100;
    });
  }

  void _saveSettings() async {
    final settings = await SharedPreferences.getInstance();
    settings.setInt('classIndex', _classIndex);
    settings.setString(getCarSettingsKey('GT3'), _cars[0].ksName);
    settings.setString(getCarSettingsKey('GT4'), _cars[1].ksName);
    settings.setString('trackName', _race.track.ksName);
    settings.setInt('formationLap', _race.formationLap);
    settings.setInt('raceDuration', _race.raceDuration);
    settings.setInt('maxStintDuration', _race.maxStintDuration);
    settings.setBool('refuelingAllowed', _race.refuelingAllowed);
    settings.setInt('mandatoryPitStops', _race.mandatoryPitStops);
    _saveLapTime();
    _saveFuelUsage();
  }

  void _loadLapTime() async {
    final settings = await SharedPreferences.getInstance();
    setState(() {
      _race.lapTime = settings.getDouble(
        getLapTimeSettingsKey(_race.track, _cars[_classIndex])) ??
          _race.track.getLapTime(_cars[_classIndex].className);

      _lapTimeMinutes = (_race.lapTime / 60).floor();
      _lapTimeSeconds = (_race.lapTime - _lapTimeMinutes * 60).floor();
      _lapTimeMilliseconds = ((_race.lapTime * 10).round() % 10) * 100;
    });
  }

  void _saveLapTime() async {
    final settings = await SharedPreferences.getInstance();
    settings.setDouble(
        getLapTimeSettingsKey(_race.track, _cars[_classIndex]),
        _race.lapTime);
  }

  void resetLapTimes() async {
    final settings = await SharedPreferences.getInstance();
    for (Car car in carsList)
      for (Track track in tracksList)
        settings.remove(
            getLapTimeSettingsKey(track, car));

    _loadLapTime();
  }

  void _loadFuelUsage() async {
    final settings = await SharedPreferences.getInstance();
    setState(() {
      _race.fuelUsage = settings.getDouble(
          getFuelUsageSettingsKey(_race.track, _cars[_classIndex]))??
          getFuelUsageDefault(_cars[_classIndex], _race.track);
      _fuelUsageLiters = _race.fuelUsage.floor();
      _fuelUsageCentiliters = (_race.fuelUsage * 100).floor() % 100;
    });
  }

  void _saveFuelUsage() async {
    final settings = await SharedPreferences.getInstance();
    settings.setDouble(
        getFuelUsageSettingsKey(_race.track, _cars[_classIndex]),
        _race.fuelUsage);
  }

  void resetFuelUsages() async {
    final settings = await SharedPreferences.getInstance();
    for (Car car in carsList)
      for (Track track in tracksList)
        settings.remove(
            getFuelUsageSettingsKey(track, car));

    _loadFuelUsage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              classRow(),
              SizedBox(height: margin),
              carRow(),
              SizedBox(height: margin),
              trackRow(),
              SizedBox(height: margin),
              durationRow(),
              SizedBox(height: margin),
              formationLapRow(),
              SizedBox(height: margin),
              refuelingAllowedRow(),
              SizedBox(height: margin),
              mandatoryPitStopRow(),
              SizedBox(height: margin),
              maxStintDurationRow(),
              SizedBox(height: margin),
              lapTimeRow(),
              SizedBox(height: margin),
              fuelUsageRow(),
              SizedBox(height: margin),
              RaisedButton(
                onPressed: () {
                    _race.car = _cars[_classIndex];
                    _race.computeStrategies();
                    FocusScope.of(context).unfocus();

                    if (_race.raceDuration == 0 ||
                        _race.strategies.length == 0 ||
                        (_race.strategies[0].nbOfLaps <=
                            _race.strategies[0].pitStops.length)) {
                      _showErrorDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThemeConsumer(
                            child: RaceDetails(race: _race),
                          ),
                        ),
                      );
                    }
                    _saveSettings();
                },
                child: Text('Go!'),
              ),
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

  Widget classRow() {
    return buildRowTextAndWidget(
      "Class:",
      DropdownButton(
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
    );
  }

  Widget carRow() {
    return buildRowTextAndWidget(
      "Car:",
      Container(
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
            Text(_cars[2].displayName, style: Theme.of(context)
                .textTheme
                .subtitle1),
            Text(_cars[3].displayName, style: Theme.of(context)
                .textTheme
                .subtitle1),
          ],
        ),
      )
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
    return buildRowTextAndWidget(
      "Refueling allowed:",
      Row(
        children: <Widget>[
          Switch(
            value: _race.refuelingAllowed,
            onChanged: (bool value) {
              setState(() {
                _race.refuelingAllowed = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget mandatoryPitStopRow() {
    return buildRowTextAndWidget(
        "Mandatory pit stops:",
        Row(
          children: <Widget>[
            Expanded(
              child: DropdownButton(
                value: _race.mandatoryPitStops,
                items: _mandatoryPitStopsDropDownMenuItems,
                onChanged: mandatoryPitStopChanged,
                isExpanded: true,
              ),
            ),
            Spacer(flex: 3),
          ],
        ));
  }

  Widget maxStintDurationRow() {
    return buildRowTextAndWidget(
      "Max. stint duration:",
      Row(
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
      _race.maxStintDuration = _stintDurationHours * 3600 + _stintDurationMinutes * 60;
    });
  }

  void stintMinutesChanged(int value) {
    setState(() {
      _stintDurationMinutes = value;
      _race.maxStintDuration = _stintDurationHours * 3600 + _stintDurationMinutes * 60;
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

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No strategies found'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please try different settings.'),
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
}
