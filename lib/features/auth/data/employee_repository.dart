import 'dart:convert';

import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_constants.dart';

class EmployeeRepository {
  final http.Client client;

  EmployeeRepository({
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<List<Employee>> getEmployees() async {
    final response = await client.get(
      Uri.parse(AppConstants.employeeApi),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map(
            (json) => Employee.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw Exception(
      'Failed to load employees',
    );
  }

  Future<Employee> getEmployeeById(String id) async {
    final response = await client.get(
      Uri.parse(
        '${AppConstants.employeeApi}/$id',
      ),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to load employee',
    );
  }

  Future<Employee> addEmployee(Employee employee) async {
    final response = await client.post(
      Uri.parse(AppConstants.employeeApi),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return Employee.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to add employee',
    );
  }

  Future<Employee> updateEmployee(
    String id,
    Employee employee,
  ) async {
    final response = await client.put(
      Uri.parse(
        '${AppConstants.employeeApi}/$id',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update employee',
    );
  }

  Future<void> deleteEmployee(String id) async {
    final response = await client.delete(
      Uri.parse(
        '${AppConstants.employeeApi}/$id',
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw Exception(
        'Failed to delete employee',
      );
    }
  }
}