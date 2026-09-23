import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/employee_dashboard_page.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_state.dart';

class MockEmployeeCubit extends Mock implements EmployeeCubit {}

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockEmployeeCubit mockEmployeeCubit;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockEmployeeCubit = MockEmployeeCubit();
    mockAuthCubit = MockAuthCubit();

    when(() => mockEmployeeCubit.state)
        .thenReturn(EmployeeInitial());

    when(() => mockEmployeeCubit.stream)
      .thenAnswer((_) => Stream.value(EmployeeInitial()));

    when(() => mockAuthCubit.state)
        .thenReturn(AuthUnauthenticated());

    when(() => mockAuthCubit.stream)
      .thenAnswer((_) => Stream.value(AuthUnauthenticated()));
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
    'Dashboard should display main UI elements',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Employees'), findsOneWidget);
      expect(find.text('Search by Employee ID'), findsOneWidget);
      expect(find.text('Enter employee ID'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.text('Add Employee'), findsOneWidget);
      expect(find.byTooltip('Logout'), findsOneWidget);
    },
  );

  testWidgets(
    'Dashboard should display loading indicator',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoading());

      await tester.pumpWidget(createTestWidget());

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Dashboard should display error message',
    (tester) async {
      when(() => mockEmployeeCubit.state).thenReturn(
        EmployeeError('Unable to load employees.'),
      );

      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Unable to load employees.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Dashboard should display empty state when no employees are found',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoaded([]));

      when(() => mockEmployeeCubit.loadEmployees())
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('No employees found.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Search field should call EmployeeCubit searchEmployees',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoaded([]));

      when(() => mockEmployeeCubit.searchEmployees(any()))
          .thenReturn(null);

      await tester.pumpWidget(createTestWidget());

      final searchField = find.byType(TextField);

      await tester.enterText(
        searchField,
        '123',
      );

      verify(
        () => mockEmployeeCubit.searchEmployees('123'),
      ).called(1);
    },
  );

  testWidgets(
    'Clear button should clear search and reset employees',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoaded([]));

      when(() => mockEmployeeCubit.clearFilters())
          .thenReturn(null);

      await tester.pumpWidget(createTestWidget());

      final searchField = find.byType(TextField);

      await tester.enterText(
        searchField,
        '123',
      );

      await tester.tap(
        find.byIcon(Icons.clear),
      );

      await tester.pump();

      verify(
        () => mockEmployeeCubit.clearFilters(),
      ).called(1);
    },
  );

  testWidgets(
    'Logout button should call AuthCubit logout',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoaded([]));

      when(() => mockAuthCubit.logout())
          .thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.byTooltip('Logout'),
      );

      await tester.pump();

      verify(
        () => mockAuthCubit.logout(),
      ).called(1);
    },
  );

  testWidgets(
    'Theme toggle button should call onThemeToggle',
    (tester) async {
      when(() => mockEmployeeCubit.state)
          .thenReturn(EmployeeLoaded([]));

      var themeToggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
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
              onThemeToggle: () {
                themeToggleCalled = true;
              },
              isDarkMode: false,
            ),
          ),
        ),
      );

      await tester.tap(
        find.byIcon(Icons.dark_mode),
      );

      await tester.pump();

      expect(themeToggleCalled, true);
    },
  );


testWidgets(
  'RefreshIndicator should call loadEmployees',
  (tester) async {
    when(() => mockEmployeeCubit.state)
        .thenReturn(EmployeeLoaded([]));

    when(() => mockEmployeeCubit.loadEmployees())
        .thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget());

    final refreshIndicator = find.byType(RefreshIndicator);

    expect(
      refreshIndicator,
      findsOneWidget,
    );

    final widget = tester.widget<RefreshIndicator>(
      refreshIndicator,
    );

    await widget.onRefresh();

    verify(
      () => mockEmployeeCubit.loadEmployees(),
    ).called(1);
  },
);


}