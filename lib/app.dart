/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'src/config/config_color.dart';
import 'src/config/config_font.dart';
import 'src/config/config_sentry.dart';

class App extends StatelessWidget {
  static const String _title = "TIKI";
  final RouterDelegate _routerDelegate;

  const App(this._routerDelegate);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: _title,
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
                fontFamily: ConfigFont.familyNunitoSans,
                bodyColor: ConfigColor.tikiBlue,
                displayColor: ConfigColor.tikiBlue)),
        home: Router(
            routerDelegate: _routerDelegate,
            backButtonDispatcher: RootBackButtonDispatcher()),
        navigatorObservers: [ConfigSentry.navigatorObserver],
      );
    });
  }
}
