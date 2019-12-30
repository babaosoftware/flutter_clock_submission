import 'package:flutter/material.dart';
import 'package:vintageradiodial_clock/widgets/themewidget.dart';

/// Shows the AM/PM text when 12 hour format

class AMPMWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeValues themeValues = ThemeWidget.of(context);
    double fontSize = 30.0 * themeValues.pixelRatio;
    Color textGlowColor = themeValues.textGlowColor;
    Color textDisableColor = themeValues.textDisabledColor;
    Color textEnabledColor = themeValues.textEnabledColor;
    bool isAM = DateTime.now().hour < 12;
    const double blurRadius = 1.0;
    const double letterSpacing = 4.0;

    TextStyle textStyleAM = TextStyle(
      color: isAM ? textEnabledColor : textDisableColor,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      shadows: isAM
          ? [
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
            ]
          : [],
    );
    TextStyle textStylePM = TextStyle(
      color: isAM ? textDisableColor : textEnabledColor,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      shadows: isAM
          ? []
          : [
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
              Shadow(
                blurRadius: blurRadius,
                color: textGlowColor,
              ),
            ],
    );

    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: 16.0 * themeValues.pixelRatio,
                      right: 32.0 * themeValues.pixelRatio),
                  child: Text("AM", style: textStyleAM),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: 16.0 * themeValues.pixelRatio,
                      left: 32.0 * themeValues.pixelRatio),
                  child: Text("PM", style: textStylePM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
