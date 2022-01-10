/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';

import 'keys_restore_screen_layout_background.dart';
import 'keys_restore_screen_layout_foreground.dart';

class KeysRestoreScreenLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Stack(children: [
      KeysRestoreScreenLayoutBackground(),
      KeysRestoreScreenLayoutForeground(),
    ])));
  }
}
