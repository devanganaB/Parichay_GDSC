import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:parichay/screens/place_info.dart';
import 'package:parichay/screens/places_maps.dart';

import 'place_info.dart';

class PlaceCollection extends StatefulWidget {
  final String place;
  const PlaceCollection({super.key, required this.place});

  @override
  State<PlaceCollection> createState() => _PlaceCollectionState();
}

class _PlaceCollectionState extends State<PlaceCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.place}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('locations')
            .where('Category', isEqualTo: widget.place)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No ${widget.place} found.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var place = snapshot.data!.docs[index];
              // return ListTile(
              //   title: Text(place['Location']),
              //   subtitle: Text(place['City']),
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaceInfo(
                                  locationName: place['Location'],
                                )));
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
                            place['Location'],
                            style: TextStyle(
                                fontSize: 18,
                                color: Pallete.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            place['City'],
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
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.map),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlaceMap(category: widget.place)));
        },
      ),
    );
  }
}
