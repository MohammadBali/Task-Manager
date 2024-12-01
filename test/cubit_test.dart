import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:maids_project/shared/network/remote/main_dio_helper.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheHelper extends Mock implements CacheHelper {}
class MockDioHelper extends Mock implements MainDioHelper {}

void main() {
  late AppCubit appCubit;

  setUp(() {
    appCubit = AppCubit();
  });

  tearDown(() {
    appCubit.close();
  });

  group('AppCubit Theme Tests', () {
    blocTest<AppCubit, AppStates>(
      'emits [AppChangeThemeModeState] when theme is toggled',
      build: () => appCubit,
      act: (cubit) => cubit.changeTheme(),
      expect: () => [isA<AppChangeThemeModeState>()],
      verify: (_) {
        expect(appCubit.isDarkTheme, true); // Check the toggled value
      },
    );

    blocTest<AppCubit, AppStates>(
      'loads theme from cache and emits [AppChangeThemeModeState]',
      build: () => appCubit,
      act: (cubit) => cubit.changeTheme(themeFromState: true),
      expect: () => [isA<AppChangeThemeModeState>()],
      verify: (_) {
        expect(appCubit.isDarkTheme, true);
      },
    );
  });

  group('AppCubit Tab Bar Tests', () {
    blocTest<AppCubit, AppStates>(
      'emits [AppChangeTabBar] when tab index changes',
      build: () => appCubit,
      act: (cubit) => cubit.changeTabBar(1),
      expect: () => [isA<AppChangeTabBar>()],
      verify: (_) {
        expect(appCubit.tabBarIndex, 1); // Check the updated index
      },
    );
  });

  group('AppCubit Language Change Tests', () {
    blocTest<AppCubit, AppStates>(
      'emits [AppChangeLanguageState] when language is changed',
      build: () => appCubit,
      act: (cubit) => cubit.changeLanguage('en'),
      expect: () => [isA<AppChangeLanguageState>()],
      verify: (_) {
        expect(AppCubit.language, 'en'); // Ensure language is updated
      },
    );
  });


}