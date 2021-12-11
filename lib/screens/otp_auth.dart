import 'package:customized_counter/screens/home_screen.dart';
import 'package:customized_counter/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpAuthScreen extends StatefulWidget {
  OtpAuthScreen(
      {Key? key, required this.countryCode, required this.phone, this.codeSent})
      : super(key: key);
  static String routeName = '/OtpAuthScreen';
  final String phone;
  final String countryCode;
  final String? codeSent;

  @override
  State<OtpAuthScreen> createState() => _OtpAuthScreenState();
}

class _OtpAuthScreenState extends State<OtpAuthScreen> {
  String? verificationCode;

  final BoxDecoration otpBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Colors.white,
    border: Border.all(
      color: Color(0xff04764E),
    ),
  );

  verifyPhoneNumber() async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.countryCode + widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) {
          //for Auto-signIn without filling pin manually :
          // await FirebaseAuth.instance
          //     .signInWithCredential(credential)
          //     .then((value) {
          //   if (value.user != null) {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => HomePage()));
          // }
          // });
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ));
        },
        codeSent: (String vId, int? resentToken) {
          setState(() {
            verificationCode = vId;
          });
        },
        timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String vID) {
          setState(
            () {
              verificationCode = vID;
            },
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    verifyPhoneNumber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            backgroundColor: Color(0xff04764E),
            child: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const Image(
                    width: 200,
                    height: 70,
                    image: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Verifying : ${widget.countryCode} ${widget.phone}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: PinPut(
                        fieldsCount: 6,
                        textStyle: const TextStyle(
                          color: Color(0xff04764E),
                          fontSize: 24,
                        ),
                        eachFieldHeight: 55,
                        eachFieldWidth: 40,
                        initialValue: verificationCode,
                        selectedFieldDecoration: otpBoxDecoration,
                        followingFieldDecoration: otpBoxDecoration,
                        submittedFieldDecoration: otpBoxDecoration,
                        pinAnimationType: PinAnimationType.slide,
                        onSubmit: (pin) async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                              PhoneAuthProvider.credential(
                                  verificationId: verificationCode!,
                                  smsCode: pin),
                            )
                                .then((value) {
                              if (value.user != null) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const HomePage()));
                                (value);
                              }
                            });
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Invalid OTP'),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  LogInButton(
                    label: ' Get Started',
                    primaryColor: const Color(0xff04764E),
                    onPrimaryColor: Colors.white,
                    borderColor: const Color(0xff04764E),
                    icon: Icons.check_sharp,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Did not get OTP ?   ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff04764E)),
                      ),
                      GestureDetector(
                        onTap: () {
                          verifyPhoneNumber();
                        },
                        child: const Text(
                          'Resend now',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Want to change the phone number ?  ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff04764E)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'Go back',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
