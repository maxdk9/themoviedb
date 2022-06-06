import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_video.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailVideo {
  final List<MovieDetailVideoResult> results;

  MovieDetailVideo({
    required this.results,
  });

  factory MovieDetailVideo.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailVideoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailVideoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetailVideoResult {
  @JsonKey(name: 'iso_639_1')
  final String iso6391;
  @JsonKey(name: 'iso_3166_1')
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;

  final String id;

  MovieDetailVideoResult({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });

  factory MovieDetailVideoResult.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailVideoResultFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailVideoResultToJson(this);
}
