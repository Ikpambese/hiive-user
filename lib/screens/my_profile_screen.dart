import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../global/global.dart';
import '../widget/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../authentication/auth_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isEditing = false;
  bool _isDarkMode = false;
  bool _isLoading = false;
  String? _imageUrl;
  String? _selectedState;

  // Add Nigerian states list
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
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = sharedPreferences!.getString('name') ?? '';
    _emailController.text = sharedPreferences!.getString('email') ?? '';
    _phoneController.text = sharedPreferences!.getString('phone') ?? '';
    _addressController.text = sharedPreferences!.getString('address') ?? '';
    _imageUrl = sharedPreferences!.getString('photoUrl');
    _selectedState = sharedPreferences!.getString('userState');
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPreferences!.getString('uid'));

      await userRef.update({
        'userName': _nameController.text,
        'userPhone': _phoneController.text,
        'userAddress': _addressController.text,
        'userState': _selectedState,
        if (_imageUrl != null) 'userAvatarUrl': _imageUrl,
      });

      await sharedPreferences!.setString('name', _nameController.text);
      await sharedPreferences!.setString('phone', _phoneController.text);
      await sharedPreferences!.setString('address', _addressController.text);
      await sharedPreferences!.setString('userState', _selectedState ?? '');
      if (_imageUrl != null) {
        await sharedPreferences!.setString('photoUrl', _imageUrl!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      setState(() => _isEditing = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() => _isLoading = true);
      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref =
            FirebaseStorage.instance.ref().child('users').child(fileName);
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        setState(() => _imageUrl = url);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Add this method to handle profile deletion
  Future<void> _deleteProfile() async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
            'Are you sure you want to delete your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final uid = sharedPreferences!.getString('uid');
        if (uid != null) {
          // Delete user data from Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .delete();

          // Delete profile picture from Storage if exists
          if (_imageUrl != null) {
            try {
              await FirebaseStorage.instance.refFromURL(_imageUrl!).delete();
            } catch (e) {
              // Handle storage deletion error
            }
          }

          // Clear shared preferences
          await sharedPreferences!.clear();

          // Navigate to auth screen and remove all previous routes
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting profile: $e')),
          );
        }
      }
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.amber,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _isEditing ? _pickImage : null,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                    child: _imageUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
                if (_isEditing)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              data: Icons.person,
              hintText: 'Name',
              isObscure: false,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              data: Icons.email,
              hintText: 'Email',
              isObscure: false,
              enabled: false,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              data: Icons.phone,
              hintText: 'Phone',
              isObscure: false,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _addressController,
              data: Icons.location_on,
              hintText: 'Address',
              isObscure: false,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedState,
                  hint: const Text('Select State'),
                  items: nigerianStates.map((String state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  onChanged: _isEditing
                      ? (String? newValue) {
                          setState(() {
                            _selectedState = newValue;
                          });
                        }
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_isEditing) {
                          _updateProfile();
                        } else {
                          setState(() => _isEditing = true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_isEditing ? 'Save Changes' : 'Edit Profile'),
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isEditing = false),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ],

            // Add Delete Profile Button
            const SizedBox(height: 32),
            TextButton.icon(
              onPressed: _isLoading ? null : _deleteProfile,
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text(
                'Delete Profile',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
