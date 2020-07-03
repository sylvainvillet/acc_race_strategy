import 'dart:html' as html;

class Platform {
  var _iOS = ['iPad Simulator', 'iPhone Simulator', 'iPod Simulator', 'iPad', 'iPhone', 'iPod'];

  bool isIOS() {
    var matches = false;
    _iOS.forEach((name) {
      if (html.window.navigator.platform.contains(name) || html.window.navigator.userAgent.contains(name)) {
        matches = true;
      }
    });
    return matches;
  }

  bool isAndroid() =>
      html.window.navigator.platform == "Android" || html.window.navigator.userAgent.contains("Android");

  bool isMobile() => isAndroid() || isIOS();

  String name() {
    var name = "";
    if (isAndroid()) {
      name = "Android";
    } else if (isIOS()) {
      name = "iOS";
    }
    return name;
  }

  void openStore() {
    if (isAndroid()) {
      html.window.location.href = "your Play Store URL";
    } else {
      html.window.location.href = "Your App Store URL";
    }
  }
}