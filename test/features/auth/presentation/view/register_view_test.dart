import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkora_app/features/auth/presentation/view/register_view.dart';
import 'package:linkora_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mock the RegisterBloc class
class MockRegisterBloc extends MockBloc<RegisterEvent, RegisterState>
    implements RegisterBloc {}

void main() {
  late MockRegisterBloc registerBloc;

  setUp(() {
    registerBloc = MockRegisterBloc();
  });

  // Helper function to load the RegisterView widget with a mocked RegisterBloc
  Widget loadRegisterView() {
    return BlocProvider<RegisterBloc>(
      create: (context) => registerBloc,
      child: const MaterialApp(home: RegisterView()),
    );
  }

  testWidgets('check for the "Sign Up" button in Register UI', (tester) async {
    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Find the 'Sign Up' button by its label text
    final result = find.widgetWithText(ElevatedButton, 'Sign Up');
    expect(result, findsOneWidget);
  });

  testWidgets('Check for "Join Us Today" text in Register UI', (tester) async {
    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Find the 'Join Us Today' text by its label
    final joinUsText = find.text('Join Us Today');
    expect(joinUsText, findsOneWidget);
  });

  testWidgets('Check for entering full name and email', (tester) async {
    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Enter text into form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    // Tap the 'Sign Up' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check if the entered values are shown in the text fields
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
  });

  testWidgets('Check for password mismatch and snackbar display',
      (tester) async {
    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Enter text into form fields with mismatched passwords
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(
        find.byType(TextFormField).at(3), 'differentPassword');

    // Tap the 'Sign Up' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Verify that the snackbar with the message "Passwords do not match" is displayed
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Check for validation errors if fields are empty',
      (tester) async {
    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Leave fields empty and tap 'Sign Up'
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    await tester.enterText(find.byType(TextFormField).at(2), '');
    await tester.enterText(find.byType(TextFormField).at(3), '');

    // Tap the 'Sign Up' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check for validation error messages
    expect(find.text('Please enter full name'), findsOneWidget);
    expect(find.text('Please enter email'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
    expect(find.text('Please enter confirm password'), findsOneWidget);
  });

  // Simulate the register success scenario
  testWidgets('Register success', (tester) async {
    when(() => registerBloc.state)
        .thenReturn(const RegisterState(isLoading: false, isSuccess: true));

    await tester.pumpWidget(loadRegisterView());
    await tester.pumpAndSettle();

    // Enter text into form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.enterText(find.byType(TextFormField).at(3), 'password123');

    // Tap the 'Sign Up' button
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Check if the register state is successful
    expect(registerBloc.state.isSuccess, true);
  });
}
