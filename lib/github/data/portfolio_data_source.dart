import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:portfolio/constants/constants.dart';
import 'package:portfolio/github/models/portfolio_data.dart';

/// Loads the CI-generated GitHub dataset.
///
/// The remote copy on raw.githubusercontent.com is served from a CDN with no
/// rate limit and is refreshed by the `Get GitHub User Info` workflow, so it
/// stays current without redeploying the site. The bundled asset is the
/// fallback for an offline visitor or a network failure.
class PortfolioDataSource {
  final Dio _dio;

  PortfolioDataSource({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              responseType: ResponseType.plain,
            ));

  Future<PortfolioData> fetch() async {
    try {
      final response = await _dio.get<String>(Constants.githubDataUrl);
      final body = response.data;
      if (body != null && body.isNotEmpty) {
        return _parse(body);
      }
    } catch (_) {
      // Fall through to the bundled copy rather than showing an empty page.
    }

    final bundled = await rootBundle.loadString(Constants.githubDataAsset);
    return _parse(bundled);
  }

  PortfolioData _parse(String body) =>
      PortfolioData.fromJson(json.decode(body) as Map<String, dynamic>);
}
