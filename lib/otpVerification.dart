import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Otpverification extends StatefulWidget {
  const Otpverification({super.key});

  @override
  State<Otpverification> createState() => _OtpverificationState();
}

class _OtpverificationState extends State<Otpverification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column( mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OtpTextField(
                numberOfFields: 4,
                borderColor: Color(0xFF512DA8),

                showFieldAsBox: true,

                onCodeChanged: (String code) {

                },

                onSubmit: (String su){

                }, // end onSubmit
              ),
            ],
          ),
        ],
      ),
    );
  }
}
