import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vehicles/form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => VehicleForm()));
                },
                child: Text("Add Bike")),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Set background color for the page
        child: StreamBuilder(
          stream: fireStore.collection('vehicles').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return _buildVehicleCard(
                    data); // Use the custom card-based design
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildVehicleCard(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    double fuelEfficiency = double.tryParse(data['mileage']) ?? 0;
    int yearsOld = int.tryParse(data['yearsOld']) ?? 0;

    Color color;
    String pollutantStatus;

    if (fuelEfficiency >= 15 && yearsOld <= 5) {
      color = Colors.green;
      pollutantStatus = 'Low Pollutant';
    } else if (fuelEfficiency >= 15 && yearsOld > 5) {
      color = Colors.amber;
      pollutantStatus = 'Moderate Pollutant';
    } else {
      color = Colors.red;
      pollutantStatus = 'High Pollutant';
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: color, // Set the color based on the criteria
          child: ListTile(
            title:
                Text(data['bikeName'], style: TextStyle(color: Colors.white)),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Years Old: ${data['yearsOld']}',
                    style: TextStyle(color: Colors.white)),
                Text('Mileage: ${data['mileage']}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
