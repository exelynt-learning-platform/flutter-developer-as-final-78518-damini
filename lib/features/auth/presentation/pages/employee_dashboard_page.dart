import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubit/employee_cubit.dart';
import '../cubit/employee_state.dart';
import '../../../auth/data/employee_repository.dart';
import 'employee_dashboard_view.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_filter_sheet.dart';
import 'add_edit_employee_screen.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import 'employee_detail_screen.dart';
import '../cubit/country_cubit.dart';
import '../../../auth/data/country_repository.dart';
import 'package:http/http.dart' as http;


class EmployeeDashboardPage extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;
  const EmployeeDashboardPage({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<EmployeeDashboardPage> createState() =>
      _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  final _searchController = TextEditingController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchById(String value) {
    context.read<EmployeeCubit>().searchEmployees(value);
  }

  void _showFilters() {
  final employeeCubit = context.read<EmployeeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: employeeCubit,
                  ),
                  BlocProvider(
                    create: (_) => CountryCubit(
                      CountryRepository(http.Client()),
                    )..getCountries(),
                  ),
                ],
                child: const EmployeeFilterSheet(),
              );
        // return BlocProvider.value(
        //   value: employeeCubit,
        //   child: const EmployeeFilterSheet(),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState =
        context.watch<AuthCubit>().state;

    User? user;

    if (authState is AuthAuthenticated) {
      user = authState.user;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final employeeCubit = context.read<EmployeeCubit>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: employeeCubit,
                  ),
                  BlocProvider(
                    create: (_) => CountryCubit(
                      CountryRepository(http.Client()),
                    )..getCountries(),
                  ),
                ],
                child: const AddEditEmployeeScreen(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Employee'),
      ),

      body: Column(
        children: [
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

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchById,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Search by Employee ID',
                      hintText: 'Enter employee ID',
                      prefixIcon:
                          const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();

                          context
                              .read<EmployeeCubit>()
                              .clearFilters();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filters',
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<EmployeeCubit,
                EmployeeState>(
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
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () {
                        return context
                            .read<EmployeeCubit>()
                            .loadEmployees();
                      },
                      child: ListView(
                        children: const [
                          SizedBox(height: 200),
                          Center(
                            child: Text(
                              'No employees found.',
                            ),
                          ),
                        ],
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
                      padding: const EdgeInsets.only(
                        bottom: 80,
                      ),
                      itemCount:
                          state.employees.length,
                      itemBuilder: (context, index) {
                        final employee =
                            state.employees[index];

                        return EmployeeCard(
                          employee: employee,
                          onView: () {
                            // View screen next.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeDetailScreen(
                                  employee: employee,
                                ),
                              ),
                            );
                          },
                          onEdit: () {
                             final employeeCubit = context.read<EmployeeCubit>();
            
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: employeeCubit,
                                    ),
                                    BlocProvider(
                                      create: (_) => CountryCubit(
                                        CountryRepository(http.Client()),
                                      )..getCountries(),
                                    ),
                                  ],
                                  child: AddEditEmployeeScreen(employee: employee),
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                           showDeleteConfirmation(
                            context,
                            employee,
                          );
                          },
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

  
  void showDeleteConfirmation(
  BuildContext context,
  Employee employee,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Employee'),
        content: Text(
          'Are you sure you want to delete ${employee.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              if (employee.id != null) {
                context
                    .read<EmployeeCubit>()
                    .deleteEmployee(employee.id!);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
}