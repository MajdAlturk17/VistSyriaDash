import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_bloc.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_event.dart';
import 'package:visitsyriadashboard/Core/Bloc/bloc/login_bloc_state.dart';
import 'package:visitsyriadashboard/Core/Service/LoginService.dart';
import 'package:visitsyriadashboard/Features/Auth/Screen/HomePage/HomePage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController(
    text: "0996183111",
  );
  TextEditingController PasswordController = TextEditingController(
    text: "MyStrongP@ssw0rd",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginService()),
      child: Scaffold(
        backgroundColor: AppColors.grey,
        body: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Successful!')),
                  );
                  // Navigate to dashboard, e.g.:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                } else if (state is LoginFailure) {
                  print(state.error);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: AppColors.darkBlue,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Admin Login",
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      cursorColor: AppColors.gold,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: AppColors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.darkBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: PasswordController,
                      cursorColor: AppColors.gold,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: AppColors.grey.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.darkBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading
                            ? null
                            : () {
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    email: emailController.text.trim(),
                                    password: PasswordController.text.trim(),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is LoginLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
