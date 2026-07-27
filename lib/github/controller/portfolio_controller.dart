import 'package:flutter/foundation.dart';
import 'package:portfolio/github/data/portfolio_data_source.dart';
import 'package:portfolio/github/models/portfolio_data.dart';
import 'package:portfolio/profile/models/profile.dart';

enum PortfolioStatus { idle, loading, ready, error }

/// Single owner of both documents the page renders: the CI-generated GitHub
/// dataset and the hand-edited profile.
///
/// They load concurrently and the page has one loading state rather than one
/// spinner per section.
class PortfolioController extends ChangeNotifier {
  final PortfolioDataSource _dataSource;

  PortfolioController(this._dataSource);

  PortfolioStatus _status = PortfolioStatus.idle;
  PortfolioData? _githubData;
  Profile? _profile;
  Object? _error;

  PortfolioStatus get status => _status;
  PortfolioData? get githubData => _githubData;
  Profile? get profile => _profile;
  Object? get error => _error;

  bool get isReady => _status == PortfolioStatus.ready;

  /// Loads both documents. Repeat calls are ignored unless [force] is set, so
  /// widgets can call this freely.
  Future<void> load({bool force = false}) async {
    if (!force &&
        (_status == PortfolioStatus.loading ||
            _status == PortfolioStatus.ready)) {
      return;
    }

    _status = PortfolioStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dataSource.fetchGithubData(),
        _dataSource.fetchProfile(),
      ]);

      _githubData = results[0] as PortfolioData;
      _profile = results[1] as Profile;
      _status = PortfolioStatus.ready;
    } catch (error) {
      _error = error;
      // Keep whatever was already loaded on screen; a failed refresh should
      // not blank out a page that was working.
      _status = _githubData == null && _profile == null
          ? PortfolioStatus.error
          : PortfolioStatus.ready;
    }

    notifyListeners();
  }

  Future<void> refresh() => load(force: true);
}
