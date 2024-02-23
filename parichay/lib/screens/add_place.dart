import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parichay/colors/pallete.dart';

class AddPlace extends StatefulWidget {
  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();

  String _location = '';
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _about = '';
  String _description = '';
  String? _category;
  String _tags = '';
  String _city = '';

  List<String> _categories = [
    'Museums',
    'Nature',
    'Landmarks',
    'Tours',
    'Architecture',
    'Food & Drink',
    'Neighborhoods',
    'Recreation',
    'Religious',
    'Caves',
    'Industrial',
    'Beaches',
    'Lakes',
    'Entertainment',
    'History'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Form'),
        backgroundColor: Pallete.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                // boxShadow: [BoxShadow(blurRadius: 4.0)]?

                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Location',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Pallete.primary)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Pallete.primary)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Latitude',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Pallete.primary)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter latitude';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _latitude = double.parse(value!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Pallete.primary)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Longitude',
                            border: InputBorder.none,
                            labelStyle: TextStyle(color: Pallete.primary)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter longitude';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _longitude = double.parse(value!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'About',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Pallete.primary)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter about information';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _about = value!;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Brief Description',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Pallete.primary)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a brief description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                child: DropdownButtonFormField(
                  focusColor: Pallete.primary,
                  value: _category ?? _categories.first,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value.toString();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Tags',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Pallete.primary)),
                  onSaved: (value) {
                    _tags = value!;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(color: Pallete.primary)),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'City',
                      border: InputBorder.none,
                      labelStyle: TextStyle(color: Pallete.primary)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _city = value!;
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Pallete.whiteColor,
            backgroundColor: Pallete.primary, // Text color
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5,
            //minimumSize: Size(double.infinity, 0), // Full width
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Store data in Firebase Firestore
              _storeDataInFirestore();
            }
          },
          child: Text('Submit'),
        ),
      ),
    );
  }

  void _storeDataInFirestore() {
    // Access the Firestore instance
    FirebaseFirestore.instance.collection('locations').add({
      'Location': _location,
      'Latitude': _latitude,
      'Longitude': _longitude,
      'Comment': _about,
      'Wikipedia': _description,
      'Category': _category,
      'Tags': _tags,
      'City': _city,
      'Rating': 5,
    }).then((value) {
      // Data stored successfully
      print('Data stored in Firestore!');
    }).catchError((error) {
      // Error occurred while storing data
      print('Failed to store data: $error');
    });
  }
}
