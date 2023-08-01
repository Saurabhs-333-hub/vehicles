import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:vehicles/vehicle_model.dart';

class VehicleForm extends StatefulWidget {
  const VehicleForm({super.key});

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  var fireStore = FirebaseFirestore.instance;

  TextEditingController yearsOldController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController bikeNameController = TextEditingController();

  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Form'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Vehicle Form',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: bikeNameController,
              labelText: 'Bike Name',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: yearsOldController,
              labelText: 'Years Old',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: mileageController,
              labelText: 'Mileage',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_validateForm()) {
                  VehicleModel vehicleModel = VehicleModel(
                    yearsOld: yearsOldController.text.trim(),
                    mileage: mileageController.text.trim(),
                    bikeName: bikeNameController.text.trim(),
                  );
                  String uuid = Uuid().v4();
                  await fireStore
                      .collection('vehicles')
                      .doc(uuid)
                      .set(vehicleModel.toMap());

                  yearsOldController.clear();
                  mileageController.clear();
                  bikeNameController.clear();

                  setState(() {
                    _errorMessage = 'Vehicle added successfully!';
                  });
                }
              },
              child: Text('Add Vehicle'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                elevation: 5,
                textStyle: TextStyle(fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  bool _validateForm() {
    if (bikeNameController.text.isEmpty ||
        yearsOldController.text.isEmpty ||
        mileageController.text.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return false;
    }


    return true;
  }
}
