import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'dart:convert';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:parichay/colors/pallete.dart';
import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parichay/screens/registerGuide.dart';
import 'package:parichay/screens/street_view.dart';
import 'package:http/http.dart' as http;

// import 'package:tflite/tflite.dart';

class PlaceInfo extends StatefulWidget {
  const PlaceInfo({Key? key, required this.locationName}) : super(key: key);
  final String locationName;
  @override
  _PlaceInfoState createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> {
  String category = '';
  String city = '';
  String description = '';
  double rating = 0.0;
  String locationId = '';
  double latitude = 37.7749;
  double longitude = -122.4194;
  // List<String> recommendations = [];
  double predefinedLocationLat = 37.7749;
  double predefinedLocationLong = -122.4194;
  final double radius = 100000000;
  double _rating = 0;
  String _review = '';
  bool _isButtonEnabled = false;
  var location;
  bool _isLoading = true;
  late String locationName;
  late String imageUrl;

//image fetching
  Future<void> fetchImage() async {
    const unsplashApiKey = 'buSU_UmLJboo1ASR9VjZJCImR6_SxUbweVleVFVcCBg';
    final response = await http.get(
      Uri.parse(
          'https://api.unsplash.com/photos/random?query=${widget.locationName}&client_id=$unsplashApiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final urls = data['urls'];
      setState(() {
        imageUrl = urls['regular'];
        _isLoading = false;
      });
    } else {
      print('Failed to load image: ${response.statusCode}');
    }
  }

//info fetching of location
  fetchInfo() async {
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
    final querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where("Location", isEqualTo: locationName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot firstDocument = querySnapshot.docs.first;
      Map<String, dynamic> location = querySnapshot.docs.first.data();
      setState(() {
        print("THE PRINT STATEMENT:");
        print(location);
        locationId = firstDocument.id;

        latitude = location['Latitude'] is double
            ? location['Latitude']
            : double.parse(location['Latitude'].toString());

        longitude = location['Longitude'] is double
            ? location['Longitude']
            : double.parse(location['Longitude'].toString());
        print('Rating before conversion: ${location['Latitude']}');
        print('Rating before conversion: ${location['Longitude']}');
        // longitude = double.parse(location['Longitude']);
        category = location['Category'];
        description = location['Wikipedia'];
        city = location['City'];
        rating = location['Rating'] is double
            ? location['Rating']
            : double.parse(location['Rating'].toString());
      });
    } else {
      throw Exception('Location not found');
    }
    var locationtemp = await _getCoordinatesFromAddress(locationName);
    setState(() {
      location = locationtemp;
    });
  }

  // void loadModel() async {
  //   Tflite.close();
  //   var res = await Tflite.loadModel(
  //     model: "assets/recommendation_model.tflite",
  //   );
  //   print(res);
  //   // makeRecommendations();
  //   // Replace "assets/recommendation_model.tflite" with the path to your .tflite file
  //   // Make sure you have placed the .tflite file in the assets folder of your Flutter project
  // }

  // void makeRecommendations() async {
  //   Uint8List clickedPlaceBytes = utf8.encode(title);
  //   var output = await Tflite.runModelOnBinary(
  //     binary: clickedPlaceBytes,
  //     numResults: 10, // Top 10 recommendations
  //     asynch: true,
  //   );

  //   List<String> result = [];
  //   for (var item in output!) {
  //     result.add(item['label']);
  //   }

  //   setState(() {
  //     recommendations = result;
  //   });
  //   print("This is recommendaton " + recommendations[1]);
  // }

//getting oordinates of address
  _getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      print('Error getting coordinates for address $address: $e');
      return [];
    }
  }

  _addToList() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    CollectionReference bucketCollectionRef = userRef.collection('bucket');

    await bucketCollectionRef.doc(locationId).set({
      'LocationId': this.locationId,
      'LocationName': locationName,
      'LocationCity': city,
      'LocationRating': rating,
    });
    // Show Snackbar when the place is added to the Bucket List
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$locationName has been added to your Bucket List'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, String>> recommendations = [];

  @override
  void initState() {
    fetchImage();
    locationName = widget.locationName;
    fetchInfo();
    _checkIfVisited();
    super.initState();
    getRecommendations(locationName);
    // _initBackgroundLocation();
  }

//checking if it is visited
  _checkIfVisited() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var visitedCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visited');
    var querySnapshot = await visitedCollection.doc(locationId).get();

    if (!querySnapshot.exists) {
      _initBackgroundLocation();
    }
  }

