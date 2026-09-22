import 'package:flutter/material.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    employee.name.isNotEmpty
                        ? employee.name[0].toUpperCase()
                        : '?',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(employee.emailId),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text('Mobile: ${employee.mobile}'),
            Text('Country: ${employee.country}'),
            Text('State: ${employee.state}'),
            Text('District: ${employee.district}'),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onView,
                  child: const Text('View'),
                ),
                TextButton(
                  onPressed: onEdit,
                  child: const Text('Edit'),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}