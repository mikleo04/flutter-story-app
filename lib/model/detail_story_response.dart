import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/model/story.dart';

part 'detail_story_response.g.dart';

@JsonSerializable()
class DetailStoryResponse {
  bool error;
  String message;
  Story story;

  DetailStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryResponseToJson(this);
}
