import 'package:flutter/material.dart';

class MyTextFiled extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  MyTextFiled({this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(
          hintText: hint,
        ),
        validator: (value) => value!.isEmpty ? 'Field can not be Empty' : null,
      ),
    );
  }
}
