import 'package:flutter/material.dart';
import 'package:login_reg/login.dart';
import 'package:login_reg/model.dart';
void main() async {
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
