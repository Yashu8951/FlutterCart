import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_reg/api.dart';
import 'package:login_reg/login.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _form = GlobalKey<FormState>();
  late Map<String, dynamic> res;
  final api = Api();

  void _showdilog(BuildContext context, mess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(title: Text("Alert"), content: Text(mess));
      },
    );
  }

  TextEditingController textEditingControllerUsername = TextEditingController();
  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  TextEditingController textEditingControllerVerifyPassword =
      TextEditingController();
  void registerResponse() async {
    String username = textEditingControllerUsername.text;
    String email = textEditingControllerEmail.text;
    String password = textEditingControllerPassword.text;
    String verifyPassword = textEditingControllerVerifyPassword.text;
    String role = "CUSTOMER";

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        password == verifyPassword) {
      res = await api.register(username, email, password, role);
      if (res["message"] == "Register succefull") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        _showdilog(context, res['error']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Lottie.asset(
                  "assert/animation/PeopleInAutumnScene.json",
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  "Register",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: textEditingControllerUsername,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  isDense: true,
                                  hintText: "Enter the username",
                                  hintStyle: GoogleFonts.dmSans(),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: textEditingControllerEmail,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  isDense: true,
                                  hintText: "Enter the Email",
                                  hintStyle: GoogleFonts.dmSans(),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                obscureText :true,
                                controller: textEditingControllerPassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  isDense: true,
                                  hintText: "Enter the Password",
                                  hintStyle: GoogleFonts.dmSans(),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: textEditingControllerVerifyPassword,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: "Verify The Password",
                                  hintStyle: GoogleFonts.dmSans(),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Confirm The password";
                                  }
                                  if (value !=
                                      textEditingControllerPassword.text) {
                                    return "Password do not Match";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_form.currentState!.validate()) {
                                    registerResponse();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(250, 45),
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "SignUp",
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 100),
                                  Text(
                                    "Existing User?",
                                    style: GoogleFonts.dmSans(
                                      color: Colors.blueGrey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
