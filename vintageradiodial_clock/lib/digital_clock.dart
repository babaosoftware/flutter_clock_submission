// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vintageradiodial_clock/widgets/markerwidget.dart';
import 'package:vintageradiodial_clock/widgets/digitwidget.dart';
import 'package:vintageradiodial_clock/widgets/tempbarwidget.dart';
import 'package:vintageradiodial_clock/widgets/themewidget.dart';
import 'package:vintageradiodial_clock/widgets/ampmwidget.dart';

/// A vintage radio dial digital clock face
/// It has three dials:
/// Upper: Hours with a marker that shows the current minute inside the hour
/// Middle: A gradient-colored temperature range and weather condition icon
/// Lower: Minutes with a marker that shows the current second inside the minute

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: TextStyle(fontFamily: ThemeWidget.of(context).defaultFont),
        child: _getClock());
  }

  Widget _getClock() {
    ThemeValues themeValues = ThemeWidget.of(context);

    return Stack(
      children: <Widget>[
        Container(
            color: ThemeWidget.of(context).clockBackground,
            child: Center(
                child: Padding(
              padding: EdgeInsets.only(
                  left: 32.0 * themeValues.pixelRatio,
                  right: 32.0 * themeValues.pixelRatio),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _getDigits(true),
                        ),
                        widget.model.is24HourFormat
                            ? Container()
                            : AMPMWidget(),
                        MarkerWidget(true),
                      ],
                    ),
                  ),
                  TempeBarWidget(widget.model),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _getDigits(false),
                        ),
                        MarkerWidget(false),
                      ],
                    ),
                  )
                ],
              ),
            ))),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/scratch.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  themeValues.scratchColor, BlendMode.modulate),
            ),
          ),
        ),
      ],
    );
  }

  // Returns a list of 7 digit widgets for the lower or lower dials, with
  // the middle digit as the current hour/minute
  List<Widget> _getDigits(isHours) {
    List<Widget> digits = [];

    List<String> digitValues = [];
    if (isHours) {
      if (widget.model.is24HourFormat) {
        for (int i = 0; i <= 23; i++) digitValues.add(i.toString());
      } else {
        for (int i = 0; i <= 11; i++)
          digitValues.add(i == 0 ? "12" : i.toString());
      }
    } else {
      for (int i = 0; i <= 59; i++)
        digitValues.add((i < 10 ? "0" : "") + i.toString());
    }

    int currentHour = _dateTime.hour;
    int currentIndex = isHours
        ? (widget.model.is24HourFormat
            ? currentHour
            : (currentHour >= 12 ? currentHour - 12 : currentHour))
        : _dateTime.minute;

    final int leftDigits = isHours ? 3 : 3;
    final int rightDigits = isHours ? 3 : 3;

    final int adder = isHours ? (widget.model.is24HourFormat ? 24 : 12) : 60;

    for (var i = leftDigits; i >= 1; i--) {
      var val =
          digitValues[currentIndex - i + (currentIndex - i >= 0 ? 0 : adder)];
      digits.add(DigitWidget(false, isHours, val));
    }
    digits.add(DigitWidget(true, isHours, digitValues[currentIndex]));

    for (var i = 1; i <= rightDigits; i++) {
      var val = digitValues[currentIndex +
          i -
          (currentIndex + i >= digitValues.length ? adder : 0)];
      digits.add(DigitWidget(false, isHours, val));
    }

    return digits;
  }
}
