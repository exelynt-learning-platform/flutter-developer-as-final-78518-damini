import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/add_edit_employee_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/country_repository.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/employee_repository.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/country_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/country_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';

class MockEmployeeRepository extends Mock
    implements EmployeeRepository {}

class MockCountryRepository extends Mock
    implements CountryRepository {}

class FakeEmployee extends Fake implements Employee {}

void main() {
  late MockEmployeeRepository mockEmployeeRepository;
  late MockCountryRepository mockCountryRepository;

   final employee1 = Employee(
    id: '1',
    name: 'John Doe',
    emailId: 'john@example.com',
    mobile: '9876543210',
    country: 'India',
    state: 'Maharashtra',
    district: 'Pune',
  );

  final countries = [
    CountryModel(
      id: '1',
      country: 'India',
      flag: '🇮🇳',
    ),
    CountryModel(
      id: '2',
      country: 'USA',
      flag: '🇺🇸',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeEmployee());
  });

  setUp(() {
    mockEmployeeRepository = MockEmployeeRepository();
    mockCountryRepository = MockCountryRepository();

    when(
      () => mockCountryRepository.getCountries(),
    ).thenAnswer(
      (_) async => countries,
    );
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<EmployeeCubit>(
            create: (_) =>
                EmployeeCubit(mockEmployeeRepository),
          ),
          BlocProvider<CountryCubit>(
            create: (_) =>
                CountryCubit(mockCountryRepository),
          ),
        ],
        child: AddEditEmployeeScreen(),
      ),
    );
  }

  testWidgets(
    'Add Employee screen should display all form fields',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final countryCubit =
          tester.element(find.byType(AddEditEmployeeScreen))
              .read<CountryCubit>();

      countryCubit.emit(CountryLoaded(countries));

      await tester.pump();

      expect(find.text('Add Employee'), findsWidgets);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('State'), findsOneWidget);
      expect(find.text('District'), findsOneWidget);

      expect(
        find.widgetWithText(ElevatedButton, 'Add Employee'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Add Employee form should show validation errors when fields are empty',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final countryCubit =
          tester.element(find.byType(AddEditEmployeeScreen))
              .read<CountryCubit>();

      countryCubit.emit(CountryLoaded(countries));

      await tester.pump();

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Add Employee',
        ),
      );

      await tester.pump();

      expect(
        find.text('Name is required'),
        findsOneWidget,
      );

      expect(
        find.text('Email is required'),
        findsOneWidget,
      );

      expect(
        find.text('Mobile is required'),
        findsOneWidget,
      );

      expect(
        find.text('Country is required'),
        findsOneWidget,
      );

      expect(
        find.text('State is required'),
        findsOneWidget,
      );

      expect(
        find.text('District is required'),
        findsOneWidget,
      );

      verifyNever(
        () => mockEmployeeRepository.addEmployee(any()),
      );
    },
  );

  testWidgets(
    'Add Employee form should accept valid values',
    (tester) async {
      when(
        () => mockEmployeeRepository.addEmployee(any()),
      ).thenAnswer(
        (_) async {return employee1;},
      );

      when(
        () => mockEmployeeRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [],
      );

      await tester.pumpWidget(createTestWidget());

      final countryCubit =
          tester.element(find.byType(AddEditEmployeeScreen))
              .read<CountryCubit>();

      countryCubit.emit(CountryLoaded(countries));

      await tester.pump();

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Name',
        ),
        'John Doe',
      );

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Email',
        ),
        'john@example.com',
      );

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Mobile',
        ),
        '9876543210',
      );

      await tester.tap(
        find.text('Select Country'),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text('India').last,
      );

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'State',
        ),
        'Maharashtra',
      );

      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'District',
        ),
        'Pune',
      );

      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          'Add Employee',
        ),
      );

      await tester.pumpAndSettle();

      verify(
        () => mockEmployeeRepository.addEmployee(any()),
      ).called(1);

      verify(
        () => mockEmployeeRepository.getEmployees(),
      ).called(1);
    },
  );

  testWidgets(
    'Edit Employee screen should pre-populate existing employee data',
    (tester) async {
      final employee = Employee(
        id: '1',
        name: 'John Doe',
        emailId: 'john@example.com',
        mobile: '9876543210',
        country: 'India',
        state: 'Maharashtra',
        district: 'Pune',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<EmployeeCubit>(
                create: (_) =>
                    EmployeeCubit(mockEmployeeRepository),
              ),
              BlocProvider<CountryCubit>(
                create: (_) =>
                    CountryCubit(mockCountryRepository),
              ),
            ],
            child: AddEditEmployeeScreen(
              employee: employee,
            ),
          ),
        ),
      );

      final countryCubit =
          tester.element(find.byType(AddEditEmployeeScreen))
              .read<CountryCubit>();

      countryCubit.emit(CountryLoaded(countries));

      await tester.pump();

      expect(
        find.text('Edit Employee'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          ElevatedButton,
          'Update Employee',
        ),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(
          TextFormField,
          'Name',
        ),
        findsOneWidget,
      );

      final nameField = tester.widget<TextFormField>(
        find.byType(TextFormField).first,
      );

      expect(
        nameField.controller?.text,
        'John Doe',
      );
    },
  );
}