import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/core/env/env_config.dart';

String buildCapsterImageUrl(String photoPath) {
  final clean = photoPath.trim();

  if (clean.isEmpty) return "";
  if (clean.startsWith("http")) return clean;

  final fixedPath = clean.startsWith("/") ? clean.substring(1) : clean;

  return "${EnvConfig.baseUrl}/photos/$fixedPath";
}
