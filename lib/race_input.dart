import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './cars.dart';
import './tracks.dart';
import './race.dart';

class RaceInput extends StatefulWidget {
  final Function() notifyParent;

  RaceInput({Key key, this.notifyParent}) : super(key: key);

  @override
  _RaceInputState createState() => _RaceInputState();
}

class _RaceInputState extends State<RaceInput> {
  final _formKey = GlobalKey<FormState>();

  Race _race;
  int _durationHours;
  int _durationMinutes;
  int _lapTimeMinutes = 0;
  int _lapTimeSeconds = 0;
  int _lapTimeMilliseconds = 0;

  List<DropdownMenuItem<Car>> _carsDropDownMenuItems;
  List<DropdownMenuItem<Track>> _tracksDropDownMenuItems;
  List<DropdownMenuItem<String>> _formationLapDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationHoursDropDownMenuItems;
  List<DropdownMenuItem<int>> _durationMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMinutesDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeSecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _lapTimeMillisecondsDropDownMenuItems;
  List<DropdownMenuItem<int>> _mandatoryPitStopsDropDownMenuItems;

  @override
  void initState() {
    _carsDropDownMenuItems = getCarsDropDownMenuItems();
    _tracksDropDownMenuItems = getTracksDropDownMenuItems();
    _formationLapDropDownMenuItems = getFormationLapDropDownMenuItems();
    _durationHoursDropDownMenuItems = getIntDropDownMenuItems(0, 24, 1, 0);
    _durationMinutesDropDownMenuItems = getIntDropDownMenuItems(0, 55, 5, 1);
    _lapTimeMinutesDropDownMenuItems = getIntDropDownMenuItems(1, 2, 1, 0);
    _lapTimeSecondsDropDownMenuItems = getIntDropDownMenuItems(0, 59, 1, 1);
    _lapTimeMillisecondsDropDownMenuItems =
        getIntDropDownMenuItems(0, 900, 100, 2);
    _mandatoryPitStopsDropDownMenuItems = getIntDropDownMenuItems(0, 10, 1, 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _race = ModalRoute.of(context).settings.arguments;
    _durationHours = (_race.raceDuration / 3600).floor();
    _durationMinutes =
        ((_race.raceDuration / 60) - _durationHours * 60).floor();
    if (_lapTimeMinutes == 0) {
      updateLapTime();
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              carRow(),
              trackRow(),
              lapTimeRow(),
              durationRow(),
              formationLapRow(),
              refuelingAllowedRow(),
              mandatoryPitStopRow(),
              fuelUsageRow(),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _race.computeStrategies();
                    FocusScope.of(context).unfocus();
                    widget.notifyParent();
                  }
                },
                child: Text('Ok'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateLapTime() {
    setState(() {
      _lapTimeMinutes = (_race.track.lapTime / 60).floor();
      _lapTimeSeconds = (_race.track.lapTime - _lapTimeMinutes * 60).floor();
      _lapTimeMilliseconds = ((_race.track.lapTime * 10).round() % 10) * 100;

      _race.lapTime =
          _lapTimeMinutes * 60 + _lapTimeSeconds + _lapTimeMilliseconds / 1000;
    });
  }

  List<DropdownMenuItem<Car>> getCarsDropDownMenuItems() {
    List<DropdownMenuItem<Car>> items = List();
    for (Car car in carsList) {
      items.add(DropdownMenuItem(value: car, child: Text(car.displayName)));
    }
    return items;
  }

  Widget carRow() {
    return Row(children: <Widget>[
      Expanded(
        child: Text("Car:"),
      ),
      Expanded(
        flex: 2,
        child: DropdownButton(
          value: _race.car,
          items: _carsDropDownMenuItems,
          onChanged: carChanged,
          isExpanded: true,
        ),
      ),
    ]);
  }

  List<DropdownMenuItem<Track>> getTracksDropDownMenuItems() {
    List<DropdownMenuItem<Track>> items = List();
    for (Track track in tracksList) {
      items.add(DropdownMenuItem(value: track, child: Text(track.displayName)));
    }
    return items;
  }

  Widget trackRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Track:"),
        ),
        Expanded(
          flex: 2,
          child: DropdownButton(
            value: _race.track,
            items: _tracksDropDownMenuItems,
            onChanged: trackChanged,
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  Widget durationRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Race length:"),
        ),
        Expanded(
          flex: 2,
          child: Row(
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
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getFormationLapDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    items.add(DropdownMenuItem(value: 'Full', child: Text('Full')));
    items.add(DropdownMenuItem(value: 'Short', child: Text('Short')));
    return items;
  }

  Widget lapTimeRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Average\nlap time:"),
        ),
        Expanded(
          flex: 2,
          child: Row(
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
        ),
      ],
    );
  }

  Widget formationLapRow() {
    return Row(children: <Widget>[
      Expanded(
        child: Text("Formation lap:"),
      ),
      Expanded(
        flex: 2,
        child: DropdownButton(
          value: _race.formationLap,
          items: _formationLapDropDownMenuItems,
          onChanged: formationLapChanged,
          isExpanded: true,
        ),
      ),
    ]);
  }

  List<DropdownMenuItem<int>> getIntDropDownMenuItems(
      int min, int max, int increment, int padding) {
    List<DropdownMenuItem<int>> items = List();
    String value;
    for (int i = min; i <= max; i += increment) {
      value = '';
      if (padding == 2 && i < 100) value += '0';
      if (padding >= 1 && i < 10) value += '0';
      value += i.toString();
      items.add(DropdownMenuItem(value: i, child: Text(value)));
    }
    return items;
  }

  Widget refuelingAllowedRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Refueling allowed:"),
        ),
        Expanded(
          flex: 2,
          child: Row(
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
        ),
      ],
    );
  }

  Widget mandatoryPitStopRow() {
    return Row(children: <Widget>[
      Expanded(
        child: Text("Mandatory pit stops:"),
      ),
      Expanded(
        flex: 2,
        child: DropdownButton(
          value: _race.mandatoryPitStops,
          items: _mandatoryPitStopsDropDownMenuItems,
          onChanged: mandatoryPitStopChanged,
          isExpanded: true,
        ),
      ),
    ]);
  }

  Widget fuelUsageRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text("Fuel usage:"),
        ),
        Expanded(
          child: TextFormField(
              initialValue: _race.fuelUsage > 0.0
                  ? _race.fuelUsage.toStringAsFixed(2)
                  : '',
              keyboardType: TextInputType.number,
              validator: (String value) {
                var fuelUsage = double.tryParse(value);
                if (fuelUsage != null) {
                  _race.fuelUsage = fuelUsage;
                  return null;
                } else {
                  return 'Invalid value';
                }
              }),
        ),
        Expanded(
          child: Text("L/Lap"),
        ),
      ],
    );
  }

  void carChanged(Car newCar) {
    print("Selected ${newCar.ksName}");
    setState(() {
      _race.car = newCar;
    });
  }

  void trackChanged(Track newTrack) {
    print("Selected ${newTrack.ksName}");
    setState(() {
      _race.track = newTrack;
    });
    updateLapTime();
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

  void formationLapChanged(String formationLap) {
    setState(() {
      _race.formationLap = formationLap;
    });
  }

  void mandatoryPitStopChanged(int value) {
    setState(() {
      _race.mandatoryPitStops = value;
    });
  }
}
