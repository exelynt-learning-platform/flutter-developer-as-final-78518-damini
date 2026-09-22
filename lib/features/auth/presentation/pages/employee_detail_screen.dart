import 'package:flutter/material.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(
              'Name',
              employee.name,
            ),

            _buildDetailItem(
              'Email',
              employee.emailId,
            ),

            _buildDetailItem(
              'Mobile',
              employee.mobile,
            ),

            _buildDetailItem(
              'Country',
              employee.country,
            ),

            _buildDetailItem(
              'State',
              employee.state,
            ),

            _buildDetailItem(
              'District',
              employee.district,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}