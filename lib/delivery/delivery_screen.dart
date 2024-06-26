import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiiveuser/global/global.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packageWeightController =
      TextEditingController();
  final TextEditingController _packageDescriptionController =
      TextEditingController();
  final TextEditingController _packageDestinationController =
      TextEditingController();
  final TextEditingController _packageSenderNameController =
      TextEditingController();
  final TextEditingController _packageSenderPhoneController =
      TextEditingController();

  final TextEditingController _receiverNameController = TextEditingController();
  final TextEditingController _receiverPhoneController =
      TextEditingController();
  final TextEditingController _receiverAddressController =
      TextEditingController();
  final TextEditingController _receiverAltPhoneController =
      TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save form data to Firebase
      FirebaseFirestore.instance.collection('minordelivery').add({
        'packageName': _packageNameController.text,
        // 'packageWeight': _packageWeigth.text,
        // 'packageDescription': _packageDescrition.text,
        // 'packageDestination': _packageDestination.text,
        // 'packageSenderName': _packageSenderName.text,
        // 'packageSenderPhone': _packageSenderPhone.text,
        'receiverName': _receiverNameController.text,
        'receiverPhone': _receiverPhoneController.text,
        'receiverAddress': _receiverAddressController.text,
        'receiverAltPhone': _receiverAltPhoneController.text,
        'status': 'pending',
        'bill': '0',
        // Add additional fields if needed
        'timestamp': DateTime.now(),
      });

      // Clear form fields
      _packageNameController.clear();
      // _packageWeigth.clear();
      // _packageDescrition.clear();
      // _packageDestination.clear();
      // _packageSenderName.clear();
      // _packageSenderPhone.clear();
      _receiverNameController.clear();
      _receiverPhoneController.clear();
      _receiverAddressController.clear();
      _receiverAltPhoneController.clear();

      // Show confirmation dialog or navigate to next screen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Your delivery request has been submitted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Hiive',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Signatra',
              color: Colors.amber,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.amber),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10, top: 5),
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: ClipOval(
                    child: Image.network(
                      sharedPreferences!.getString('photoUrl')!,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            // First Tab: Submit Form
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildAnimatedText('This is what I want to slide'),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Package Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TexformWidget(
                            controller: _packageNameController,
                            text: 'Package name cannot be empty',
                            hint: 'Enter Package name',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _packageWeightController,
                            text: 'Package weight cannot be empty',
                            hint: 'Enter Package Average Weight',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _packageDescriptionController,
                            text: 'Package description cannot be empty',
                            hint: 'Enter Package description',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _packageDestinationController,
                            text: 'Package destination cannot be empty',
                            hint: 'Enter Package destination address',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _packageSenderNameController,
                            text: 'Package sender cannot be empty',
                            hint: 'Enter Package sender name',
                          ),
                          SizedBox(height: 20),
                          TexformWidget(
                            controller: _packageSenderPhoneController,
                            text: 'Package sender phone cannot be empty',
                            hint: 'Enter Package phone',
                          ),
                          SizedBox(height: 20),
                          TexformWidget(
                            controller: _receiverNameController,
                            text: 'Package receiver name cannot be empty',
                            hint: 'Enter Package receiver name',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _receiverPhoneController,
                            text: 'Package receiver phone cannot be empty',
                            hint: 'Enter Package receiver phone',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _receiverAddressController,
                            text: 'Package receiver address cannot be empty',
                            hint: 'Enter Package receiver  address',
                          ),
                          SizedBox(height: 15),
                          TexformWidget(
                            controller: _receiverAltPhoneController,
                            text: 'Package alternate phone cannot be empty',
                            hint: 'Enter Package name',
                          ),
                          SizedBox(height: 20),
                          AnimatedButton(
                            onPress: _submitForm,
                            height: 70,
                            width: 200,
                            text: 'SUBMIT',
                            isReverse: true,
                            selectedTextColor: Colors.black,
                            transitionType: TransitionType.LEFT_TO_RIGHT,
                            textStyle: TextStyle(color: Colors.amber),
                            backgroundColor: Colors.black,
                            borderColor: Colors.white,
                            borderRadius: 50,
                            borderWidth: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Second Tab: Display Requests
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('minordelivery')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final requests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request =
                          requests[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(request['package']),
                        subtitle: Text(request['address']),
                        trailing: Text(request['status']),
                      );
                    },
                  );
                }
                return Center(child: Text('No requests found.'));
              },
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.add)),
            Tab(icon: Icon(Icons.history)),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedText(String text) => Container(
        height: 20,
        child: Marquee(
          textDirection: TextDirection.ltr,
          text: text ?? '', // Ensure text is not null
          blankSpace: 50,
          style: TextStyle(
            fontSize: 20,
            color: Colors.amber,
          ),
        ),
      );
}

class TexformWidget extends StatelessWidget {
  const TexformWidget({
    Key? key,
    required this.controller,
    required this.text,
    required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return text;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}
