import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/widgets/employee_card.dart';

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

  Widget createTestWidget({
    required Employee employee,
    VoidCallback? onView,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: EmployeeCard(
          employee: employee,
          onView: onView,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
      ),
    );
  }

  testWidgets(
    'Employee card should display employee information',
    (tester) async {
      final employee = createEmployee();

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);

      expect(
        find.text('Mobile: 9876543210'),
        findsOneWidget,
      );

      expect(
        find.text('Country: India'),
        findsOneWidget,
      );

      expect(
        find.text('State: Maharashtra'),
        findsOneWidget,
      );

      expect(
        find.text('District: Pune'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Employee card should display first letter of employee name',
    (tester) async {
      final employee = createEmployee(
        name: 'John Doe',
      );

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
        ),
      );

      expect(
        find.text('J'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Employee card should call onView when View is tapped',
    (tester) async {
      var viewCalled = false;

      final employee = createEmployee();

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
          onView: () {
            viewCalled = true;
          },
        ),
      );

      await tester.tap(
        find.text('View'),
      );

      await tester.pump();

      expect(viewCalled, true);
    },
  );

  testWidgets(
    'Employee card should call onEdit when Edit is tapped',
    (tester) async {
      var editCalled = false;

      final employee = createEmployee();

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
          onEdit: () {
            editCalled = true;
          },
        ),
      );

      await tester.tap(
        find.text('Edit'),
      );

      await tester.pump();

      expect(editCalled, true);
    },
  );

  testWidgets(
    'Employee card should call onDelete when Delete is tapped',
    (tester) async {
      var deleteCalled = false;

      final employee = createEmployee();

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
          onDelete: () {
            deleteCalled = true;
          },
        ),
      );

      await tester.tap(
        find.text('Delete'),
      );

      await tester.pump();

      expect(deleteCalled, true);
    },
  );

  testWidgets(
    'Employee card should display question mark when employee name is empty',
    (tester) async {
      final employee = createEmployee(
        name: '',
      );

      await tester.pumpWidget(
        createTestWidget(
          employee: employee,
        ),
      );

      expect(
        find.text('?'),
        findsOneWidget,
      );
    },
  );
}