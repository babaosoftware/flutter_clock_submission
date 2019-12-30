import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vintageradiodial_clock/widgets/themewidget.dart';

/// The marker that moves across the upper and lower dials

class MarkerWidget extends StatefulWidget {
  // * true if this is the upper scale dial marker
  final bool isHour;

  MarkerWidget(this.isHour) : super();

  @override
  _MarkerWidgetState createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<MarkerWidget> {
  DateTime _dateTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeValues themeValues = ThemeWidget.of(context);

    // Calculate current position of the marker relative to the current minute in the hours
    // or the current second in the minute
    double hAlign = widget.isHour
        ? -1.0 + 2.0 / 3590.0 * (_dateTime.minute * 60.0 + _dateTime.second)
        : -1.0 + 2.0 / 59.0 * _dateTime.second;

    return Positioned.fill(
      child: AnimatedAlign(
          duration: Duration(seconds: 1),
          alignment: Alignment(hAlign, 0.0),
          child: Container(
            padding: EdgeInsets.only(
                top: widget.isHour ? 0.0 : 30.0 * themeValues.pixelRatio,
                bottom: widget.isHour ? 30.0 * themeValues.pixelRatio : 0.0),
            width: 40.0 * themeValues.pixelRatio,
            child: Column(
              children: <Widget>[
                widget.isHour
                    ? _getDialBody(context)
                    : _getDialExtension(context, widget.isHour),
                widget.isHour
                    ? _getDialExtension(context, widget.isHour)
                    : _getDialBody(context),
              ],
            ),
          )),
    );
  }

  // Lower part of the marker
  Widget _getDialBody(BuildContext context) {
    ThemeValues themeValues = ThemeWidget.of(context);
    return Container(
      height: 20.0 * themeValues.pixelRatio,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.2, 0.8, 1.0],
          colors: [
            themeValues.markerBaseDarkColor,
            themeValues.markerBaseLightColor,
            themeValues.markerBaseLightColor,
            themeValues.markerBaseDarkColor,
          ],
        ),
      ),
    );
  }

  // Marker's body
  Widget _getDialExtension(BuildContext context, isHour) {
    ThemeValues themeValues = ThemeWidget.of(context);
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isHour
              ? new BorderRadius.only(
                  bottomLeft: Radius.circular(32.0 * themeValues.pixelRatio),
                  bottomRight: Radius.circular(32.0 * themeValues.pixelRatio))
              : new BorderRadius.only(
                  topLeft: Radius.circular(32.0 * themeValues.pixelRatio),
                  topRight: Radius.circular(32.0 * themeValues.pixelRatio)),
          gradient: LinearGradient(
            tileMode: TileMode.mirror,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.2, 0.8, 1.0],
            colors: [
              themeValues.markerExtensionDarkColor,
              themeValues.markerExtensionLightColor,
              themeValues.markerExtensionLightColor,
              themeValues.markerExtensionDarkColor,
            ],
          ),
        ),
      ),
    );
  }
}
