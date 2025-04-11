import 'package:flutter/material.dart';
import '../authentication/forgot_password_screen.dart';
import 'custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final Function() onSubmit;
  final Function() onToggleAuth;

  const LoginScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onToggleAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          data: Icons.email,
          controller: emailController,
          hintText: 'Email',
          isObscure: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.lock,
          controller: passwordController,
          hintText: 'Password',
          isObscure: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Login'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onToggleAuth,
          child: const Text(
            'Don\'t have an account? Register',
            style: TextStyle(color: Colors.amber),
          ),
        ),
        // const SizedBox(height: 16),
        // TextButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => const ForgotPasswordScreen()),
        //     );
        //   },
        //   child: const Text(
        //     'Forgot password? Reset here',
        //     style: TextStyle(color: Colors.amber),
        //   ),
        // ),
      ],
    );
  }
}
