import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final bool isLoading;
  final String? imageUrl;
  final Function() onPickImage;
  final Function() onPickLocation;
  final Function() onSubmit;
  final Function() onToggleAuth;

  const RegisterScreen({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.addressController,
    required this.isLoading,
    required this.imageUrl,
    required this.onPickImage,
    required this.onPickLocation,
    required this.onSubmit,
    required this.onToggleAuth,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  // Remove this line as we should use the controller from widget
  // TextEditingController confirmPasswordController = TextEditingController();
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    // Remove this line since we don't own this controller anymore
    // confirmPasswordController.dispose();
    super.dispose();
  }

  bool validatePasswords() {
    if (widget.passwordController.text.isEmpty ||
        widget.confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both passwords'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (widget.passwordController.text != widget.confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (widget.passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onPickImage,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.imageUrl != null
                    ? NetworkImage(widget.imageUrl!)
                    : null,
                child: widget.imageUrl == null
                    ? const Icon(Icons.add_a_photo,
                        size: 40, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 4),
              Text(
                '(Optional) Tap to add profile photo',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.person,
          controller: widget.nameController,
          hintText: 'Name',
          isObscure: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.email,
          controller: widget.emailController,
          hintText: 'Email',
          isObscure: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.lock_outline_rounded,
          controller: widget.passwordController,
          hintText: 'Password',
          isObscure: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.lock_outline_rounded,
          controller: widget.confirmPasswordController,  // Use the widget's controller
          hintText: 'Confirm Password',
          isObscure: true,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.phone,
          controller: widget.phoneController,
          hintText: 'Phone',
          isObscure: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.location_on,
          controller: widget.addressController,
          hintText: 'Address',
          isObscure: false,
          enabled: false,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: widget.onPickLocation,
          icon: const Icon(Icons.location_on),
          label: const Text('Pick Location (Optional)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (validatePasswords()) {
                      widget.onSubmit();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: widget.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Register'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onToggleAuth,
          child: const Text(
            'Already have an account? Login',
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ],
    );
  }
}
