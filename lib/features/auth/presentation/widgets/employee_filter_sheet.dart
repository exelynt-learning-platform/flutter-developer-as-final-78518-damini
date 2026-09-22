import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_78518_damini/features/auth/presentation/bloc/country_bloc.dart';

import '../cubit/employee_cubit.dart';

class EmployeeFilterSheet extends StatefulWidget {
  const EmployeeFilterSheet({super.key});

  @override
  State<EmployeeFilterSheet> createState() =>
      _EmployeeFilterSheetState();
}

class _EmployeeFilterSheetState extends State<EmployeeFilterSheet> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _countryController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    context.read<EmployeeCubit>().filterEmployees(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          mobile: _mobileController.text.trim(),
          country: _countryController.text.trim(),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context)
                .viewInsets
                .bottom +
            20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Employees',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // BlocBuilder<CountryBloc, CountryState>(
            //   builder: (context, state) {
            //     if (state is CountryLoading) {
            //       return const CircularProgressIndicator();
            //     }
            //
            //     if (state is CountryError) {
            //       return Text(state.message);
            //     }
            //
            //     if (state is CountryLoaded) {
            //       return DropdownButtonFormField<String>(
            //         decoration: const InputDecoration(
            //           labelText: 'Country',
            //           border: OutlineInputBorder(),
            //         ),
            //         items: state.countries.map((country) {
            //           return DropdownMenuItem<String>(
            //             value: country.name,
            //             child: Text(country.name),
            //           );
            //         }).toList(),
            //         onChanged: (value) {
            //           // selected country
            //         },
            //       );
            //     }
            //
            //     return const SizedBox();
            //   },
            // ),

             TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context
                          .read<EmployeeCubit>()
                          .clearFilters();

                      Navigator.pop(context);
                    },
                    child: const Text('Clear'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}