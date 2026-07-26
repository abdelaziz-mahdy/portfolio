import 'package:flutter/foundation.dart';
import 'package:portfolio/github/data/portfolio_data_source.dart';
import 'package:portfolio/github/models/portfolio_data.dart';

enum PortfolioStatus { idle, loading, ready, error }

/// Single owner of the GitHub dataset for the whole app.
///
/// Every section reads from this one instance, so the dataset is loaded once
/// per session and the page shows a single loading state instead of one
/// spinner per section.
class PortfolioController extends ChangeNotifier {
  final PortfolioDataSource _dataSource;

  PortfolioController(this._dataSource);

  PortfolioStatus _status = PortfolioStatus.idle;
  PortfolioData? _data;
  Object? _error;

  PortfolioStatus get status => _status;
  PortfolioData? get data => _data;
  Object? get error => _error;

  bool get hasData => _data != null;

  /// Loads the dataset. Repeat calls are ignored unless [force] is set, so
  /// widgets can call this freely from `initState`.
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
      _data = await _dataSource.fetch();
      _status = PortfolioStatus.ready;
    } catch (error) {
      _error = error;
      // Keep any previously loaded data on screen; a failed refresh should not
      // blank out a page that was already working.
      _status = _data == null ? PortfolioStatus.error : PortfolioStatus.ready;
    }

    notifyListeners();
  }

  Future<void> refresh() => load(force: true);
}
