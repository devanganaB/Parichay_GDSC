import 'dart:async';
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GMap;
import 'package:parichay/colors/pallete.dart';

class StreetViewPanoramaInitDemo extends StatefulWidget {
  final String place;
  final double lat;
  final double long;
  final rating;
  StreetViewPanoramaInitDemo(
      {Key? key,
      required this.place,
      required this.lat,
      required this.long,
      required this.rating})
      : super(key: key);

  @override
  State<StreetViewPanoramaInitDemo> createState() =>
      _StreetViewPanoramaInitDemoState();
}

class _StreetViewPanoramaInitDemoState
    extends State<StreetViewPanoramaInitDemo> {
  // LatLng initPos = LatLng(widget.location.first.latitude, longitude)

  final initBearing = 352.54852294921875;

  final initTilt = -8.747010231018066;

  final initZoom = 0.01421491801738739;

  bool streatView = true;

  void togleViewMode() {
    // getCoordinates();
    setState(() {
      streatView = !streatView;
    });
  }

  final Completer<GMap.GoogleMapController> _controller =
      Completer<GMap.GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              streatView
                  ? FlutterGoogleStreetView(
                      markers: {
                        Marker(
                          markerId: const MarkerId("sadsdaa"),
                          position: LatLng(widget.lat, widget.long),
                        ),
                      },
                      onCameraChangeListener: (camera) {
                        print(camera.toMap());
                      },
                      initPos: LatLng(widget.lat, widget.long),
                      initSource: StreetViewSource.outdoor,
                      initBearing: initBearing,
                      initTilt: initTilt,
                      initZoom: initZoom,
                      onStreetViewCreated: (controller) async {
                        controller.animateTo(
                          duration: 50,
                          camera: StreetViewPanoramaCamera(
                            bearing: initBearing,
                            tilt: initTilt,
                            zoom: initZoom,
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GMap.GoogleMap(
                        onTap: ((argument) {
                          print(argument);
                        }),
                        markers: {
                          GMap.Marker(
                            markerId: const GMap.MarkerId("sadsaa"),
                            position: GMap.LatLng(widget.lat, widget.long),
                          ),
                        },
                        mapType: GMap.MapType.satellite,
                        initialCameraPosition: GMap.CameraPosition(
                          target: GMap.LatLng(widget.lat, widget.long),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GMap.GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
              Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: togleViewMode,
                          child: Container(
                            height: 150,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      streatView ? mapview : streateview),
                                  fit: BoxFit.cover),
                              border: Border.all(
                                width: 2,
                                color: call.withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.primaryStreet,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     gradient1,
                    //     gradient2,
                    //     gradient3,
                    //   ],
                    // ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.place,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Icon(
                                    CupertinoIcons.star_fill,
                                    size: 15,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    widget.rating.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color call = Color.fromARGB(0, 255, 255, 255); // ->call
Color message = Color.fromARGB(0, 247, 247, 247); //->message

Color gradient1 = Color.fromARGB(0, 164, 193, 255); // ->gradient
Color gradient2 = Color.fromARGB(0, 250, 250, 250); // ->gradient
Color gradient3 = Color.fromARGB(0, 255, 255, 255); // ->gradient

//022770 ->bottom container

String profile = "https://avatars.githubusercontent.com/u/37832937?v=4";
String mapview =
    "https://static.vecteezy.com/system/resources/previews/002/920/438/original/abstract-city-map-seamless-pattern-roads-navigation-gps-use-for-pattern-fills-surface-textures-web-page-background-wallpaper-illustration-free-vector.jpg";
String streateview =
    "https://static1.anpoimages.com/wordpress/wp-content/uploads/2017/11/nexus2cee_Google-Street-View-Generic-Hero.png";



// Please A Sub is enough for the channel




// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// // Custom class to manage place data and Street View URLs
// class Place {
//   final String name;
//   final LatLng location;
//   final String streetViewUrl;

//   const Place({
//     required this.name,
//     required this.location,
//     required this.streetViewUrl,
//   });
// }

// // Custom GoogleMap widget with integrated Street View functionality
// class StreetViewMap extends StatefulWidget {
//   final List<Place> places;

//   const StreetViewMap({required this.places});

//   @override
//   _StreetViewMapState createState() => _StreetViewMapState();
// }

// class _StreetViewMapState extends State<StreetViewMap> {
//   Set<Marker> _markers = {};
//   Place? _selectedPlace;

//   @override
//   void initState() {
//     super.initState();
//     // Create markers for each place
//     for (final place in widget.places) {
//       _markers.add(Marker(
//         markerId: MarkerId(place.name),
//         position: place.location,
//         infoWindow: InfoWindow(
//           title: place.name,
//           snippet: "Tap to view Street View",
//           onTap: () => setState(() => _selectedPlace = place),
//         ),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: widget.places[0].location,
//         zoom: 15.0,
//       ),
//       markers: _markers,
//       onTap: (LatLng position) {
//         // Handle map taps that don't fall on markers
//         // (Optional: Display a message or offer suggestions)
//       },
//       onMarkerTap: (MarkerId markerId) {
//         for (final place in widget.places) {
//           if (markerId.value == place.name) {
//             setState(() => _selectedPlace = place);
//             return;
//           }
//         }
//       },
//       onMapCreated: (GoogleMapController controller) {},
//     );
//   }

//   // Show Street View on selection
//   Widget _showStreetView() {
//     if (_selectedPlace != null) {
//       return AspectRatio(
//         aspectRatio: 16 / 9,
//         child: WebView(
//           initialUrl: _selectedPlace!.streetViewUrl,
//           javascriptMode: JavascriptMode.unrestricted,
//           navigationDelegate: (NavigationRequest request) {
//             // Handle navigation requests (e.g., prevent external navigation)
//             if (request.url.startsWith('https://maps.google.com')) {
//               return NavigationDecision.navigate;
//             }
//             return NavigationDecision.prevent;
//           },
//         ),
//       );
//     } else {
//       return Center(child: Text('Tap a place marker to view Street View'));
//     }
//   }
// }

// // Sample usage
// void main() async {
//   // Replace with your actual places and Street View URLs
//   final places = [
//     Place(
//       name: 'Eiffel Tower',
//       location: LatLng(48.858965, 2.294755),
//       streetViewUrl: 'https://maps.google.com/?q=eiffel+tower',
//     ),
//     Place(
//       name: 'Statue of Liberty',
//       location: LatLng(40.689249, -74.044500),
//       streetViewUrl: 'https://maps.google.com/?q=statue+of+liberty',
//     ),
//   ];

//   runApp(MaterialApp(
//     home: Scaffold(
//       body: StreetViewMap(
//         places: places,
//       ),
//       bottomNavigationBar: _selectedPlace != null
//           ? BottomAppBar(
//               child: _showStreetView(),
//             )
//           : null,
//     ),
//   ));
// }
