import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/login_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
  mockAuthCubit = MockAuthCubit();

  when(() => mockAuthCubit.state)
      .thenReturn(AuthInitial());

  when(() => mockAuthCubit.stream)
      .thenAnswer((_) => Stream.value(AuthInitial()));
});

  tearDown(() {
    reset(mockAuthCubit);
  });

  Widget createTestWidget() {
  return BlocProvider<AuthCubit>.value(
    value: mockAuthCubit,
    child: MaterialApp(
      home: const LoginPage(),
    ),
  );
}

  testWidgets(
    'Login page should display all main elements',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Employee Management'),
        findsOneWidget,
      );

      expect(
        find.text('Sign in to continue'),
        findsOneWidget,
      );

      expect(
        find.text('Email'),
        findsOneWidget,
      );

      expect(
        find.text('Password'),
        findsOneWidget,
      );

      expect(
        find.text('Forgot Password?'),
        findsOneWidget,
      );

      expect(
        find.text('Login'),
        findsOneWidget,
      );

      expect(
        find.text('Continue with Google'),
        findsOneWidget,
      );

      expect(
        find.text("Don't have an account? Register"),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Login should show validation errors when fields are empty',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Login'),
      );

      await tester.pump();

      expect(
        find.text('Email is required'),
        findsOneWidget,
      );

      expect(
        find.text('Password is required'),
        findsOneWidget,
      );

      verifyNever(
        () => mockAuthCubit.login(
          any(),
          any(),
        ),
      );
    },
  );

  testWidgets(
    'Login should show email validation error for invalid email',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);

      await tester.enterText(
        textFields.at(0),
        'invalid-email',
      );

      await tester.enterText(
        textFields.at(1),
        'password123',
      );

      await tester.tap(
        find.text('Login'),
      );

      await tester.pump();

      expect(
        find.text('Enter a valid email'),
        findsOneWidget,
      );

      verifyNever(
        () => mockAuthCubit.login(
          any(),
          any(),
        ),
      );
    },
  );

  testWidgets(
    'Login should call AuthCubit when valid data is entered',
    (tester) async {
      when(
        () => mockAuthCubit.login(
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async {},
      );

      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);

      await tester.enterText(
        textFields.at(0),
        'john@example.com',
      );

      await tester.enterText(
        textFields.at(1),
        'password123',
      );

      await tester.tap(
        find.text('Login'),
      );

      await tester.pump();

      verify(
        () => mockAuthCubit.login(
          'john@example.com',
          'password123',
        ),
      ).called(1);
    },
  );

  testWidgets(
    'Password visibility button should toggle password visibility',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final passwordField = find.byType(TextFormField).at(1);

      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: passwordField,
                matching: find.byType(EditableText),
              ),
            )
            .obscureText,
        true,
      );

      await tester.tap(
        find.byIcon(Icons.visibility),
      );

      await tester.pump();

      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: passwordField,
                matching: find.byType(EditableText),
              ),
            )
            .obscureText,
        false,
      );

      await tester.tap(
        find.byIcon(Icons.visibility_off),
      );

      await tester.pump();

      expect(
        tester
            .widget<EditableText>(
              find.descendant(
                of: passwordField,
                matching: find.byType(EditableText),
              ),
            )
            .obscureText,
        true,
      );
    },
  );

  testWidgets(
    'Google Sign-In button should call AuthCubit',
    (tester) async {
      when(
        () => mockAuthCubit.signInWithGoogle(),
      ).thenAnswer(
        (_) async {},
      );

      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Continue with Google'),
      );

      await tester.pump();

      verify(
        () => mockAuthCubit.signInWithGoogle(),
      ).called(1);
    },
  );

  testWidgets(
    'Forgot Password button should navigate to Forgot Password page',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Forgot Password?'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Forgot Password'),
        findsOneWidget,
      );

      expect(
        find.text('Reset Password'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Register button should navigate to Register page',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final registerButton = find.text(
        "Don't have an account? Register",
      );

      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Create Account'),
        findsOneWidget,
      );

      expect(
        find.text('Create your account'),
        findsOneWidget,
      );
    },
  );
}
