import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_reg/cart_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Payment {

  late Razorpay _razorpay;
  String username;
  BuildContext context;
  Payment(this.username,this.context) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,_handleFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleWallet);

  }
  String get baseUrl {
    // if (Platform.isAndroid) {
    //   return "http://10.0.2.2:9090";
    // }
    return "http://192.168.186.172:9090";
  }

  void dispose() {
    _razorpay.clear();
  }

  void error(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }
  Future<void> createOrder(double totalAmount,List<Map<String ,dynamic>> cartItems) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/payment/create"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
       body: jsonEncode({
         'totalAmount': totalAmount,
         'cartItems' : cartItems
       }),
      );

      if(response.statusCode == 200) {
        String orderID = response.body;
        startPayment(orderID, totalAmount);
      } else {
        debugPrint("error creating Order : ${response.body}");
      }
    } catch(e) {
       debugPrint("error: $e");
      error(e.toString());
       throw Exception(e.toString());
    }
  }
  void startPayment(String orderId,double amount) {
    var options = {
      'key': "rzp_test_RkHhEC8On3ZtnC",
      'amount' : amount *100,
      'name' : "yashwanth Shop",
      'order_id':orderId,
      'description' : 'Payment for Products',
      'prefill': {
        'contact' : "960632517",
        'email':"example@gmail.com"
      }
    };
    _razorpay.open(options);

  }
  void _handleSuccess(PaymentSuccessResponse response) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');

    debugPrint("Payment Successful!");
    final verifyRes = await http.post( Uri.parse("$baseUrl/api/payment/verify"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    body: jsonEncode({
      'razorpayOrderId':response.orderId,
      'razorpayPaymentId' :response.paymentId,
      'razorpaySignature' :response.signature
    })
    );
    debugPrint(verifyRes.body);
    if(verifyRes.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment Verified Successfully"),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CartPage(username))).then((_){

      });
    }else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Payment Verified Failed"),
            backgroundColor: Colors.red,
          )
      );
    }
  }
  void _handleFailure(PaymentFailureResponse response) {
    debugPrint("payment Failed : ${response.message}");
  }
  void _handleWallet(ExternalWalletResponse response) {
    debugPrint("External wallet selected");
  }
}