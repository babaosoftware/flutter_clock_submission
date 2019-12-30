import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vintageradiodial_clock/widgets/themewidget.dart';

/// Middle dial that shows the temperature range and the weather condition icon
/// The background color is a gradient from the colors assigned to the lower and higher temperatures

class TempeBarWidget extends StatelessWidget {
  final ClockModel model;

  TempeBarWidget(this.model);

  @override
  Widget build(BuildContext context) {
    ThemeValues themeValues = ThemeWidget.of(context);
    final fontSize = 36.0 * themeValues.pixelRatio;
    var lowTempWidget = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(model.lowString,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: themeValues.tempFont,
            color: _getTemperatureColor(model.low, true),
          )),
    );

    var highTempWidget = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(model.highString,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: themeValues.tempFont,
            color: _getTemperatureColor(model.high, true),
          )),
    );

    var tempWidget = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              "assets/images/${model.weatherString}.png",
              height: fontSize,
              color: _getTemperatureColor(model.temperature, true),
            ),
          ),
          Text(model.temperatureString,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: themeValues.tempFont,
                color: _getTemperatureColor(model.temperature, true),
              )),
        ],
      ),
    );

    var ratio1 =
        1.0 / (model.high - model.low) * (model.temperature - model.low);
    var ratio2 =
        -1.0 + 2.0 / (model.high - model.low) * (model.temperature - model.low);

    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 2.0,
                color: themeValues.tempBarShadow,
                offset: Offset(-2.0, 0.0)),
            BoxShadow(
                blurRadius: 2.0,
                color: themeValues.tempBarShadow,
                offset: Offset(2.0, 0.0)),
            BoxShadow(
                blurRadius: 2.0,
                color: themeValues.tempBarShadow,
                offset: Offset(0.0, 2.0)),
            BoxShadow(
                blurRadius: 2.0,
                color: themeValues.tempBarShadow,
                offset: Offset(0.0, -2.0)),
          ],
          borderRadius:
              BorderRadius.all(Radius.circular(16.0 * themeValues.pixelRatio)),
          gradient: LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, ratio1, 1.0],
            colors: [
              _getTemperatureColor(model.low, false),
              _getTemperatureColor(model.temperature, false),
              _getTemperatureColor(model.high, false),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 8.0), child: lowTempWidget),
              Expanded(
                flex: 1,
                child:
                    Align(alignment: Alignment(ratio2, 0.0), child: tempWidget),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 8.0), child: highTempWidget),
            ],
          ),
        ));
  }

  // Map of temperature values to colors
  final Map<int, Color> temperatureColorMap = {
    110: Color(0xfffdf0f0),
    105: Color(0xfffac8dc),
    100: Color(0xfff0273c),
    95: Color(0xff8c0101),
    90: Color(0xffb42703),
    85: Color(0xffdc5004),
    80: Color(0xfff08c12),
    75: Color(0xfff7b429),
    70: Color(0xfff5dd5a),
    65: Color(0xfff9f673),
    60: Color(0xfffafba0),
    55: Color(0xffb4ffb5),
    50: Color(0xff8cff8c),
    45: Color(0xff64e764),
    40: Color(0xff3ec805),
    35: Color(0xff32a131),
    30: Color(0xff217802),
    25: Color(0xff96e7fe),
    20: Color(0xff41b5fd),
    15: Color(0xff338cf0),
    10: Color(0xff233cfd),
    5: Color(0xff1400c8),
    0: Color(0xff0c0096),
    -5: Color(0xff8c01af),
    -10: Color(0xffb164c0),
    -15: Color(0xffe104e2),
    -20: Color(0xfff664fd),
    -25: Color(0xfffac8fe),
    -30: Color(0xfffde6ff),
    -35: Color(0xffffffff),
    -40: Color(0xffcccccd),
    -45: Color(0xff818281),
  };

  // Get the background color of text color for a certain temperature value
  Color _getTemperatureColor(num temp, bool isText) {
    if (model.unit == TemperatureUnit.celsius) temp = 32.0 + temp * 9.0 / 5.0;
    temp = temp.toInt();
    int lastDigit = temp % 10;
    int interval = (temp ~/ 10) * 10 + (lastDigit >= 5 ? 5 : 0);
    return isText
        ? Colors.black.withOpacity(0.5)
        : temperatureColorMap[
            interval > 110 ? 110 : interval < -45 ? -45 : interval];
  }
}
