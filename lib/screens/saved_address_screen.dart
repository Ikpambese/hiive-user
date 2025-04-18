// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../global/global.dart';
import '../models/address.dart';
import '../widget/simple_appbar.dart';
import '../widget/text_field.dart';

class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Position? position;
  List<Placemark>? placemarks;

  SaveAddressScreen({super.key});

  getUserLocationAddress() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Fluttertoast.showToast(
          msg: 'Please enable location services in your device settings',
          backgroundColor: Colors.red,
        );
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Fluttertoast.showToast(
            msg: 'Location permissions are required to get your address',
            backgroundColor: Colors.red,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: 'Please enable location permissions in app settings',
          backgroundColor: Colors.red,
        );
        await Geolocator.openAppSettings();
        return;
      }

      // Show loading indicator
      Fluttertoast.showToast(
        msg: 'Getting your location...',
        backgroundColor: Colors.amber,
      );

      // Get current position with longer timeout
      position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Location request timed out. Please try again.');
        },
      );

      // Get address from coordinates
      placemarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark placemark = placemarks![0];
      print(placemark);
      String fullAddress =
          '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';

      _locationController.text = fullAddress;
      _flatNumber.text =
          '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}';

      _city.text =
          '${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.postalCode}';

      _state.text = '${placemark.country}';

      _completeAddress.text = fullAddress;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error getting location: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Hiive',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (() {
          // save address info

          if (formKey.currentState!.validate()) {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lng: position!.longitude,
              lat: position!.latitude,
            ).toJson();
            FirebaseFirestore.instance
                .collection('users')
                .doc(sharedPreferences!.getString('uid'))
                .collection('userAddress')
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then((value) => {
                      Fluttertoast.showToast(
                          msg: 'New Address has been Saved',
                          backgroundColor: Colors.green),
                      formKey.currentState!.reset(),
                    });
          }
        }),
        icon: Icon(
          Icons.save,
        ),
        label: const Text('Save Now'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 6),
          const Align(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Save New Address:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.black,
              size: 35,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
                controller: _locationController,
                decoration: InputDecoration(
                    hintText: 'Whats your address',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    )),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: (() {
              // get current location

              getUserLocationAddress();
            }),
            icon: Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.amber)),
              ),
            ),
            label: Text(
              'Get my Location',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(children: [
              MyTextFiled(
                controller: _name,
                hint: 'Name',
              ),
              MyTextFiled(
                controller: _phoneNumber,
                hint: 'Phone Number',
              ),
              MyTextFiled(
                controller: _city,
                hint: 'City',
              ),
              MyTextFiled(
                controller: _state,
                hint: 'State / Country',
              ),
              MyTextFiled(
                controller: _flatNumber,
                hint: 'Address line',
              ),
              MyTextFiled(
                controller: _completeAddress,
                hint: 'Complete Address',
              ),
            ]),
          )
        ],
      )),
    );
  }
}
