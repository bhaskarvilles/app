import 'package:flutter/material.dart';

import '../api_app_data/api_app_data_key.dart';
import '../api_app_data/api_app_data_service.dart';
import '../api_app_data/model/api_app_data_model.dart';
import '../api_company/api_company_service.dart';
import '../api_email_msg/api_email_msg_service.dart';
import '../api_email_sender/api_email_sender_service.dart';
import '../api_oauth/api_oauth_service.dart';
import '../data_fetch/data_fetch_service.dart';
import '../decision_card_spam/decision_card_spam_service.dart';
import '../decision_card_spam/ui/decision_card_spam_layout.dart';
import '../decision_screen/ui/decision_screen_view_card_test.dart';
import 'decision_screen_controller.dart';
import 'decision_screen_presenter.dart';
import 'model/decision_screen_model.dart';

class DecisionScreenService extends ChangeNotifier {
  late final DecisionScreenPresenter presenter;
  late final DecisionScreenController controller;
  late final DecisionScreenModel model;

  final ApiAppDataService _apiAppDataService;
  final DecisionCardSpamService _decisionCardSpamService;
  final ApiOAuthService _apiAuthService;

  DecisionScreenService(
      {required ApiAppDataService apiAppDataService,
      required ApiEmailSenderService apiEmailSenderService,
      required ApiEmailMsgService apiEmailMsgService,
      required ApiCompanyService apiCompanyService,
      required ApiOAuthService apiAuthService,
      required DataFetchService DataFetchService})
      : this._apiAppDataService = apiAppDataService,
        this._apiAuthService = apiAuthService,
        this._decisionCardSpamService = DecisionCardSpamService(
            apiEmailSenderService: apiEmailSenderService,
            apiEmailMsgService: apiEmailMsgService,
            apiAppDataService: apiAppDataService,
            apiCompanyService: apiCompanyService,
            DataFetchService: DataFetchService,
            apiAuthService: apiAuthService) {
    presenter = DecisionScreenPresenter(this);
    controller = DecisionScreenController(this);
    model = DecisionScreenModel();
    refresh();
  }

  //TODO fix this future builder anti-pattern
  Future<bool> refresh() async {
    bool isConnected = await _apiAuthService.getAccount() != null;
    if (isConnected) await _generateSpamCards();
    await _addTests();
    this.model.isLinked = isConnected;
    this.model.isPending =
        await _apiAppDataService.getByKey(ApiAppDataKey.emailIndexEpoch) ==
            null;
    return this.model.isLinked;
  }

  void removeCard() {
    this.model.cards.removeAt(0);
    notifyListeners();
  }

  Future<void> testDone() async =>
      _apiAppDataService.save(ApiAppDataKey.testCardsDone, "true");

  Future<void> _addTests() async {
    ApiAppDataModel? testDone =
        await _apiAppDataService.getByKey(ApiAppDataKey.testCardsDone);
    bool isTestDone = (testDone?.value == "true" ? true : false);
    if (!isTestDone && !this.model.testCardsAdded) {
      this.model.cards.addAll(List<DecisionScreenViewCardTest>.generate(
          3, (index) => DecisionScreenViewCardTest(index)).reversed.toList());
      this.model.testCardsAdded = true;
      this.model.isPending = true;
    }
  }

  Future<void> _generateSpamCards() async {
    if (!this.model.isLinked) return;
    if (this.model.cards.length < 3) {
      List<DecisionCardSpamLayout>? cards =
          await _decisionCardSpamService.getCards();
      if (cards != null && cards.isNotEmpty) {
        this.model.isPending =
            await _apiAppDataService.getByKey(ApiAppDataKey.emailIndexEpoch) ==
                null;
        cards.forEach((card) {
          if (!this.model.cards.contains(card) && this.model.cards.length < 3)
            this.model.cards.add(card);
        });
      }
    }
  }

  void removeAllCards() {
    this.model.cards = [];
    notifyListeners();
  }
}
