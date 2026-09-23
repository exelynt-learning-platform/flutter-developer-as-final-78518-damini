import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
void main() {
  test('Employee should create correctly from JSON', () {
    final json = {
      'id': '1',
      'name': 'John Doe',
      'emailId': 'john@example.com',
      'mobile': '9876543210',
      'country': 'India',
      'state': 'Maharashtra',
      'district': 'Pune',
    };

    final employee = Employee.fromJson(json);

    expect(employee.id, '1');
    expect(employee.name, 'John Doe');
    expect(employee.emailId, 'john@example.com');
    expect(employee.mobile, '9876543210');
    expect(employee.country, 'India');
    expect(employee.state, 'Maharashtra');
    expect(employee.district, 'Pune');
  });
}