import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:parichay/screens/add_place.dart';
import 'package:parichay/screens/planner_pro_input.dart';

class Cplanner extends StatefulWidget {
  @override
  _CplannerState createState() => _CplannerState();
}

class _CplannerState extends State<Cplanner> {
  Future<List<DocumentSnapshot>> fetchAllItineraries() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('itineraries').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching itineraries: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary List'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchAllItineraries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No itineraries found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DocumentSnapshot itinerary = snapshot.data![index];
                String city = itinerary['destination'] ?? 'Unknown City';
                String date = itinerary['location'] ?? 'Unknown Date';
                String itineraryId = itinerary.id;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItineraryDetailsPage(itineraryId: itineraryId),
                        ),
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Pallete.primary),
                        // color: Pallete.primary,
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '$city - $date',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Pallete.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              itinerary['duration'],
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ))
                        // Add more fields as needed
                        ),
                  ),
                );

                // ListTile(
                //   title: Text('$city - $date'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             ItineraryDetailsPage(itineraryId: itineraryId),
                //       ),
                //     );
                //   },
                // );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TripPlannerPro()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Pallete.primary,
            onPrimary: Pallete.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5,
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            height: 60,
            alignment: Alignment.center,
            child: Text(
              'Plan Your Itinerary with Us',
              style: TextStyle(color: Pallete.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}

class ItineraryDetailsPage extends StatefulWidget {
  final String itineraryId;

  ItineraryDetailsPage({required this.itineraryId});

  @override
  _ItineraryDetailsPageState createState() => _ItineraryDetailsPageState();
}

class _ItineraryDetailsPageState extends State<ItineraryDetailsPage> {
  Future<Map<String, dynamic>> fetchItineraryDetails() async {
    try {
      DocumentSnapshot itinerarySnapshot = await FirebaseFirestore.instance
          .collection('itineraries')
          .doc(widget.itineraryId)
          .get();

      return itinerarySnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching itinerary details: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchItineraryDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No itinerary details found.'));
          } else {
            // Use snapshot.data to display detailed information on this page
            // For example: snapshot.data['city'], snapshot.data['date'], etc.
            return Container(
              child: Column(children: [
                Text(
                  'City: ${snapshot.data!['location']} - ${snapshot.data!['destination']}',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Pallete.primary),
                ),
                Text(
                  'City: ${snapshot.data!['duration']}',
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
                Text(
                  'City: ${snapshot.data!['budgetRange']}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Pallete.primary),
                ),
                Text(
                  'City: ${snapshot.data!['itineraryText']}',
                  style: TextStyle(fontSize: 15.0),
                ),
              ]),
            );
          }
        },
      ),
    );
  }
}
