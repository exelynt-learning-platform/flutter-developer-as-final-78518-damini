import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/country_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/widgets/employee_filter_sheet.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/country_model.dart';

class MockEmployeeCubit extends Mock implements EmployeeCubit {}

class MockCountryCubit extends Mock implements CountryCubit {}

void main() {
  late MockEmployeeCubit mockEmployeeCubit;
  late MockCountryCubit mockCountryCubit;

  setUp(() {
  mockEmployeeCubit = MockEmployeeCubit();
  mockCountryCubit = MockCountryCubit();

  when(() => mockEmployeeCubit.state)
      .thenReturn(EmployeeLoaded([]));

  when(() => mockEmployeeCubit.stream)
      .thenAnswer(
        (_) => Stream.value(EmployeeLoaded([])),
      );

  when(() => mockCountryCubit.state)
      .thenReturn(CountryInitial());

  when(() => mockCountryCubit.stream)
      .thenAnswer(
        (_) => Stream.value(CountryInitial()),
      );

  when(() => mockCountryCubit.state)
      .thenReturn(
        CountryLoaded([
          CountryModel(
            id: '1',
            country: 'India',
            flag: '',
          ),
          CountryModel(
            id: '2',
            country: 'United States',
            flag: '',
          ),
        ]),
      );

  when(() => mockCountryCubit.stream)
      .thenAnswer(
        (_) => const Stream<CountryState>.empty(),
      );

  when(
    () => mockEmployeeCubit.filterEmployees(
      name: any(named: 'name'),
      email: any(named: 'email'),
      mobile: any(named: 'mobile'),
      country: any(named: 'country'),
    ),
  ).thenReturn(null);

  when(() => mockEmployeeCubit.clearFilters())
      .thenReturn(null);
});

  tearDown(() {
    reset(mockEmployeeCubit);
    reset(mockCountryCubit);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeCubit>.value(
            value: mockEmployeeCubit,
          ),
          BlocProvider<CountryCubit>.value(
            value: mockCountryCubit,
          ),
        ],
        child: const Scaffold(
          body: EmployeeFilterSheet(),
        ),
      ),
    );
  }

  testWidgets(
    'Filter sheet should display all filter fields',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Filter Employees'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(TextField, 'Name'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(TextField, 'Email'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(TextField, 'Mobile'),
        findsOneWidget,
      );

      expect(
        find.text('Country'),
        findsOneWidget,
      );

      expect(
        find.text('Select Country'),
        findsOneWidget,
      );

      expect(
        find.text('Clear'),
        findsOneWidget,
      );

      expect(
        find.text('Apply'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Apply should call filterEmployees with entered values',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextField);

      await tester.enterText(
        textFields.at(0),
        'John',
      );

      await tester.enterText(
        textFields.at(1),
        'john@example.com',
      );

      await tester.enterText(
        textFields.at(2),
        '9876543210',
      );

      // Open country dropdown.
      await tester.tap(
        find.text('Select Country'),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('India').last,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('Apply'),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockEmployeeCubit.filterEmployees(
          name: 'John',
          email: 'john@example.com',
          mobile: '9876543210',
          country: 'India',
        ),
      ).called(1);
    },
  );

  testWidgets(
    'Apply should pass empty values when no filters are entered',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Apply'),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockEmployeeCubit.filterEmployees(
          name: '',
          email: '',
          mobile: '',
          country: '',
        ),
      ).called(1);
    },
  );

  testWidgets(
    'Clear should call clearFilters',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Clear'),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockEmployeeCubit.clearFilters(),
      ).called(1);
    },
  );

  testWidgets(
    'Country dropdown should display available countries',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Select Country'),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('India'),
        findsOneWidget,
      );

      expect(
        find.text('United States'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Country dropdown should update selected country',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(
        find.text('Select Country'),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('India').last,
      );

      await tester.pumpAndSettle();

      expect(
        find.text('India'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Country loading state should display loading indicator',
    (tester) async {
      when(() => mockCountryCubit.state)
          .thenReturn(CountryLoading());

      await tester.pumpWidget(createTestWidget());

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Country error state should display error message',
    (tester) async {
      when(() => mockCountryCubit.state)
          .thenReturn(
            CountryError('Unable to load countries'),
          );

      await tester.pumpWidget(createTestWidget());

      expect(
        find.text('Unable to load countries'),
        findsOneWidget,
      );
    },
  );
}