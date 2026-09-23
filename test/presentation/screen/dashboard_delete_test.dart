import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/employee_dashboard_page.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';

class MockEmployeeCubit extends Mock implements EmployeeCubit {}

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockEmployeeCubit mockEmployeeCubit;
  late MockAuthCubit mockAuthCubit;

  final employee = Employee(
    id: '123',
    name: 'John Doe',
    emailId: 'john@example.com',
    mobile: '9876543210',
    country: 'India',
    state: 'Maharashtra',
    district: 'Pune',
  );

  setUp(() {
  mockEmployeeCubit = MockEmployeeCubit();
  mockAuthCubit = MockAuthCubit();

  when(() => mockEmployeeCubit.state)
      .thenReturn(EmployeeLoaded([employee]));

  when(() => mockEmployeeCubit.stream)
      .thenAnswer(
        (_) => Stream.value(EmployeeLoaded([employee])),
      );

  when(() => mockAuthCubit.state)
      .thenReturn(AuthUnauthenticated());

  when(() => mockAuthCubit.stream)
      .thenAnswer(
        (_) => Stream.value(AuthUnauthenticated()),
      );

  when(() => mockEmployeeCubit.deleteEmployee(any()))
      .thenAnswer((_) async {});
});

  tearDown(() {
    reset(mockEmployeeCubit);
    reset(mockAuthCubit);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeCubit>.value(
            value: mockEmployeeCubit,
          ),
          BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
          ),
        ],
        child: EmployeeDashboardPage(
          onThemeToggle: () {},
          isDarkMode: false,
        ),
      ),
    );
  }

  testWidgets(
    'Delete button should display confirmation dialog',
    (tester) async {
      await tester.pumpWidget(
        createTestWidget(),
      );

      await tester.tap(
        find.text('Delete'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Delete Employee'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Are you sure you want to delete John Doe?',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Cancel'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Cancel button should close delete confirmation dialog',
    (tester) async {
      await tester.pumpWidget(
        createTestWidget(),
      );

      await tester.tap(
        find.text('Delete'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Delete Employee'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('Cancel'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Delete Employee'),
        findsNothing,
      );

      verifyNever(
        () => mockEmployeeCubit.deleteEmployee(any()),
      );
    },
  );

  testWidgets(
    'Delete button in dialog should delete employee with correct ID',
    (tester) async {
      await tester.pumpWidget(
        createTestWidget(),
      );

      // Open confirmation dialog.
      await tester.tap(
        find.text('Delete'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Delete Employee'),
        findsOneWidget,
      );

      // Tap Delete inside the dialog.
      final deleteButtons = find.text('Delete');

      expect(
        deleteButtons,
        findsNWidgets(2),
      );

      await tester.tap(
        deleteButtons.last,
      );

      await tester.pumpAndSettle();

      verify(
        () => mockEmployeeCubit.deleteEmployee('123'),
      ).called(1);

      expect(
        find.text('Delete Employee'),
        findsNothing,
      );
    },
  );
}