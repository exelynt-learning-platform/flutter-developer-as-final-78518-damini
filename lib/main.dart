import 'package:flutter/material.dart';
import 'package:flutter_developer_as_final_78518_damini/core/theme/app_theme.dart';
import 'package:flutter_developer_as_final_78518_damini/core/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId: '636624887085-ukmru3695a771ne9v6esjn0m7ls82o3c.apps.googleusercontent.com'
  );

   final authRepository = AuthRepository();
   
   runApp(BlocProvider(
      create: (context) => AuthCubit(authRepository)..checkAuthState(),
      child: const EmployeeManagementApp(),
    ));

}

class EmployeeManagementApp extends StatefulWidget {
  const EmployeeManagementApp({super.key});

  @override
  State<EmployeeManagementApp> createState() => _EmployeeManagementAppState();
}

class _EmployeeManagementAppState extends State<EmployeeManagementApp> {

  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = await ThemeService.getIsDarkMode();

    if (!mounted) return;

    setState(() {
      _themeMode =
          isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final isDarkMode = _themeMode == ThemeMode.dark;

    final newIsDarkMode = !isDarkMode;

    setState(() {
      _themeMode =
          newIsDarkMode ? ThemeMode.dark : ThemeMode.light;
    });

    await ThemeService.saveTheme(newIsDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeMode == ThemeMode.dark;
    
    return MaterialApp(
      title: 'Employee Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: AuthWrapper(
        onThemeToggle: _toggleTheme,
        isDarkMode: isDarkMode,
      ),
    );
  }
}