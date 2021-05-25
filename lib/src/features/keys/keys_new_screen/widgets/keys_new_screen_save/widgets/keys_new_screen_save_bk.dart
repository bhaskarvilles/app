/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/config/config_color.dart';
import 'package:app/src/features/keys/keys_new_screen/bloc/keys_new_screen_bloc.dart';
import 'package:app/src/features/keys/keys_new_screen/widgets/keys_new_screen_dialog_copy/keys_new_screen_dialog_copy.dart';
import 'package:app/src/features/repo/repo_local_ss_current/repo_local_ss_current.dart';
import 'package:app/src/features/repo/repo_local_ss_current/repo_local_ss_current_model.dart';
import 'package:app/src/utils/helper/helper_image.dart';
import 'package:app/src/utils/platform/platform_relative_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../keys_new_screen_dialog_copy/bloc/keys_new_screen_dialog_copy_bloc.dart';

class KeysNewScreenSaveBk extends StatelessWidget {
  KeysNewScreenSaveBk();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => KeysNewScreenDialogCopyBloc(),
        child: FutureBuilder(
            future: RepositoryProvider.of<RepoLocalSsCurrent>(context)
                .find(RepoLocalSsCurrent.key),
            builder: (BuildContext context,
                AsyncSnapshot<RepoLocalSsCurrentModel> currentModel) {
              return BlocConsumer<KeysNewScreenDialogCopyBloc,
                      KeysNewScreenDialogCopyState>(
                  listener: (BuildContext context,
                      KeysNewScreenDialogCopyState state) {
                    if (state is KeysNewScreenDialogCopySuccess && state.isKey)
                      BlocProvider.of<KeysNewScreenBloc>(context)
                          .add(KeysNewScreenBackedUp());
                  },
                  builder: (BuildContext context,
                          KeysNewScreenDialogCopyState state) =>
                      _horizontalButton(context, state, currentModel));
            }));
  }

  Widget _horizontalButton(
      BuildContext context,
      KeysNewScreenDialogCopyState state,
      AsyncSnapshot<RepoLocalSsCurrentModel> currentModel) {
    return GestureDetector(
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20), child:Stack(clipBehavior: Clip.none, children: [
          Container(
              margin: EdgeInsets.only(
                  bottom: 4 * PlatformRelativeSize.blockHorizontal),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: ConfigColor.alto),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: Offset(6, 6), // changes position of shadow
                    ),
                  ]),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: 0.5 * PlatformRelativeSize.blockVertical,
                            right: 4 * PlatformRelativeSize.blockHorizontal),
                        child: HelperImage("lock-icon")),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Save securely",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      3 * PlatformRelativeSize.blockVertical,
                                  color: ConfigColor.mardiGras)),
                          Text("(recommended)",
                              style: TextStyle(
                                  fontSize:
                                      3 * PlatformRelativeSize.blockVertical,
                                  fontWeight: FontWeight.bold,
                                  color: ConfigColor.jade)),
                        ])
                  ])),
          state is KeysNewScreenDialogCopySuccess && state.isKey
              ? Positioned(
                  top: -35,
                  right: -35,
                  child: HelperImage("green-check"))
              : Container(),
        ])),
        onTap: () => _saveKey(context, currentModel.data!));
  }

  _saveKey(BuildContext context, RepoLocalSsCurrentModel currentModel) async {
    KeysNewScreenState state =
        BlocProvider.of<KeysNewScreenBloc>(context).state;
    KeysNewScreenDialogCopyBloc bloc =
        BlocProvider.of<KeysNewScreenDialogCopyBloc>(context);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          String key = state.address! +
              '.' +
              state.dataPrivate! +
              '.' +
              state.signPrivate!;
          return KeysNewScreenDialogCopy().alert(bloc, key, currentModel);
        });
  }
}
