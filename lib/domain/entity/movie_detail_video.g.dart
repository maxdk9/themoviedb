// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailVideo _$MovieDetailVideoFromJson(Map<String, dynamic> json) =>
    MovieDetailVideo(
      results: (json['results'] as List<dynamic>)
          .map(
              (e) => MovieDetailVideoResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieDetailVideoToJson(MovieDetailVideo instance) =>
    <String, dynamic>{
      'results': instance.results.map((e) => e.toJson()).toList(),
    };

MovieDetailVideoResult _$MovieDetailVideoResultFromJson(
        Map<String, dynamic> json) =>
    MovieDetailVideoResult(
      iso6391: json['iso_639_1'] as String,
      iso31661: json['iso_3166_1'] as String,
      name: json['name'] as String,
      key: json['key'] as String,
      site: json['site'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      official: json['official'] as bool,
      id: json['id'] as String,
    );

Map<String, dynamic> _$MovieDetailVideoResultToJson(
        MovieDetailVideoResult instance) =>
    <String, dynamic>{
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'name': instance.name,
      'key': instance.key,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'id': instance.id,
    };
