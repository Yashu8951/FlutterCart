import 'package:flutter/material.dart';
import 'package:login_reg/api.dart';
import 'package:login_reg/home.dart';
import 'package:login_reg/navigation.dart';
import 'package:login_reg/otpVerification.dart';
import 'package:login_reg/register.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Map<String,dynamic>  data;
  bool isLoading = false;
  String error = "";
  bool errors = false;
  late String cutomername;

  final api = Api();
  final _form = GlobalKey<FormState>();

  final TextEditingController textEditingControllerUsername =
  TextEditingController();
  final TextEditingController textEditingControllerPassword =
  TextEditingController();

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Navigation(cutomername)),
    );
  }



  Future<Map<String,dynamic>> _login() async {
    final username = textEditingControllerUsername.text.trim();
    final password = textEditingControllerPassword.text.trim();

    try {
      data = await api.login(username, password);
      setState(() {
        cutomername =data['username'];
      });
      return data;
    } catch (e) {
      return {
        'message': 'error',
        'error': e.toString(),
      };
    }
  }

  Future<void>ex1()async {
    int a =1;
    int b = 2;
    int c = a + b;
  }

  Future<int> ex2() async {
    int a =1;
    int b = 2;
    int c = a + b;
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(child: Lottie.asset("assert/animation/ManandWomansayHi!.json",height: 450,width: 450)),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Card(
                       elevation: 5,
                     child: Center(
                       child: Form(
                         key: _form,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Row(mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 SizedBox(width: 20,),
                                 Text("Login",style: GoogleFonts.dmSans(
                                   fontSize: 35,fontWeight: FontWeight.bold,
                                 ),),
                               ],
                             ),

                             Padding(
                               padding: const EdgeInsets.all(10),
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
                               padding: const EdgeInsets.all(10),
                               child: TextFormField(
                                 controller: textEditingControllerPassword,
                                 obscureText: true,
                                 decoration: InputDecoration(
                                     labelText: "Password",
                                     hintText: "Enter the password",
                                     hintStyle: GoogleFonts.dmSans(),
                                     border: OutlineInputBorder(),
                                     isDense: true

                                 ),
                                 validator: (value) {
                                   if (value == null || value.isEmpty) {
                                     return "Password cannot be empty";
                                   }
                                   return null;
                                 },
                               ),
                             ),


                             ElevatedButton(
                               onPressed: isLoading
                                   ? null
                                   : () async {
                                 ex1();
                                 ex2();
                                 if (!_form.currentState!.validate()) {
                                   return;
                                 }

                                 setState(() => isLoading = true);
                                 //
                                 // List result = await Future.wait([
                                 //   Future.delayed(Duration(seconds: 4)),
                                 //   _login()
                                 // ]);
                                 //
                                 // String mess = result[1];

                                 Map<String,dynamic> result = await _login();

                                 setState(() => isLoading = false);

                                 if (result['message'] == "Login successful") {
                                   Future.delayed(Duration(seconds: -1),() {
                                     navigate();
                                   });

                                 } else {
                                   setState(() {
                                     error = result['error'];
                                     debugPrint("error: $error");
                                     errors =true;

                                   });
                                   Future.delayed(Duration(seconds: 3),(){
                                     setState(() {
                                       errors = false;
                                     });
                                   });
                                 }
                               },style: ElevatedButton.styleFrom(
                                 padding: EdgeInsets.zero,
                                 minimumSize: Size(250, 45),
                                 backgroundColor: Colors.black,
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10)
                                 )
                             ),
                               child: Text("Login",style: GoogleFonts.dmSans(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 20),),
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                 children: [SizedBox(width: double.minPositive+30,),
                                   Text("Don't Have An Account?" ,style: GoogleFonts.dmSans(color: Colors.blueGrey,fontSize: 15),),
                                   TextButton(onPressed: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
                                   }, child: Text("Sign Up",style: GoogleFonts.dmSans(fontSize:15,color: Colors.blueGrey,fontWeight: FontWeight.bold),))
                                 ],
                               ),
                             ),


                           ],
                         ),
                       ),
                     ),
                                   ),
                ),
              ],
            ),
          ),


          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    "assert/animation/SandyLoading.json",
                  ),
                ),
              ),
            ),
          if (errors)

            Container(

              color: Colors.white,
              child: Center(
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: Column(
                    children: [
                      Expanded(
                        child: Lottie.asset(
                          "assert/animation/NotLoggedIn.json",
                        ),
                      ),
                      Text(error,style:TextStyle(fontWeight: FontWeight.w400,color: Colors.red),),

                    ],
                  ),
                ),
              ),
            )

        ],
      ),
    );
  }
}
