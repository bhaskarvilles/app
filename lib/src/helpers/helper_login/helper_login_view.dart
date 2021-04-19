/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/repos/repo_amplitude/repo_amplitude_bloc.dart';
import 'package:app/src/repos/repo_amplitude/repo_amplitude_bloc_provider.dart';
import 'package:app/src/repos/repo_amplitude/repo_amplitude_const.dart'
    as AmpConst;
import 'package:flutter/widgets.dart';

import 'helper_login_bloc_provider.dart';
import 'helper_login_model.dart';
import 'helper_login_model_state.dart';

class HelperLoginView extends StatelessWidget {
  final Widget _loggedIn;
  final Widget _creating;
  final Widget _loggedOut;
  final Widget _pending;
  final String _otp;

  HelperLoginView(this._otp, this._loggedIn, this._creating, this._loggedOut,
      this._pending);

  @override
  Widget build(BuildContext context) {
    RepoAmplitudeBloc repoAmplitudeBloc =
        RepoAmplitudeBlocProvider.of(context).bloc;
    return FutureBuilder<HelperLoginModel>(
        future: HelperLoginBlocProvider.of(context).bloc.loginOtp(_otp),
        builder: (context, AsyncSnapshot<HelperLoginModel> snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data.state == HelperLoginModelState.loggedIn)
              return _loggedIn;
            else if (snapshot.data.state == HelperLoginModelState.creating) {
              repoAmplitudeBloc.event(AmpConst.validateOtpE,
                  properties: {AmpConst.requestOtpPSuccess: true});
              return _creating;
            } else if (snapshot.data.state == HelperLoginModelState.loggedOut) {
              repoAmplitudeBloc.event(AmpConst.validateOtpE,
                  properties: {AmpConst.requestOtpPSuccess: false});
              return _loggedOut;
            }
          }
          return _pending;
        });
  }
}
