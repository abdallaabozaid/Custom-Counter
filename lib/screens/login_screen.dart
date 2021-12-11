import 'package:country_code_picker/country_code_picker.dart';
import 'package:customized_counter/screens/otp_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _countryCode = '+20';
  final TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Image(
                width: 200,
                height: 100,
                image: AssetImage('assets/logo.png'),
              ),
              const Text('Welcome to Custom Counter',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  )),
              const Text(
                'Login with phone number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: CountryCodePicker(
                  onChanged: (country) {
                    print(country.dialCode);
                    setState(() {
                      _countryCode = country.dialCode!;
                    });
                  },
                  initialSelection: '+20',
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  favorite: const ['+20', '+1', '+966'],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _phoneNumberController,
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  // initialValue: countryCode,
                  decoration: InputDecoration(
                      labelText: 'phone number',
                      labelStyle: const TextStyle(color: Colors.black),
                      // hintText: 'Enter your phone number',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  textInputAction: TextInputAction.done,
                ),
              ),
              LogInButton(
                label: 'Send OTP',
                primaryColor: const Color(0xff04764E),
                onPrimaryColor: Colors.white,
                borderColor: const Color(0xff04764E),
                icon: Icons.phone,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpAuthScreen(
                      phone: _phoneNumberController.text,
                      countryCode: _countryCode,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton(
      {required this.label,
      required this.primaryColor,
      required this.onPrimaryColor,
      required this.borderColor,
      this.icon,
      this.widget,
      required this.onPressed,
      Key? key})
      : super(key: key);
  final String label;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color borderColor;
  final IconData? icon;
  final Widget? widget;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 318,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            child: icon == null
                ? widget
                : Icon(
                    icon,
                    size: 26,
                  ),
          ),
          Text(label),
          Icon(
            icon,
            size: 24,
            color: Colors.transparent,
          ),
        ]),
        style: ElevatedButton.styleFrom(
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            onPrimary: onPrimaryColor,
            primary: primaryColor,
            shape:
                StadiumBorder(side: BorderSide(width: 1, color: borderColor))),
      ),
    );
  }
}
