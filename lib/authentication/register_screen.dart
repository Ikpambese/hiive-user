// ignore_for_file: library_prefixes, non_constant_identifier_names, avoid_unnecessary_containers

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global.dart';
import '../screens/home_screen.dart';
import '../widget/custom_text_field.dart';
import '../widget/error_dialoge.dart';
import '../widget/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
// Form state global key

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // image upload
  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();
  Position? position;
  List<Placemark>? placeMarks;
  String userImageUrl = '';
  String completeAdress = '';
// GET IMAGE FROM FILE
  Future<void> _getImage() async {
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXfile;
    });
  }

// GET CURENT POSITION

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      position = newPosition;

      placeMarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      Placemark pMarks = placeMarks![0];

      String completeAddress =
          '${pMarks.subThoroughfare} ${pMarks.thoroughfare},${pMarks.subLocality} ${pMarks.locality},${pMarks.subAdministrativeArea},${pMarks.administrativeArea} ${pMarks.postalCode},${pMarks.country}';
      locationController.text = completeAddress;
    }
  }

  // FORM COONTROLLERS

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // FORM VALIDATION
  Future<void> formValiation() async {
    if (imageXfile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErroDialog(
            message: 'Please Select Image',
          );
        },
      );
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          // START UPLOADING IMAGE
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: 'Registering Account',
                );
              });

          // Image Storage to Firebase Storage

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();

          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child('users')
              .child(fileName);

          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXfile!.path));
          // download url
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl = url;

            // save info to firestore

            AuthenticateSeller();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return ErroDialog(
                message: 'Please write the required info for registration',
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErroDialog(
              message: 'Passwords do not match',
            );
          },
        );
      }
    }
  }

  void AuthenticateSeller() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (c) {
          return ErroDialog(
            message: error.message.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        // Send user to Home
        Route newRoute = MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      'userUID': currentUser.uid,
      'userEmail': currentUser.email,
      'userName': nameController.text.trim(),
      'userAvatarUrl': userImageUrl,
      'userPhone': phoneController.text.trim(),
      'userAddress': locationController.text.trim(),
      'userSatus': 'approved',
      'userCart': ['garbageValue'],
      //'userEarnings': 0.0,
      // 'lat': position!.latitude,
      // 'lng': position!.longitude,
    });

    // save data locally using sharedpreference
    //SAVED NAME,UID,PHOTOURL
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('email', currentUser.email.toString());
    await sharedPreferences!.setString('name', nameController.text.trim());
    await sharedPreferences!.setString('photoUrl', userImageUrl);
    await sharedPreferences!.setStringList(
        'userCarrt', ['garbageValue']); // temoral list of items locally
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _getImage(),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXfile == null
                    ? null
                    : FileImage(
                        File(imageXfile!.path),
                      ),
                child: imageXfile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.20,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: 'Name',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObscure: true,
                ),
                CustomTextField(
                  data: Icons.password,
                  controller: confirmPasswordController,
                  hintText: 'confirm Password',
                  isObscure: true,
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hintText: 'Phone',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.my_location,
                  controller: locationController,
                  hintText: 'Cafe/Restaurant Address',
                  isObscure: false,
                  enabled: false,
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () => getCurrentLocation(),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Get my current Location',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => {
                formValiation(),
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
              child: const Text(
                'Sign Up',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
