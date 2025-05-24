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
  final String? selectedState;
  final Function() onPickImage;
  final Function() onPickLocation;
  final Function() onSubmit;
  final Function() onToggleAuth;
  final Function(String) onStateSelected;  // Add this line

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
    required this.selectedState,
    required this.onPickImage,
    required this.onPickLocation,
    required this.onSubmit,
    required this.onToggleAuth,
    required this.onStateSelected,  // Add this line
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? selectedState;

  // List of Nigerian states
  final List<String> nigerianStates = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'FCT',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara'
  ];

  @override
  void initState() {
    super.initState();
    selectedState = widget.selectedState;
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
          controller:
              widget.confirmPasswordController, // Use the widget's controller
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedState,
              hint: const Text('Select State'),
              items: nigerianStates.map((String state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedState = newValue;
                    // Update the parent's selectedState
                    widget.onStateSelected(newValue);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          data: Icons.location_on,
          controller: widget.addressController,
          hintText: 'Detailed Address',
          isObscure: false,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    if (validateForm()) {
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

  bool validateForm() {
    if (!validatePasswords()) {
      return false;
    }

    if (selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
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

    if (widget.passwordController.text !=
        widget.confirmPasswordController.text) {
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
}
