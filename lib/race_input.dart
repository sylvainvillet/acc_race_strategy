import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final _formKey = GlobalKey<FormState>();
  Race _race = Race(
      carsList[0], tracksList[0], 1, 3600, true, 0, 3.0, tracksList[0].lapTime);

  final margin = 10.0;

  int _durationHours;
  int _durationMinutes;
  int _lapTimeMinutes = 0;
  int _lapTimeSeconds = 0;
  int _lapTimeMilliseconds = 0;
  int _fuelUsageLiters = 1;
  int _fuelUsageCentiliters = 0;

  List<DropdownMenuItem<Car>> _carsDropDownMenuItems;
  List<DropdownMenuItem<Track>> _tracksDropDownMenuItems;
  List<DropdownMenuItem<int>> _formationLapDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationHoursDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeSecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMillisecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _mandatoryPitStopsDropDownMenuItems;
  List<DropdownMenuItem<int>> _fuelUsageLitersDropDownMenuItems;
  List<DropdownMenuItem<int>> _fuelUsageCentilitersDropDownMenuItems;

  @override
  void initState() {
    _carsDropDownMenuItems = getCarsDropDownMenuItems();
    _tracksDropDownMenuItems = getTracksDropDownMenuItems();
    _formationLapDropDownMenuItems = getFormationLapDropDownMenuItems();
    _durationHoursDropDownMenuItems = getIntDropDownMenuItems(0, 24, 1, 0);
    _durationMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 55, 5, 1);
    _lapTimeMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 2, 1, 0);
    _lapTimeSecondsDropDownMenuItems = getIntDropDownMenuItems(0, 59, 1, 1);
    _lapTimeMillisecondsDropDownMenuItems =
        getIntDropDownMenuItems(0, 900, 100, 2);
    _mandatoryPitStopsDropDownMenuItems = getIntDropDownMenuItems(0, 23, 1, 0);
    _fuelUsageLitersDropDownMenuItems = getIntDropDownMenuItems(0, 4, 1, 0);
    _fuelUsageCentilitersDropDownMenuItems =
        getIntDropDownMenuItems(0, 99, 1, 1);

    _loadSettings();

    super.initState();
  }

  void _loadSettings() async {
    final settings = await SharedPreferences.getInstance();

    final carName = settings.getString('carName') ?? '';
    final trackName = settings.getString('trackName') ?? '';

    setState(() {
      _race.car = getCar(carName);
      _race.track = getTrack(trackName);
      _race.formationLap = settings.getInt('formationLap') ?? 1;
      _race.raceDuration = settings.getInt('raceDuration') ?? 3600;
      _race.refuelingAllowed = settings.getBool('refuelingAllowed') ?? true;
      _race.mandatoryPitStops = settings.getInt('mandatoryPitStops') ?? 0;
      _loadLapTime();
      _loadFuelUsage();

      _durationHours = (_race.raceDuration / 3600).floor();
      _durationMinutes =
          ((_race.raceDuration / 60) - _durationHours * 60).floor();
      _lapTimeMinutes = (_race.lapTime / 60).floor();
      _lapTimeSeconds = (_race.lapTime - _lapTimeMinutes * 60).floor();
      _lapTimeMilliseconds = ((_race.lapTime * 10).round() % 10) * 100;
    });
  }

  void _saveSettings() async {
    final settings = await SharedPreferences.getInstance();
    settings.setString('carName', _race.car.ksName);
    settings.setString('trackName', _race.track.ksName);
    settings.setInt('formationLap', _race.formationLap);
    settings.setInt('raceDuration', _race.raceDuration);
    settings.setBool('refuelingAllowed', _race.refuelingAllowed);
    settings.setInt('mandatoryPitStops', _race.mandatoryPitStops);
    _saveLapTime();
    _saveFuelUsage();
  }

  void _loadLapTime() async {
    final settings = await SharedPreferences.getInstance();
    setState(() {
      _race.lapTime = settings.getDouble(
        getLapTimeSettingsKey(_race.track, _race.car)) ??
          _race.track.lapTime;

      _lapTimeMinutes = (_race.lapTime / 60).floor();
      _lapTimeSeconds = (_race.lapTime - _lapTimeMinutes * 60).floor();
      _lapTimeMilliseconds = ((_race.lapTime * 10).round() % 10) * 100;
    });
  }

  void _saveLapTime() async {
    final settings = await SharedPreferences.getInstance();
    settings.setDouble(
        getLapTimeSettingsKey(_race.track, _race.car),
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
          getFuelUsageSettingsKey(_race.track, _race.car))??
          getFuelUsageDefault(_race.car, _race.track);
      _fuelUsageLiters = _race.fuelUsage.floor();
      _fuelUsageCentiliters = (_race.fuelUsage * 100).floor() % 100;
    });
  }

  void _saveFuelUsage() async {
    final settings = await SharedPreferences.getInstance();
    settings.setDouble(
        getFuelUsageSettingsKey(_race.track, _race.car),
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
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
              lapTimeRow(),
              SizedBox(height: margin),
              fuelUsageRow(),
              SizedBox(height: margin),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
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
                          builder: (context) => RaceDetails(race: _race),
                        ),
                      );
                    }
                    _saveSettings();
                  }
                },
                child: Text('Go!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Car>> getCarsDropDownMenuItems() {
    List<DropdownMenuItem<Car>> items = List();
    for (Car car in carsList) {
      items.add(DropdownMenuItem(value: car, child: Text(car.displayName)));
    }
    return items;
  }

  Widget carRow() {
    return buildRowTextAndWidget(
      "Car:",
      DropdownButton(
        value: _race.car,
        items: _carsDropDownMenuItems,
        onChanged: carChanged,
        isExpanded: true,
      ),
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
      _race.car = newCar;
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
