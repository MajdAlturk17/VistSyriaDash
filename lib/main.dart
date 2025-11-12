import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_bloc.dart';
import 'package:visitsyriadashboard/Core/Service/LoginService.dart';

import 'package:visitsyriadashboard/Features/Auth/Screen/LogInPage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(LoginService()),
        ),
      ],
      child: MaterialApp(
        title: "VisitSyria Dashboard",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.darkBlue,
          scaffoldBackgroundColor: AppColors.grey,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.darkBlue,
            secondary: AppColors.gold,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.grey.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2, color: AppColors.darkBlue),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        home:  LoginPage(),
      ),
    );
  }
}
