import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';

class MyItinerary extends StatefulWidget {
  const MyItinerary({super.key});

  @override
  State<MyItinerary> createState() => _MyItineraryState();
}

class _MyItineraryState extends State<MyItinerary> {
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  Future<List<String>> fetchUserItineraryTexts() async {
    List<String> itineraryTexts = [];

    try {
      // Replace 'your_collection_name' with the actual name of your collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('itineraries')
          .where('userId', isEqualTo: currentUserID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents and fetch 'itineraryText'
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String itineraryText = data['itineraryText'];
          itineraryTexts.add(itineraryText);
        });
      }
    } catch (e) {
      print('Error fetching itinerary texts: $e');
      // Handle the error as per your application's needs
    }

    return itineraryTexts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary Texts'),
      ),
      body: FutureBuilder<List<String>>(
        // Replace 'currentUserID' with the actual ID of the current user
        future: fetchUserItineraryTexts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No itinerary texts found.');
          } else {
            // Display the list of itinerary texts with alternate background colors
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Pallete.primaryCard,
                  child: ListTile(
                    title: Text(snapshot.data![index]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