//fetching user's live location
  Future<void> _initBackgroundLocation() async {
    await BackgroundLocation.startLocationService();
    // await BackgroundLocation.startLocationUpdates();
    BackgroundLocation.getLocationUpdates((location) {
      _checkLocationAndShowAlert(location.latitude!, location.longitude!);
    });
  }

  void _submitRating() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var currentratesnap = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .get();
    var currentrate = (currentratesnap['Rating'] as double);
    currentrate = (currentrate + _rating) / 2;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visited')
        .doc(locationId)
        .set({
      "LocationID": locationId,
      "DateVisit": DateTime.now(),
      "Rated": _rating,
      "Review": _review
    });
    FirebaseFirestore.instance.collection('locations').doc(locationId).update({
      'Rating': currentrate,
    });
    FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .collection('Reviews')
        .add({
      'RatedBy': userId,
      'Rating': _rating,
      'Review': _review,
      'Timestamp': Timestamp.now(),
    }).then((value) {
      // Reset fields after submission
      setState(() {
        _rating = 0;
        _review = '';
        _isButtonEnabled = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      // Show error message if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit rating: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _checkLocationAndShowAlert(double currentLat, double currentLong) {
    double distance = Geolocator.distanceBetween(
      currentLat,
      currentLong,
      predefinedLocationLat,
      predefinedLocationLong,
    );

    print("The distance is $distance");

    if (distance <= radius) {
      BackgroundLocation.stopLocationService();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Great!'),
          content: Text('Seems Like you are Already visiting this location'),
          actions: <Widget>[
            Text(
              'Rate it',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              child: Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating.floor() ? Icons.star : Icons.star_border,
                      color: Pallete.primary,
                      size: 20.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                        _isButtonEnabled = true;
                      });
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write a review (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _submitRating : null,
              child: Text('Submit'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

//recommendation api call
  Future<void> getRecommendations(String location) async {
    print('getRecommendations called for location: $location'); // Debug print

    final String url = 'http://10.0.2.2:5000/get_recommendations';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {'location': location};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Server Response: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        setState(() {
          recommendations =
              (jsonDecode(response.body)['recommendations'] as List)
                  .map((place) => {'placeName': place.toString()})
                  .toList();
        });
        print('Recommendations: $recommendations');
      } else {
        print(
            'Failed to fetch recommendations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Encountered: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(locationName)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: Pallete.primaryCard,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Image.network(
                        imageUrl,
                        height: 180,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
              ),
              Card(
                color: Pallete.primaryCard,
                child: Container(
                    height: 80,
                    child: Center(
                        child: Text(
                      locationName,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ))),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Pallete.primaryCard,
                child: Container(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "City:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        this.city,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Pallete.primaryCard,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _addToList();
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Pallete.primary,
                            // minimumSize: const Size(double.infinity, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side:
                                  BorderSide(color: Pallete.primary, width: 2),
                            )),
                        child: Text(
                          'Add to Bucket List',
                          style: TextStyle(color: Pallete.whiteColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.star,
                                size: 30,
                                color: Pallete.primary,
                              )),
                          Text(
                            this.rating.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                color: Pallete.primaryCard,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Description:",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Text(this.description)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              // Recommendation carousel
              Container(
                child: Column(
                  children: [
                    Text(
                      'Other places',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 120, // Adjust the height as needed
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendations.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RecommendationCard(
                              placeName: recommendations[index]['placeName']!,
                              onTap: (selectedPlace) {
                                setState(() {
                                  locationName = selectedPlace;
                                });
                                fetchInfo(); // Fetch information for the new location
                                getRecommendations(selectedPlace);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       foregroundColor: Pallete.whiteColor,
      //       backgroundColor: Pallete.primary, // Text color
      //       // padding: const EdgeInsets.all(20),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30.0),
      //       ),
      //       // elevation: 5,
      //       //minimumSize: Size(double.infinity, 0), // Full width
      //     ),
      //     onPressed: () async {
      //       double lat = location.first.latitude;
      //       double long = location.first.longitude;
      //       print("The lat long is $lat $long");
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => StreetViewPanoramaInitDemo(
      //                     place: widget.locationName,
      //                     lat: lat,
      //                     long: long,
      //                     rating: rating,
      //                   )));
      //     },
      //     child: Container(
      //       height: 60,
      //       width: double.infinity,
      //       alignment: Alignment.center,
      //       child: Text(
      //         'Street View',
      //         style: TextStyle(color: Pallete.whiteColor),
      //       ),
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterGuide(
                            locationId: locationId,
                          )));
                },
                backgroundColor: Pallete.primary,
                child: const Text(
                  'Work as Guide',
                  style: TextStyle(color: Pallete.whiteColor),
                )),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FloatingActionButton(
                onPressed: () async {
                  double lat = location.first.latitude;
                  double long = location.first.longitude;
                  print("The lat long is $lat $long");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StreetViewPanoramaInitDemo(
                                place: widget.locationName,
                                lat: lat,
                                long: long,
                                rating: rating,
                              )));
                },
                backgroundColor: Pallete.primary,
                child: const Text(
                  'Street View',
                  style: TextStyle(color: Pallete.whiteColor),
                )),
          )
        ],
      ),
    );
  }
}

// RecommendationCard widget
class RecommendationCard extends StatelessWidget {
  // final String imageUrl;
  final String placeName;
  final Function(String) onTap;

  RecommendationCard({required this.placeName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(placeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          child: Card(
            color: Pallete.primaryCard,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    placeName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
