import 'package:flutter_test/flutter_test.dart';
import 'package:maids_project/modules/Login/login.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';

void main()
{
  late AppCubit appCubit;

  setUp(() {
    appCubit = AppCubit();
  });

  tearDown(() {
    appCubit.close();
  });

  group('Login Input Validation Tests', ()
  {
    testWidgets('Should show error when username and password are empty', (tester) async
    {
      await tester.pumpWidget(
        BlocProvider<AppCubit>.value(
          value: appCubit,
          child: const MaterialApp(
            home: Scaffold(
              body: Login(),
            ),
          ),
        ),
      );

      // Find submit button
      final submitButton = find.text(Localization.translate('submit_button_login')); // Adjust based on your button text

      // Press Submit
      await tester.tap(submitButton);
      await tester.pump();

      // Check Results
      expect(find.text(Localization.translate('username_login_tfm_error')), findsOneWidget);
      expect(find.text(Localization.translate('password_login_tfm_error')), findsOneWidget);
    });

    testWidgets('should allow submission when username and password are valid', (tester) async {

      await tester.pumpWidget(
        BlocProvider<AppCubit>.value(
          value: appCubit,
          child: const MaterialApp(
            home: Scaffold(
              body: Login(),
            ),
          ),
        ),
      );

      // Find widgets
      final usernameField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      final submitButton = find.text(Localization.translate('submit_button_login'));

      // Enter valid input in the username and password fields
      await tester.enterText(usernameField, 'test-user');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(submitButton);
      await tester.pump();

      // Assert no error messages appear
      expect(find.text(Localization.translate('username_login_tfm_error')), findsNothing);
      expect(find.text(Localization.translate('password_login_tfm_error')), findsNothing);
    });
  });
}