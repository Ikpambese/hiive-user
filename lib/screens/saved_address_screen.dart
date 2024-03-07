// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../global/global.dart';
import '../models/address.dart';
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

  getUserLocationAddress() async {
    Position newposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newposition;
    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark placemark = placemarks![0];

    String fullAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';

    _locationController.text = fullAddress;
    _flatNumber.text =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}';

    _city.text =
        '${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.postalCode}';

    _state.text = '${placemark.country}';

    _completeAddress.text = fullAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: SimpleAppBar(
      //   title: 'LunchBox',
      // ),
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
            title: Container(
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.cyan)),
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
