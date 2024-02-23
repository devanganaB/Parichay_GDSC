import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:parichay/firebase/auth.dart';
import 'package:parichay/screens/home.dart';
import 'package:parichay/screens/login.dart';
import 'package:parichay/screens/registration.dart';
import 'package:parichay/screens/tabs_screen.dart';

class PhoneOTP extends StatefulWidget {
  const PhoneOTP({super.key});

  @override
  State<PhoneOTP> createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: Image(
                    image: AssetImage('assets/images/maharashtra_outline.png')),
              ),
              SizedBox(height: 20),
              Text(
                'Maharashtra, where every corner is a story waiting to be discovered',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Pallete.textprimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixText: "+91 ",
                      hintText: "Enter your Phone number...",
                      suffix: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          color: Pallete.primary, // Set border color here
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length != 10) return "Invalid Phone Number";
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) ;
                  AuthService.sentOtp(
                      phone: _phoneController.text,
                      errorStep: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Error sendign the OTP",
                                style: TextStyle(color: Pallete.whiteColor),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          ),
                      nextStep: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("OTP Verification"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Enter the OTP"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                          controller: _otpController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: "Enter OTP...",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.length != 6)
                                              return "Incorrect OTP";
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Center(
                                      child: TextButton(
                                          onPressed: () {
                                            if (_formKey1.currentState!
                                                .validate()) {
                                              AuthService.loginWithOTP(
                                                      otp: _otpController.text)
                                                  .then((value) {
                                                if (value == "Success") {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TabsScreen(
                                                                getIndex: 0,
                                                              )));
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            color: Pallete
                                                                .whiteColor),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                          },
                                          child: const Text("Verify OTP")),
                                    )
                                  ],
                                ));
                      });
                },
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
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Send OTP',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login().animate().slideX()));
                },
                child: Text(
                  'Sign with email',
                  style: TextStyle(color: Pallete.textprimary),
                ),
              ),
              TextButton(
                onPressed: () {
                  try {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  'New User? Register',
                  style: TextStyle(color: Pallete.textprimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
