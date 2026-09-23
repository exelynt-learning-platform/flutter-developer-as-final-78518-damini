import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/employee_detail_screen.dart';

void main() {
  Employee createEmployee({
    String name = 'John Doe',
    String email = 'john@example.com',
    String mobile = '9876543210',
    String country = 'India',
    String state = 'Maharashtra',
    String district = 'Pune',
  }) {
    return Employee(
      id: '1',
      name: name,
      emailId: email,
      mobile: mobile,
      country: country,
      state: state,
      district: district,
    );
  }

  Widget createTestWidget(Employee employee) {
    return MaterialApp(
      home: EmployeeDetailScreen(
        employee: employee,
      ),
    );
  }

  testWidgets(
    'Employee detail screen should display title and all employee details',
    (tester) async {
      final employee = createEmployee();

      await tester.pumpWidget(
        createTestWidget(employee),
      );

      expect(
        find.text('Employee Details'),
        findsOneWidget,
      );

      expect(
        find.text('Name'),
        findsOneWidget,
      );
      expect(
        find.text('John Doe'),
        findsOneWidget,
      );

      expect(
        find.text('Email'),
        findsOneWidget,
      );
      expect(
        find.text('john@example.com'),
        findsOneWidget,
      );

      expect(
        find.text('Mobile'),
        findsOneWidget,
      );
      expect(
        find.text('9876543210'),
        findsOneWidget,
      );

      expect(
        find.text('Country'),
        findsOneWidget,
      );
      expect(
        find.text('India'),
        findsOneWidget,
      );

      expect(
        find.text('State'),
        findsOneWidget,
      );
      expect(
        find.text('Maharashtra'),
        findsOneWidget,
      );

      expect(
        find.text('District'),
        findsOneWidget,
      );
      expect(
        find.text('Pune'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Employee detail screen should display dash for empty values',
    (tester) async {
      final employee = createEmployee(
        name: '',
        email: '',
        mobile: '',
        country: '',
        state: '',
        district: '',
      );

      await tester.pumpWidget(
        createTestWidget(employee),
      );

      expect(
        find.text('Name'),
        findsOneWidget,
      );
      expect(
        find.text('Email'),
        findsOneWidget,
      );
      expect(
        find.text('Mobile'),
        findsOneWidget,
      );
      expect(
        find.text('Country'),
        findsOneWidget,
      );
      expect(
        find.text('State'),
        findsOneWidget,
      );
      expect(
        find.text('District'),
        findsOneWidget,
      );

      // All six empty values should display '-'.
      expect(
        find.text('-'),
        findsNWidgets(6),
      );
    },
  );

  testWidgets(
    'Employee detail screen should display different employee data correctly',
    (tester) async {
      final employee = createEmployee(
        name: 'Priya Sharma',
        email: 'priya@gmail.com',
        mobile: '9123456789',
        country: 'United States',
        state: 'California',
        district: 'Los Angeles',
      );

      await tester.pumpWidget(
        createTestWidget(employee),
      );

      expect(
        find.text('Priya Sharma'),
        findsOneWidget,
      );
      expect(
        find.text('priya@gmail.com'),
        findsOneWidget,
      );
      expect(
        find.text('9123456789'),
        findsOneWidget,
      );
      expect(
        find.text('United States'),
        findsOneWidget,
      );
      expect(
        find.text('California'),
        findsOneWidget,
      );
      expect(
        find.text('Los Angeles'),
        findsOneWidget,
      );
    },
  );
}