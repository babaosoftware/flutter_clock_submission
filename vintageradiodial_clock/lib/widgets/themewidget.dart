import 'dart:math';

import 'package:flutter/material.dart';

/// Colors and fonts for the two basic themes, light and dark
/// Also calculates teh magic pixelRatio used to scale fonts and sizes,
/// for different screen sizes and densities.

class ThemeValues {
  final String defaultFont;
  final String bigDigitFont;
  final String tempFont;
  final Color clockBackground;
  final Color currentHourColor;
  final Color currentHourGlowColor;
  final Color currentMinuteColor;
  final Color currentMinuteGlowColor;
  final Color hourColor;
  final Color hourGlowColor;
  final Color minuteColor;
  final Color minuteGlowColor;
  final Color tempBarShadow;
  final Color textEnabledColor;
  final Color textDisabledColor;
  final Color textGlowColor;
  final Color markerExtensionDarkColor;
  final Color markerExtensionLightColor;
  final Color markerBaseDarkColor;
  final Color markerBaseLightColor;
  final Color scratchColor;
  double pixelRatio;

  ThemeValues({
    this.defaultFont,
    this.bigDigitFont,
    this.tempFont,
    this.clockBackground,
    this.currentHourColor,
    this.currentHourGlowColor,
    this.hourGlowColor,
    this.currentMinuteColor,
    this.currentMinuteGlowColor,
    this.hourColor,
    this.minuteColor,
    this.minuteGlowColor,
    this.tempBarShadow,
    this.textEnabledColor,
    this.textDisabledColor,
    this.textGlowColor,
    this.markerExtensionDarkColor,
    this.markerExtensionLightColor,
    this.markerBaseDarkColor,
    this.markerBaseLightColor,
    this.scratchColor,
  });
}

class ThemeWidget extends InheritedWidget {
  final _lightTheme = ThemeValues(
    defaultFont: 'Bebas-Neue',
    bigDigitFont: 'Abril-Fatface',
    tempFont: 'krona-One',
    clockBackground: Colors.lightGreen[100].withOpacity(0.3),
    currentHourColor: Colors.tealAccent[700],
    currentHourGlowColor: Colors.teal[900].withOpacity(0.5),
    currentMinuteColor: Colors.tealAccent[700],
    currentMinuteGlowColor: Colors.teal[900].withOpacity(0.5),
    hourColor: Colors.tealAccent[700],
    hourGlowColor: Colors.teal[900].withOpacity(0.3),
    minuteColor: Colors.tealAccent[700],
    minuteGlowColor: Colors.teal[900].withOpacity(0.3),
    tempBarShadow: Colors.black.withOpacity(0.5),
    textEnabledColor: Colors.tealAccent[700],
    textDisabledColor: Colors.grey[300],
    textGlowColor: Colors.teal[900].withOpacity(0.3),
    markerExtensionDarkColor: Color(0xffc79100).withOpacity(0.8),
    markerExtensionLightColor: Color(0xffc79100).withOpacity(0.2),
    markerBaseDarkColor: Color(0xffc79100).withOpacity(0.8),
    markerBaseLightColor: Color(0xffc79100).withOpacity(0.4),
    scratchColor: Colors.brown[200],
  );

  final _darkTheme = ThemeValues(
    defaultFont: 'Bebas-Neue',
    bigDigitFont: 'Abril-Fatface',
    tempFont: 'krona-One',
    clockBackground: Colors.black12,
    currentHourColor: Colors.deepOrangeAccent[700],
    currentHourGlowColor: Colors.deepOrange[200].withOpacity(0.5),
    currentMinuteColor: Colors.deepOrangeAccent[700],
    currentMinuteGlowColor: Colors.deepOrange[200].withOpacity(0.5),
    hourColor: Colors.deepOrangeAccent[700],
    hourGlowColor: Colors.deepOrange[200].withOpacity(0.3),
    minuteColor: Colors.deepOrangeAccent[700],
    minuteGlowColor: Colors.deepOrange[200].withOpacity(0.3),
    tempBarShadow: Colors.white.withOpacity(0.5),
    textEnabledColor: Colors.deepOrangeAccent[700],
    textDisabledColor: Colors.grey[700],
    textGlowColor: Colors.deepOrange[200].withOpacity(0.3),
    markerExtensionDarkColor: Color(0xff2196f3).withOpacity(0.8),
    markerExtensionLightColor: Color(0xff2196f3).withOpacity(0.2),
    markerBaseDarkColor: Color(0xff2196f3).withOpacity(0.8),
    markerBaseLightColor: Color(0xff2196f3).withOpacity(0.4),
    scratchColor: Colors.blue[900],
  );

  ThemeWidget({
    Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(ThemeWidget oldWidget) => false;

  static ThemeWidget _themeWidget = ThemeWidget();

  static ThemeValues of(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double minSize = min(mediaQueryData.size.width, mediaQueryData.size.height);
    double maxSize = max(mediaQueryData.size.width, mediaQueryData.size.height);
    double ratio = (mediaQueryData.orientation == Orientation.landscape
            ? maxSize
            : minSize) /
        1400.0;
    _themeWidget._lightTheme.pixelRatio = ratio;
    _themeWidget._darkTheme.pixelRatio = ratio;
    return Theme.of(context).brightness == Brightness.light
        ? _themeWidget._lightTheme
        : _themeWidget._darkTheme;
  }
}
