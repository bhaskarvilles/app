/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import '../../../utils/json/json_object.dart';
import 'info_carousel_card_model_cover_header.dart';

class InfoCarouselCardModelCover extends JsonObject {
  String? image;
  String? subtitle;
  String? bigTextLight;
  String? bigTextDark;
  String? text;
  InfoCarouselCardModelCoverHeader? header;

  InfoCarouselCardModelCover(
      {this.image,
      this.subtitle,
      this.bigTextLight,
      this.bigTextDark,
      this.text,
      this.header});

  InfoCarouselCardModelCover.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      this.image = json['image'];
      this.subtitle = json['subtitle'];
      this.bigTextDark = json['bigTextDark'];
      this.bigTextLight = json['bigTextLight'];
      this.text = json['text'];
      this.header = InfoCarouselCardModelCoverHeader.fromJson(json['header']);
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'image': image,
        'subtitle': subtitle,
        'bigTextDark': bigTextLight,
        'bigTextLight': bigTextDark,
        'text': text,
        'header': header?.toJson()
      };

  InfoCarouselCardModelCover.fromDynamic(dynamic data) {
    image = data.image;
    subtitle = data.subtitle;
    bigTextLight = data.bigTextLight;
    bigTextDark = data.bigTextDark;
    text = data.text;
    header = InfoCarouselCardModelCoverHeader.fromDynamic(data.header);
  }
}
