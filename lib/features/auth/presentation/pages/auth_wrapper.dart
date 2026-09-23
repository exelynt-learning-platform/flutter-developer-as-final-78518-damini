import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/employee_dashboard_page.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/cubit/employee_cubit.dart';
import '../../../auth/data/employee_repository.dart';

class AuthWrapper extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;
  const AuthWrapper({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {

          return BlocProvider(
            create: (_) => EmployeeCubit(
              EmployeeRepository(),
            )..loadEmployees(),
            child: EmployeeDashboardPage(
              onThemeToggle: onThemeToggle,
              isDarkMode: isDarkMode,
            ),
          );
        }

        if (state is AuthUnauthenticated) {
          return const LoginPage();
        }

        if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Authentication Error: ${state.message}',
              ),
            ),
          );
        }

        return const LoginPage();
      },
    );
  }
}