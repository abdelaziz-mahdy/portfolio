import 'package:get_it/get_it.dart';
import 'package:portfolio/github/controller/portfolio_controller.dart';
import 'package:portfolio/github/data/portfolio_data_source.dart';
import 'package:portfolio/theme/theme_controller.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<PortfolioDataSource>(() => PortfolioDataSource());
  getIt.registerLazySingleton<PortfolioController>(
    () => PortfolioController(getIt<PortfolioDataSource>()),
  );
  getIt.registerLazySingleton<ThemeController>(() => ThemeController());
}
