import 'package:flutter/material.dart';
import 'package:vintageradiodial_clock/widgets/themewidget.dart';

//// Shows the digits on the upper and lower dials

class DigitWidget extends StatefulWidget {
  // * If this represents the current hour/minute
  final bool isCurrent;

  // * The digit(s) as a string
  final String digit;

  // * true if is the upper, hours dial
  final bool isHours;

  DigitWidget(this.isCurrent, this.isHours, this.digit);

  @override
  _DigitWidgetState createState() => _DigitWidgetState();
}

class _DigitWidgetState extends State<DigitWidget> {
  // * The duration of the current hour/minute change
  Duration _animationDuration = Duration(milliseconds: 500);
  TextStyle _textStyle;
  double _fontSize;
  String _digit;

  // * Magic values so it scales nice on all screen sizes/density
  static const double FONT_BIG = 230.0;
  static const double FONT_SMALL = 50.0;

  @override
  void initState() {
    super.initState();
    _digit = widget.digit;
  }

  @override
  Widget build(BuildContext context) {
    ThemeValues themeValues = ThemeWidget.of(context);
    _fontSize =
        (widget.isCurrent ? FONT_BIG : FONT_SMALL) * themeValues.pixelRatio;
    if (_digit != widget.digit) {
      if (widget.isCurrent && (!widget.isHours || DateTime.now().minute == 0)) {
        _fontSize = FONT_SMALL * themeValues.pixelRatio;
        Future.delayed(
            Duration(milliseconds: 500),
            () => setState(() {
                  if (mounted) {
                    ThemeValues themeValues = ThemeWidget.of(context);
                    _digit = widget.digit;
                    _fontSize = FONT_BIG * themeValues.pixelRatio;
                  }
                }));
      } else
        _digit = widget.digit;
    }
    Color digitColor = widget.isHours
        ? (widget.isCurrent
            ? themeValues.currentHourColor
            : themeValues.hourColor)
        : (widget.isCurrent
            ? themeValues.currentMinuteColor
            : themeValues.minuteColor);
    Color digitGlowColor = widget.isHours
        ? (widget.isCurrent
            ? themeValues.currentHourGlowColor
            : themeValues.hourGlowColor)
        : (widget.isCurrent
            ? themeValues.currentMinuteGlowColor
            : themeValues.minuteGlowColor);

    double blurRadius = widget.isCurrent ? 3.0 : 1.0;
    double letterSpacing = widget.isCurrent ? 8 : 4;
    FontWeight fontWeight =
        widget.isCurrent ? FontWeight.bold : FontWeight.normal;
    String fontFamily =
        widget.isCurrent ? themeValues.bigDigitFont : themeValues.defaultFont;

    _textStyle = TextStyle(
      fontFamily: fontFamily,
      color: digitColor,
      fontSize: _fontSize ??
          (widget.isCurrent && widget.isHours && DateTime.now().minute != 0
                  ? FONT_BIG
                  : FONT_SMALL) *
              themeValues.pixelRatio,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      shadows: [
        Shadow(
          blurRadius: blurRadius,
          color: digitGlowColor,
        ),
        Shadow(
          blurRadius: blurRadius,
          color: digitGlowColor,
        ),
        Shadow(
          blurRadius: blurRadius,
          color: digitGlowColor,
        ),
        Shadow(
          blurRadius: blurRadius,
          color: digitGlowColor,
        ),
      ],
    );

    return Expanded(
        flex: widget.isCurrent ? 6 : 2,
        child: Center(
            child: AnimatedDefaultTextStyle(
                duration: _animationDuration,
                style: _textStyle,
                child: Text("$_digit"))));
  }
}
