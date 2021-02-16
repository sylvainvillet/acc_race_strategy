import 'package:accracestrategy/faq.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './race_input.dart';
import './utils.dart';

void main() {
  runApp(AccStrategistApp());
}

class AccStrategistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: <AppTheme>[
        AppTheme(
          id: "light_theme",
          description: "Light Theme",
          data: ThemeData(
            primarySwatch: Colors.red,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ),
        AppTheme(
          id: "dark_theme",
          description: "Dark Theme",
          data: ThemeData(
            primarySwatch: Colors.red,
            toggleableActiveColor: Colors.red,
            tabBarTheme: TabBarTheme(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: Colors.red))),
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'ACC Strategist',
        debugShowCheckedModeBanner: false,
        home: ThemeConsumer(
          child: HomePage(title: 'ACC Strategist'),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

enum PopupMenuItems { theme, resetLapTimes, resetFuelUsages, faq, about }

class _HomePageState extends State<HomePage> {
  final GlobalKey<RaceInputState> _key = GlobalKey();

  bool _changelogPopupShown = true;
  String version;

  @override
  void initState() {
    _loadSettings();

    super.initState();
  }

  void _loadSettings() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;

    final settings = await SharedPreferences.getInstance();

    _changelogPopupShown =
        settings.getBool('changelogPopupShown_v' + version) ?? false;

    if (!_changelogPopupShown) {
      _showChangelogPopup(context);
      _changelogPopupShown = true;
      _saveSettings();
    }
  }

  void _saveSettings() async {
    final settings = await SharedPreferences.getInstance();

    settings.setBool('changelogPopupShown_v' + version, _changelogPopupShown);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<PopupMenuItems>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: PopupMenuItems.theme,
                child: Text(ThemeProvider.themeOf(context).id == "dark_theme"
                    ? "Light mode"
                    : "Dark mode"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.resetLapTimes,
                child: Text("Reset lap times"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.resetFuelUsages,
                child: Text("Reset fuel usages"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.faq,
                child: Text("FAQ"),
              ),
              PopupMenuItem(
                value: PopupMenuItems.about,
                child: Text("About"),
              ),
            ],
            onSelected: (PopupMenuItems result) {
              switch (result) {
                case PopupMenuItems.theme:
                  ThemeProvider.controllerOf(context).nextTheme();
                  break;
                case PopupMenuItems.resetLapTimes:
                  _showResetLapTimesPopup(context);
                  break;
                case PopupMenuItems.resetFuelUsages:
                  _showResetFuelUsagesPopup(context);
                  break;
                case PopupMenuItems.faq:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThemeConsumer(
                        child: Faq(),
                      ),
                    ),
                  );
                  break;
                case PopupMenuItems.about:
                  _showAboutPopup(context);
                  break;
              }
            },
          )
        ],
      ),
      body: RaceInput(key: _key),
    );
  }

  void _showResetLapTimesPopup(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _key.currentState.resetLapTimes();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset lap times',
            Text('Lap times have been reset to default values.'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset lap times"),
      content: Text(
          "Are you sure you want to reset the lap times to default values?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showResetFuelUsagesPopup(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _key.currentState.resetFuelUsages();
        Navigator.of(context).pop(); // dismiss dialog
        showSimplePopup(context, 'Reset fuel usages',
            Text('Fuel usages have been reset to default values.'));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reset fuel usages"),
      content: Text(
          "Are you sure you want to reset the fuel usages to default values?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showAboutPopup(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    double margin = 10.0;
    showSimplePopup(
        context,
        'About',
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/lollipop_man.png'),
              width: 200,
              height: 200,
            ),
            SizedBox(height: margin),
            Text(packageInfo.appName + ' v' + version,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: margin),
            Text('Developed by Sylvain Villet'),
            SizedBox(height: margin),
            Text(
              'Special thanks to ElderCold, Judemuppet and Petrol',
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  void _showChangelogPopup(BuildContext context) async {
    double margin = 10.0;
    showSimplePopup(
      context,
      'Changelog v' + version,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('- Added 2020 BOP fuel tank capacities to older GT3 cars'),
        ],
      ),
    );
  }
}
