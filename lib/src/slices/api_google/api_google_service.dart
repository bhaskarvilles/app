/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api_message/model/api_message_fetched_model.dart';
import 'package:app/src/slices/info_carousel_card/model/info_carousel_card_model.dart';
import 'package:app/src/utils/helper_json.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';

import 'repository/api_google_repository_info.dart';

class ApiGoogleService {
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: [GmailApi.gmailReadonlyScope]);
  final ApiGoogleRepositoryInfo _googleInfoRepository =
  ApiGoogleRepositoryInfo();

  Future<GoogleSignInAccount?> getConnectedUser() async {
    return await _googleSignIn.signInSilently();
  }

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<bool> signOut() async {
    await _googleSignIn.signOut();
    var success = !await _googleSignIn.isSignedIn();
    return success;
  }

  Future<bool> isConnected() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<List<InfoCarouselCardModel>> getInfoCards() async {
    List<dynamic>? infoJson = await _googleInfoRepository.load();
    return HelperJson.listFromJson(
        infoJson, (s) => InfoCarouselCardModel.fromJson(s));
  }

  Future<GmailApi?> getGmailApi() async {
    var authClient = await _googleSignIn.authenticatedClient();
    if (authClient != null) {
      return GmailApi(authClient);
    }
    return null;
  }

  Future<List<Message>> fetchGmailMessagesMetadata() async {
    var gmailApi = await getGmailApi();
    var emailList = await gmailApi?.users.messages.list("me");
    return emailList!.messages!;
  }

  ApiMessageFetchedModel processEmailListMessage(Message message) {
    var senderData = getSenderData(message);
    return ApiMessageFetchedModel(
      senderData: senderData,
      messageExtId: message.id,
      messageReceivedDate: message.internalDate,
      messageOpenedDate:
          message.labelIds!.contains("OPENED") ? message.internalDate : null,
      account: _googleSignIn.currentUser!.email,
      domain: senderData['email']!.split("@")[1].trim(),
    );
  }

  Future<Message> fetchAndProcessGmailMessage(Message messageMeta) async {
    var isListMessage = false;
    var gmailApi = await getGmailApi();
    var message = await gmailApi?.users.messages.get("me", messageMeta.id!,
        format: "metadata", metadataHeaders: ["List-unsubscribe", "From"]);
    var headers = message?.payload?.headers;
    if (headers != null) {
      for (var headerEntry in headers) {
        switch (headerEntry.name!.trim()) {
          case "List-Unsubscribe":
            isListMessage = true;
            break;
        }
      }
    }
    if (isListMessage) processEmailListMessage(message!);
  }

  Map<String, String> getSenderData(Message message) {
    var senderName;
    var senderEmail;
    var senderCategory;
    var unsubscribeMailTo;
    var headers = message.payload?.headers;
    if (headers != null) {
      for (var headerEntry in headers) {
        switch (headerEntry.name!.trim()) {
          case "From":
            var values = headerEntry.value!.split('<');
            if (values.length < 2) print(values);
            senderName = values[0].trim();
            senderEmail = values[1].trim().replaceFirst('>', '');
            break;
          case "List-Unsubscribe":
            unsubscribeMailTo = headerEntry.value!;
            break;
        }
      }
    }
    message.labelIds!.forEach((label) {
      if (label.contains("CATEGORY")) senderCategory = label;
    });
    return {
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderCategory': senderCategory,
      'unsubscribeMailTo': unsubscribeMailTo,
    };
  }
}
