import 'package:parichay/api/kycapi.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterGuide extends StatefulWidget {
  const RegisterGuide({Key? key, required this.locationId}) : super(key: key);
  final String locationId;
  @override
  _RegisterGuideState createState() => _RegisterGuideState();
}

class _RegisterGuideState extends State<RegisterGuide> {
  String? aadharVerificationResult;
  String? panVerificationResult;
  TextEditingController aadhaarController = TextEditingController();
  TextEditingController panController = TextEditingController();

  @override
  void dispose() {
    aadhaarController.dispose();
    panController.dispose();
    super.dispose();
  }

  Future<void> _showMyDialog() async {
    final user = FirebaseAuth.instance.currentUser?.uid;
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(user);
    print("User");
    userData.update({"role": 1});
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('location')
        .doc(widget.locationId)
        .collection('Guides')
        .doc(user);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Now you can work as Guide'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                pop();
              },
            ),
          ],
        );
      },
    );
  }

  void pop() {
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Pallete.blackColor,
      textColor: Pallete.whiteColor,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        backgroundColor: Pallete.primary,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  _showMyDialog();
                  // Navigator.pop(context);
                },
                child: const Text(
                  'Aadhaar Verification',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your Aadhaar and PAN details',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 35),
              buildTextField('Aadhaar Number', Icons.credit_card,
                  'Enter your Aadhaar number', TextInputType.number, (value) {
                if (value == null || value.isEmpty) {
                  return 'Aadhar is required';
                }
                if (int.tryParse(value) == null || value.length != 12) {
                  return 'Invalid Aadhar Number';
                }
                return null;
              }, aadhaarController),
              const SizedBox(height: 16),
              buildTextField('PAN Number', Icons.person,
                  'Enter your PAN number', TextInputType.text, (value) {
                if (value == null || value.isEmpty) {
                  return 'PAN is required';
                }
                if (value.length != 10) {
                  return 'Invalid PAN Number';
                }
                return null;
              }, panController),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _showMyDialog();
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return const AlertDialog(
                  //         content: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             Text('Verifying Aadhar...'),
                  //             SizedBox(height: 10),
                  //             CircularProgressIndicator(),
                  //           ],
                  //         ),
                  //       );
                  //     });

                  // String aadhaarNumber = aadhaarController.text;
                  // String panNumber = panController.text;
                  // print(aadhaarNumber);

                  // aadharVerificationResult = await verifyAadhar(aadhaarNumber);

                  // Map<String, String?> panVerificationResultMap =
                  //     await verifyPan(panNumber);

                  // String? panName =
                  //     panVerificationResultMap['fullName']?.toLowerCase();
                  // String? maskedAadhaar =
                  //     panVerificationResultMap['maskedAadhaar'];
                  // final user = FirebaseAuth.instance.currentUser?.uid;
                  // final userData = await FirebaseFirestore.instance
                  //     .collection('users')
                  //     .doc(user)
                  //     .get();

                  // final name = userData['name'];
                  // final CollectionName = name?.toLowerCase();

                  // bool last4DigitsMatch = false;
                  // print("masked");
                  // print(maskedAadhaar);
                  // if (maskedAadhaar != null && aadhaarNumber.length >= 4) {
                  //   String last4Input =
                  //       aadhaarNumber.substring(aadhaarNumber.length - 4);
                  //   print("last4");
                  //   print(last4Input);
                  //   String last4Masked =
                  //       maskedAadhaar.substring(maskedAadhaar.length - 4);
                  //   print("last4masked");
                  //   print(last4Masked);
                  //   last4DigitsMatch = last4Input == last4Masked;
                  // }

                  // if (aadharVerificationResult == 'completed' &&
                  //     panName == CollectionName &&
                  //     last4DigitsMatch) {
                  //   // Navigator.of(context).pop();
                  //   _showMyDialog();
                  //   showToast('Aadhar and PAN verified successfully');

                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //       builder: (context) => const FaceDetector()),
                  //   // );

                  //   final user = FirebaseAuth.instance.currentUser;
                  //   if (user != null) {
                  //     final userRef = FirebaseFirestore.instance
                  //         .collection('users')
                  //         .doc(user.uid);

                  //     await userRef.update({
                  //       'Aadhar Number': aadhaarNumber,
                  //       'PAN Number': panNumber,
                  //     });
                  //   }
                  // } else {
                  //   if (aadharVerificationResult != 'completed') {
                  //     Navigator.of(context).pop();
                  //     showToast('Aadhar is invalid');
                  //   } else if (panName != CollectionName) {
                  //     Navigator.of(context).pop();
                  //     showToast(
                  //         'PAN verification failed or Name is not as per Aadhar');
                  //   } else if (!last4DigitsMatch) {
                  //     Navigator.of(context).pop();
                  //     showToast('Aadhar verification failed.');
                  //   }
                  // }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Pallete.blackColor,
                  backgroundColor: Pallete.primary,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: const Size(double.infinity, 0), // Full width
                ),
                child: const Text(
                  'Verify Aadhaar and PAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label,
      IconData icon,
      String hint,
      TextInputType? keyboardType,
      FormFieldValidator<String>? validator,
      TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          validator: validator,
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Pallete.primary),
            hintText: hint,
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Pallete.textprimary),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Pallete.primary),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
