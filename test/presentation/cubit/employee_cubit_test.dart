import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/employee_repository.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_state.dart';

class MockEmployeeRepository extends Mock
implements EmployeeRepository {}

class FakeEmployee extends Fake implements Employee {}

void main() {
  late MockEmployeeRepository mockRepository;
  late EmployeeCubit employeeCubit;

  final employee1 = Employee(
    id: '1',
    name: 'John Doe',
    emailId: 'john@example.com',
    mobile: '9876543210',
    country: 'India',
    state: 'Maharashtra',
    district: 'Pune',
  );

  final employee2 = Employee(
    id: '2',
    name: 'Jane Smith',
    emailId: 'jane@example.com',
    mobile: '9123456780',
    country: 'USA',
    state: 'California',
    district: 'Los Angeles',
  );

  setUpAll(() {
    registerFallbackValue(FakeEmployee());
  });

  setUp(() {
    mockRepository = MockEmployeeRepository();
    employeeCubit = EmployeeCubit(mockRepository);
  });

  tearDown(() {
    employeeCubit.close();
  });

  test('initial state should be EmployeeInitial', () {
    expect(employeeCubit.state, isA<EmployeeInitial>());
  });

  test(
    'loadEmployees should emit loading and loaded state',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      final states = <EmployeeState>[];

      final subscription = employeeCubit.stream.listen(states.add);

      await employeeCubit.loadEmployees();

      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<EmployeeLoading>());

      expect(states[1], isA<EmployeeLoaded>());

      final loadedState = states[1] as EmployeeLoaded;

      expect(loadedState.employees.length, 2);
      expect(loadedState.employees[0].name, 'John Doe');
      expect(loadedState.employees[1].name, 'Jane Smith');

      verify(
        () => mockRepository.getEmployees(),
      ).called(1);

      await subscription.cancel();
    },
  );

  test(
    'loadEmployees should emit error when repository fails',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenThrow(Exception('API error'));

      final states = <EmployeeState>[];

      final subscription = employeeCubit.stream.listen(states.add);

      await employeeCubit.loadEmployees();

      await Future<void>.delayed(Duration.zero);

      expect(states.length, 2);
      expect(states[0], isA<EmployeeLoading>());
      expect(states[1], isA<EmployeeError>());

      final errorState = states[1] as EmployeeError;

      expect(
        errorState.message,
        'Unable to load employees. Please try again.',
      );

      await subscription.cancel();
    },
  );

  test(
    'searchEmployees should filter employees by ID',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.searchEmployees('1');

      expect(employeeCubit.state, isA<EmployeeLoaded>());

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(state.employees.first.id, '1');
    },
  );

  test(
    'searchEmployees should return all employees when query is empty',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.searchEmployees('');

      expect(employeeCubit.state, isA<EmployeeLoaded>());

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 2);
    },
  );

  test(
    'filterEmployees should filter by name',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.filterEmployees(
        name: 'John',
      );

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(state.employees.first.name, 'John Doe');
    },
  );

  test(
    'filterEmployees should filter by exact email',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.filterEmployees(
        email: 'john@example.com',
      );

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(
        state.employees.first.emailId,
        'john@example.com',
      );
    },
  );

  test(
    'filterEmployees should filter by mobile',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.filterEmployees(
        mobile: '9876543210',
      );

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(
        state.employees.first.mobile,
        '9876543210',
      );
    },
  );

  test(
    'filterEmployees should filter by country',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.filterEmployees(
        country: 'India',
      );

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(
        state.employees.first.country,
        'India',
      );
    },
  );

  test(
    'clearFilters should return all employees',
    () async {
      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.loadEmployees();

      employeeCubit.filterEmployees(
        country: 'India',
      );

      employeeCubit.clearFilters();

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 2);
    },
  );

  test(
    'addEmployee should call repository and reload employees',
    () async {
      when(
        () => mockRepository.addEmployee(any()),
      ).thenAnswer((_) async {return employee1;});

      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.addEmployee(employee1);

      verify(
        () => mockRepository.addEmployee(employee1),
      ).called(1);

      verify(
        () => mockRepository.getEmployees(),
      ).called(1);

      expect(employeeCubit.state, isA<EmployeeLoaded>());

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 2);
    },
  );

  test(
    'updateEmployee should call repository and reload employees',
    () async {
      when(
        () => mockRepository.updateEmployee(
          any(),
          any(),
        ),
      ).thenAnswer((_) async {return employee1;});

      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee1, employee2],
      );

      await employeeCubit.updateEmployee(
        '1',
        employee1,
      );

      verify(
        () => mockRepository.updateEmployee(
          '1',
          employee1,
        ),
      ).called(1);

      verify(
        () => mockRepository.getEmployees(),
      ).called(1);

      expect(employeeCubit.state, isA<EmployeeLoaded>());
    },
  );

  test(
    'deleteEmployee should call repository and reload employees',
    () async {
      when(
        () => mockRepository.deleteEmployee(any()),
      ).thenAnswer((_) async {});

      when(
        () => mockRepository.getEmployees(),
      ).thenAnswer(
        (_) async => [employee2],
      );

      await employeeCubit.deleteEmployee('1');

      verify(
        () => mockRepository.deleteEmployee('1'),
      ).called(1);

      verify(
        () => mockRepository.getEmployees(),
      ).called(1);

      expect(employeeCubit.state, isA<EmployeeLoaded>());

      final state =
          employeeCubit.state as EmployeeLoaded;

      expect(state.employees.length, 1);
      expect(state.employees.first.id, '2');
    },
  );

  test(
    'addEmployee should emit error when repository fails',
    () async {
      when(
        () => mockRepository.addEmployee(any()),
      ).thenThrow(Exception('API error'));

      await employeeCubit.addEmployee(employee1);

      expect(employeeCubit.state, isA<EmployeeError>());

      final state =
          employeeCubit.state as EmployeeError;

      expect(
        state.message,
        'Unable to add employee. Please try again.',
      );
    },
  );

  test(
    'updateEmployee should emit error when repository fails',
    () async {
      when(
        () => mockRepository.updateEmployee(
          any(),
          any(),
        ),
      ).thenThrow(Exception('API error'));

      await employeeCubit.updateEmployee(
        '1',
        employee1,
      );

      expect(employeeCubit.state, isA<EmployeeError>());

      final state =
          employeeCubit.state as EmployeeError;

      expect(
        state.message,
        'Unable to update employee. Please try again.',
      );
    },
  );

  test(
    'deleteEmployee should emit error when repository fails',
    () async {
      when(
        () => mockRepository.deleteEmployee(any()),
      ).thenThrow(Exception('API error'));

      await employeeCubit.deleteEmployee('1');

      expect(employeeCubit.state, isA<EmployeeError>());

      final state =
          employeeCubit.state as EmployeeError;

      expect(
        state.message,
        'Unable to delete employee. Please try again.',
      );
    },
  );
}