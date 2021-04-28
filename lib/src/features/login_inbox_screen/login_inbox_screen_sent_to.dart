/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/config/config_string.dart';
import 'package:app/src/features/login_otp_req/login_otp_req_bloc.dart';
import 'package:app/src/utils/platform/platform_relative_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginInboxScreenSentTo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginInboxScreenSentTo();
}

class _LoginInboxScreenSentTo extends State<LoginInboxScreenSentTo> {
  static final double _fontSize = 5 * PlatformRelativeSize.blockHorizontal;

  @override
  void initState() {
    super.initState();
    LoginOtpReqBloc bloc = BlocProvider.of<LoginOtpReqBloc>(context);
    bloc.add(LoginOtpReqLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginOtpReqBloc, LoginOtpReqState>(
        builder: (BuildContext context, LoginOtpReqState state) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(ConfigString.loginInbox.sentTo,
            style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600)),
        Text(state.email == null ? "" : state.email,
            style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold))
      ]);
    });
  }
}
