import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../global/global.dart';
import '../screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../widget/login_screen.dart';
import '../widget/register_screen.dart';
//import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GeoPoint? selectedLocation;
  String? imageUrl;

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo Animation
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/honeycomb.png'),
                        fit: BoxFit.contain,
                        opacity: 0.2, // Semi-transparent background
                      ),
                    ),
                    child: Center(
                      child: Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json',
                        height: 200,
                        repeat: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Animated Welcome Text
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to Hiive',
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(height: 40),
                  isLogin
                      ? LoginScreen(
                          emailController: emailController,
                          passwordController: passwordController,
                          isLoading: isLoading,
                          onSubmit: _handleSubmit,
                          onToggleAuth: () {
                            setState(() {
                              isLogin = false;
                              _formKey.currentState?.reset();
                            });
                          },
                        )
                      : RegisterScreen(
                          nameController: nameController,
                          emailController: emailController,
                          passwordController: passwordController,
                          phoneController: phoneController,
                          addressController: addressController,
                          isLoading: isLoading,
                          imageUrl: imageUrl,
                          onPickImage: _pickImage,
                          onPickLocation: _pickLocation,
                          onSubmit: _handleSubmit,
                          onToggleAuth: () {
                            setState(() {
                              isLogin = true;
                              _formKey.currentState?.reset();
                            });
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: _inputDecoration(
        'Name',
        Icons.person,
        'Enter your name',
      ),
      validator: (value) {
        if (!isLogin && (value == null || value.isEmpty)) {
          return 'Please enter your name';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration(
        'Email',
        Icons.email,
        'Enter your email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: _inputDecoration(
        'Password',
        Icons.lock,
        'Enter your password',
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: obscurePassword,
      decoration: _inputDecoration(
        'Confirm Password',
        Icons.lock_outline,
        'Confirm your password',
      ),
      validator: (value) {
        if (!isLogin && (value == null || value.isEmpty)) {
          return 'Please confirm your password';
        }
        if (!isLogin && value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(
        'Phone',
        Icons.phone,
        'Enter your phone number',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: addressController,
      decoration: _inputDecoration(
        'Address',
        Icons.location_on,
        'Enter your address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address';
        }
        return null;
      },
    );
  }

  Widget _buildLocationPicker() {
    return ElevatedButton.icon(
      onPressed: _pickLocation,
      icon: const Icon(Icons.my_location),
      label: Text(
          selectedLocation != null ? 'Location Selected' : 'Pick Location'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (imageUrl != null)
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl!),
          ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(imageUrl != null ? 'Change Image' : 'Pick Profile Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                isLogin ? 'Login' : 'Register',
                style: const TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        _animationController.reset();
        setState(() {
          isLogin = !isLogin;
          _formKey.currentState?.reset();
        });
        _animationController.forward();
      },
      child: Text(
        isLogin
            ? 'Don\'t have an account? Register'
            : 'Already have an account? Login',
        style: const TextStyle(color: Colors.amber),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.amber),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.amber),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.amber),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.amber, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        if (isLogin) {
          await _handleLogin();
        } else {
          await _handleRegister();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!mounted) return;

    final context = this.context; // Capture context

    try {
      setState(() => isLoading = true);

      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      print(userCredential);
      print(userCredential.user);
      print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
      if (userCredential.user != null) {
        final userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .get();
        print(userData);
        if (!userData.exists ||
            userData["userSatus"]?.toString() == 'not approved') {
          throw 'User data not found. Please register again.';
        }

        final data = userData.data()!;

        print("THIS IS WHERE ALL THE DATA LIE");
        print(userCredential.user!.uid);
        print(userCredential.user!.email);
        print(data["userName"]?.toString());
        print(data["userName"]?.toString());
        print(data["userSatus"]?.toString());
        List<String> userCartList = userData.data()!['userCart'].cast<String>();

        // Save to SharedPreferences
        sharedPreferences = await SharedPreferences.getInstance();
        await Future.wait([
          sharedPreferences!.setString("uid", userCredential.user!.uid),
          sharedPreferences!.setString("email", userCredential.user!.email!),
          sharedPreferences!
              .setString("name", data["userName"]?.toString() ?? ''),
          sharedPreferences!
              .setString("photoUrl", data["userAvatarUrl"]?.toString() ?? ''),
          sharedPreferences!.setStringList("userCart", userCartList),
          sharedPreferences!
              .setString("status", data["userSatus"]?.toString() ?? ''),
        ]);

        if (mounted) {
          Navigator.pushReplacement(
            context, // Use captured context
            MaterialPageRoute(builder: (c) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      rethrow;
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleRegister() async {
    if (!mounted) return;
    final context = this.context;

    try {
      setState(() => isLoading = true);

      // Validate required fields first
      if (imageUrl == null) {
        print(imageUrl);
        throw 'Please select a profile image';
      }
      if (selectedLocation == null) {
        throw 'Please select your location';
      }

//

      // Create user account first
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Create user document reference
        print(imageUrl);

        final userRef = FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid);

        // Prepare user data
        final userData = {
          "userUID": userCredential.user!.uid,
          "userEmail": userCredential.user!.email,
          "userName": nameController.text.trim(),
          "userAvatarUrl": imageUrl,
          "userPhone": phoneController.text.trim(),
          "userAddress": addressController.text.trim(),
          "userSatus": "approved",
          "userCart": ["garbageValue"],
          "createdAt": FieldValue.serverTimestamp(),
        };
        print('HER IS THE SIGN UP SHIT');
        print(userData.entries.first);
        print(imageUrl);
        // Save to Firestore
        await userRef.set(userData);

        // Save to SharedPreferences
        sharedPreferences = await SharedPreferences.getInstance();
        await Future.wait([
          sharedPreferences!.setString("uid", userCredential.user!.uid),
          sharedPreferences!.setString("email", userCredential.user!.email!),
          sharedPreferences!.setString("name", nameController.text.trim()),
          sharedPreferences!.setString("photoUrl", imageUrl!),
          sharedPreferences!.setStringList("userCart", ["garbageValue"]),
          sharedPreferences!
              .setString("address", addressController.text.trim()),
          sharedPreferences!.setString("phone", phoneController.text.trim()),
          sharedPreferences!.setString("status", "approved"),
        ]);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;
    final context = this.context;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() => isLoading = true);

        // Create file reference
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref =
            FirebaseStorage.instance.ref().child('users').child(fileName);

        // Create file metadata
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': image.path},
        );

        try {
          // Upload file with metadata
          await ref.putFile(
            File(image.path),
            metadata,
          );

          // Get download URL after successful upload
          final url = await ref.getDownloadURL();

          if (mounted) {
            setState(() {
              imageUrl = url;
              print("THIS IS THE IMAGE URL: $url");
              isLoading = false;
            });
          }
        } on FirebaseException catch (e) {
          throw 'Upload failed: ${e.message}';
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  Future<void> _pickLocation() async {
    if (!mounted) return;
    final context = this.context;

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission is required')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enable location permissions in settings'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        await Geolocator.openAppSettings();
        return;
      }

      // Get location
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          //timeLimit: Duration(seconds: 5),
        ),
      );

      if (mounted) {
        setState(() {
          selectedLocation = GeoPoint(position.latitude, position.longitude);
        });

        // Get address
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          addressController.text =
              '${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }
}
