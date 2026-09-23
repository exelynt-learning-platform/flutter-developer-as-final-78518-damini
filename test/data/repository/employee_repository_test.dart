import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/data/employee_repository.dart';
import '../../../lib/features/auth/model/employee_model.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late EmployeeRepository repository;

  setUpAll(() {
    registerFallbackValue(Uri());
  });
  
  setUp(() {
    mockClient = MockHttpClient();
    repository = EmployeeRepository(client: mockClient);
  });

  test('getEmployees should return employees when API succeeds', () async {
    final response = http.Response(
      jsonEncode([
        {
          'id': '1',
          'name': 'John Doe',
          'emailId': 'john@example.com',
          'mobile': '9876543210',
          'country': 'India',
          'state': 'Maharashtra',
          'district': 'Pune',
        },
      ]),
      200,
    );

    when(
      () => mockClient.get(any()),
    ).thenAnswer((_) async => response);

    final employees = await repository.getEmployees();

    expect(employees.length, 1);
    expect(employees.first.id, '1');
    expect(employees.first.name, 'John Doe');

    verify(
      () => mockClient.get(any()),
    ).called(1);
  });

  test('getEmployees should throw exception when API fails', () async {
    final response = http.Response(
      'Server Error',
      500,
    );

    when(
      () => mockClient.get(any()),
    ).thenAnswer((_) async => response);

    expect(
      () => repository.getEmployees(),
      throwsException,
    );
  });
}