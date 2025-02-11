/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import '../../../../utils/json/json_object.dart';

class ApiKnowledgeModelCompanySocial extends JsonObject {
  String? facebook;
  String? twitter;
  String? linkedin;

  ApiKnowledgeModelCompanySocial({this.facebook, this.twitter, this.linkedin});

  ApiKnowledgeModelCompanySocial.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      this.facebook = json['facebook'];
      this.twitter = json['twitter'];
      this.linkedin = json['linkedin'];
    }
  }

  @override
  Map<String, dynamic> toJson() =>
      {'facebook': facebook, 'twitter': twitter, 'linkedin': linkedin};
}
