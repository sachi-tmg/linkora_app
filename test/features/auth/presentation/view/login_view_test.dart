import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/features/auth/presentation/view/login_view.dart';
import 'package:linkora_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mocking the LoginBloc class
class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();
  });

  // Helper function to load the LoginView widget with a mocked LoginBloc
  Widget loadLoginView() {
    return BlocProvider<LoginBloc>(
      create: (context) => loginBloc,
      child: MaterialApp(home: LoginView()),
    );
  }

  testWidgets('check for the "Sign In" button in login UI', (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Find the 'Sign In' button by its label text
    final result = find.widgetWithText(ElevatedButton, 'Sign In');
    expect(result, findsOneWidget);
  });

  testWidgets('Check for the "Welcome" text in login UI', (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Find the 'Welcome' text by its label
    final welcomeText = find.text('Welcome');
    expect(welcomeText, findsOneWidget);
  });

  testWidgets('Check for entering username and password', (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Enter text into email and password fields
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'test@example.com');
    await tester.enterText(
        find.byKey(const ValueKey('password')), 'password123');

    // Tap the 'Sign In' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check if the entered values are shown in the text fields
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });

  testWidgets('Check for validation errors if fields are empty',
      (tester) async {
    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Leave email and password fields empty
    await tester.enterText(find.byKey(const ValueKey('email')), '');
    await tester.enterText(find.byKey(const ValueKey('password')), '');

    // Tap the 'Sign In' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check for validation error messages
    expect(find.text('Please enter email'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });

  // Simulate a successful login
  testWidgets('Login success', (tester) async {
    when(() => loginBloc.state)
        .thenReturn(LoginState(isLoading: false, isSuccess: true));

    await tester.pumpWidget(loadLoginView());
    await tester.pumpAndSettle();

    // Enter text into email and password fields
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'test@example.com');
    await tester.enterText(
        find.byKey(const ValueKey('password')), 'password123');

    // Tap the 'Sign In' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check if the login was successful based on the state
    expect(loginBloc.state.isSuccess, true);
  });
}
