/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import '../../../../utils/json/json_object.dart';

class ApiKnowledgeModelCompanyType extends JsonObject {
  String? sector;
  String? industry;
  String? subIndustry;
  List<String>? tags;

  ApiKnowledgeModelCompanyType(
      {this.sector, this.industry, this.subIndustry, this.tags});

  ApiKnowledgeModelCompanyType.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      this.sector = json['sector'];
      this.industry = json['industry'];
      this.subIndustry = json['subIndustry'];
      this.tags = json['tags'] != null ? List.from(json['tags']) : null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'sector': sector,
        'industry': industry,
        'subIndustry': subIndustry,
        'tags': tags,
      };
}
