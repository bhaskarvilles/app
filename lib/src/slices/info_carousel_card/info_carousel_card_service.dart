/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/helper_permission.dart';
import 'info_carousel_card_controller.dart';
import 'info_carousel_card_presenter.dart';
import 'model/info_carousel_card_model.dart';

class InfoCarouselCardService extends ChangeNotifier {
  late final InfoCarouselCardPresenter presenter;
  late final InfoCarouselCardModel model;
  late final InfoCarouselCardController controller;

  InfoCarouselCardService({dynamic card}) {
    presenter = InfoCarouselCardPresenter(this);
    controller = InfoCarouselCardController(this);
    if (card != null)
      model = card;
    else
      model = InfoCarouselCardModel();
  }

  void setCard(InfoCarouselCardModel card) {
    this.model = card;
    notifyListeners();
  }

  shareCard(String message, String image) async {
    bool permission = await HelperPermission.request(Permission.storage);
    if (permission) {
      ByteData? bytes = await rootBundle.load("res/images/$image");
      var buffer = bytes.buffer;
      Uint8List pngBytes = buffer.asUint8List();
      Directory directory;
      if (Platform.isIOS)
        directory = await getApplicationDocumentsDirectory();
      else
        directory = (await getExternalStorageDirectory())!;
      String path = directory.path + '/tikishare.png';
      File imgFile = new File(path);
      imgFile.writeAsBytesSync(pngBytes, flush: true);
      Share.shareFiles(
        [path],
        text: message,
      );
    }
  }
}
