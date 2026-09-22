import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/employee_cubit.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/model/employee_model.dart';
import '../cubit/employee_state.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeeScreen({
    super.key,
    this.employee,
  });

  bool get isEdit => employee != null;

  @override
  State<AddEditEmployeeScreen> createState() =>
      _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState
    extends State<AddEditEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController districtController;

  @override
  void initState() {
    super.initState();

    final employee = widget.employee;

    nameController = TextEditingController(
      text: employee?.name ?? '',
    );

    emailController = TextEditingController(
      text: employee?.emailId ?? '',
    );

    mobileController = TextEditingController(
      text: employee?.mobile ?? '',
    );

    countryController = TextEditingController(
      text: employee?.country ?? '',
    );

    stateController = TextEditingController(
      text: employee?.state ?? '',
    );

    districtController = TextEditingController(
      text: employee?.district ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    countryController.dispose();
    stateController.dispose();
    districtController.dispose();

    super.dispose();
  }

  void saveEmployee() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final employee = Employee(
      id: widget.employee?.id,
      name: nameController.text.trim(),
      emailId: emailController.text.trim(),
      mobile: mobileController.text.trim(),
      country: countryController.text.trim(),
      state: stateController.text.trim(),
      district: districtController.text.trim(),
    );

    if (widget.isEdit) {
      context.read<EmployeeCubit>().updateEmployee(employee.id!, employee);
    } else {
      context.read<EmployeeCubit>().addEmployee(employee);
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoaded) {
          Navigator.pop(context);
        }

        if (state is EmployeeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEdit
                ? 'Edit Employee'
                : 'Add Employee',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                buildTextField(
                  label: 'Name',
                  controller: nameController,
                ),

                buildTextField(
                  label: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                buildTextField(
                  label: 'Mobile',
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                ),

                buildTextField(
                  label: 'Country',
                  controller: countryController,
                ),

                buildTextField(
                  label: 'State',
                  controller: stateController,
                ),

                buildTextField(
                  label: 'District',
                  controller: districtController,
                ),

                const SizedBox(height: 10),

                BlocBuilder<EmployeeCubit, EmployeeState>(
                  builder: (context, state) {
                    final loading =
                        state is EmployeeActionLoading;

                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            loading ? null : saveEmployee,
                        child: loading
                            ? const CircularProgressIndicator()
                            : Text(
                                widget.isEdit
                                    ? 'Update Employee'
                                    : 'Add Employee',
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}