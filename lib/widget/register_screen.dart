import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[200],
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.person,
          controller: nameController,
          hintText: 'Name',
          isObscure: false,
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.phone,
          controller: phoneController,
          hintText: 'Phone',
          isObscure: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.location_on,
          controller: addressController,
          hintText: 'Address',
          isObscure: false,
          enabled: false,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onPickLocation,
          icon: const Icon(Icons.my_location),
          label: const Text('Get Current Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
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
                : const Text('Register'),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onToggleAuth,
          child: const Text(
            'Already have an account? Login',
            style: TextStyle(color: Colors.amber),
          ),
        ),
      ],
    );
  }
}
