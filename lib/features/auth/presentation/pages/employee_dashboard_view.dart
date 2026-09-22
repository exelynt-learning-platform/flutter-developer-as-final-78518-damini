import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_state.dart';

class EmployeeDashboardView extends StatelessWidget {
  const EmployeeDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    User? user;

    if (authState is AuthAuthenticated) {
      user = authState.user;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Logged-in user
          if (user != null)
            ListTile(
              leading: user!.photoURL != null
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(user!.photoURL!),
                    )
                  : const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
              title: Text(
                user!.displayName ?? 'User',
              ),
              subtitle: Text(
                user!.email ?? '',
              ),
            ),

          const Divider(),

          Expanded(
            child: BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is EmployeeError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is EmployeeLoaded) {
                  if (state.employees.isEmpty) {
                    return const Center(
                      child: Text(
                        'No employees found.',
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return context
                          .read<EmployeeCubit>()
                          .loadEmployees();
                    },
                    child: ListView.builder(
                      itemCount: state.employees.length,
                      itemBuilder: (context, index) {
                        final employee = state.employees[index];

                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              employee.name.isNotEmpty
                                  ? employee.name[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(employee.name),
                          subtitle: Text(employee.emailId),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}