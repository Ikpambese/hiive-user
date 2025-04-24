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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
                          confirmPasswordController: confirmPasswordController,
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

  void _handleSubmit() async {
    print(passwordController.text);
    print(confirmPasswordController.text);
    print(confirmPasswordController.text == passwordController.text);
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
      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      setState(() => isLoading = true);

      // Create user account first
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Create user document reference
        final userRef = FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid);

        // Prepare user data with optional image URL
        final userData = {
          "userUID": userCredential.user!.uid,
          "userEmail": userCredential.user!.email,
          "userName": nameController.text.trim(),
          "userAvatarUrl": imageUrl ?? '', // Make image URL optional
          "userPhone": phoneController.text.trim(),
          "userAddress": addressController.text.trim(),
          "userSatus": "approved",
          "userCart": ["garbageValue"],
          "createdAt": FieldValue.serverTimestamp(),
        };

        // Add location data only if it's selected
        if (selectedLocation != null) {
          userData["location"] = selectedLocation;
        }

        // Save to Firestore
        await userRef.set(userData);

        // Save to SharedPreferences
        sharedPreferences = await SharedPreferences.getInstance();
        await Future.wait([
          sharedPreferences!.setString("uid", userCredential.user!.uid),
          sharedPreferences!.setString("email", userCredential.user!.email!),
          sharedPreferences!.setString("name", nameController.text.trim()),
          if (imageUrl != null)
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
