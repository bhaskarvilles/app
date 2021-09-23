/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api_app_data/api_app_data_service.dart';
import '../google_oauth_modal/google_oauth_modal_service.dart';
import '../home_screen/home_screen_service.dart';
import '../info_carousel/info_carousel_service.dart';
import '../info_carousel_card/model/info_carousel_card_model.dart';
import 'data_screen_service.dart';

class DataScreenController {
  final DataScreenService service;

  DataScreenController(this.service);

  Future<void> openGmailCards(BuildContext context, int accountId) async {
    List<InfoCarouselCardModel> cards = await service.getInfoCards(accountId);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            InfoCarouselService(cards: cards).presenter.render()));
  }

  Future<void> linkGmail(BuildContext context) async {
    ApiAppDataService apiAppDataService =
        Provider.of<ApiAppDataService>(context, listen: false);
    HomeScreenService homeScreenService =
        Provider.of<HomeScreenService>(context, listen: false);
    await service.linkAccount('Google');
    return homeScreenService.showOverlay(apiAppDataService);
  }

  linkAccount(String providerName) async {
    service.linkAccount(providerName);
  }

  removeAccount(int accountId) {
    service.removeAccount(accountId);
  }
}
