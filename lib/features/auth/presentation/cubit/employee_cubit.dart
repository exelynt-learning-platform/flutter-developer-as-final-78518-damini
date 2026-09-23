import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import '../../data/employee_repository.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository employeeRepository;

  List<Employee> _allEmployees = [];

  String _searchQuery = '';
  String _nameFilter = '';
  String _emailFilter = '';
  String _mobileFilter = '';
  String _countryFilter = '';

  EmployeeCubit(this.employeeRepository)
      : super(EmployeeInitial());

  Future<void> loadEmployees() async {
    try {
      emit(EmployeeLoading());

      final employees =
          await employeeRepository.getEmployees();

      _allEmployees = employees;

      emit(EmployeeLoaded(_allEmployees));
    } catch (e) {
      emit(
        EmployeeError(
          'Unable to load employees. Please try again.',
        ),
      );
    }
  }

  void searchEmployees(String query) {
    if (state is! EmployeeLoaded) {
      return;
    }

    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      emit(EmployeeLoaded(_allEmployees));
      return;
    }

    final filteredEmployees = _allEmployees.where((employee) {
      return employee.id
              ?.toLowerCase()
              .contains(searchQuery) ??
          false;
    }).toList();

    emit(EmployeeLoaded(filteredEmployees));
  }

  void filterEmployees({
  String? name,
  String? email,
  String? mobile,
  String? country,
}) {
  final filteredEmployees = _allEmployees.where((employee) {
    final nameQuery = name?.trim().toLowerCase() ?? '';
    final emailQuery = email?.trim().toLowerCase() ?? '';
    final mobileQuery = mobile?.trim() ?? '';
    final countryQuery = country?.trim().toLowerCase() ?? '';

    final matchesName = nameQuery.isEmpty ||
        employee.name.toLowerCase().contains(nameQuery);

    // Exact email match
    final matchesEmail = emailQuery.isEmpty ||
        employee.emailId.trim().toLowerCase() == emailQuery;

    final matchesMobile = mobileQuery.isEmpty ||
        employee.mobile.trim() == mobileQuery;

    final matchesCountry = countryQuery.isEmpty ||
        employee.country.trim().toLowerCase() ==
            countryQuery;

    return matchesName &&
        matchesEmail &&
        matchesMobile &&
        matchesCountry;
  }).toList();

  emit(EmployeeLoaded(filteredEmployees));
}

  void clearFilters() {
    emit(EmployeeLoaded(_allEmployees));
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      emit(EmployeeActionLoading());
      await employeeRepository.addEmployee(employee);
      await loadEmployees();
    } catch (e) {
      emit(
        EmployeeError(
          'Unable to add employee. Please try again.',
        ),
      );
    }
  }

  Future<void> updateEmployee(
    String id,
    Employee employee,
  ) async {
    try {
      emit(EmployeeActionLoading());
      await employeeRepository.updateEmployee(
        id,
        employee,
      );

      await loadEmployees();
    } catch (e) {
      emit(
        EmployeeError(
          'Unable to update employee. Please try again.',
        ),
      );
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      emit(EmployeeActionLoading());
      await employeeRepository.deleteEmployee(id);
      await loadEmployees();
    } catch (e) {
      emit(
        EmployeeError(
          'Unable to delete employee. Please try again.',
        ),
      );
    }
  }
}