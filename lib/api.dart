import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:login_reg/model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final model = Model();
  String get baseUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:9090";
    }
    return "http://192.168.186.172:9090";
  }
  Future<Map<String,dynamic>> login(String username, String password) async {
    Map<String,dynamic> logindata;


    final url = Uri.parse("$baseUrl/api/Auth/login");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (res.statusCode == 200) {

      final data = jsonDecode(res.body);
      String token = data['token'];
      savedToken(token);
      logindata = data;
      if (data['token'] != null) {
        debugPrint(
          "Token :"
          '${data['token']}',
        );
      } else {
        debugPrint("Token is NotFound");
      }
      return data;
    } else {
      throw Exception("falied to login ${res.body}");
    }
  }

  Future<void> savedToken(String token) async {
    final save = await SharedPreferences.getInstance();
    await save.setString("token", token);
    // await model.addToken(token);
  }

  Future<String> logout() async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');

    if (token == null) {
      throw Exception("Token is not present");
    }
    final url = Uri.parse("$baseUrl/api/Auth/logout");
    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (res.statusCode == 200) {
      await log.remove("token");
      await model.deleteToken(token);
      return "logout Done!";
    } else {
      throw Exception("logout Done!");
    }
  }

  Future<Map<String, dynamic>> product(String name) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString("token");

    try {
      final uri = Uri.parse("$baseUrl/api/products?category=$name");
      final res = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> data1 = jsonDecode(res.body);
        return data1;
      } else {
        Map<String,dynamic> error = jsonDecode(res.body);
        return error;
      }
    } catch (e) {
      throw Exception(e.toString());

    }
  }
  Future<String> addTocart(String username, int productid) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');
    try {
      final uri = Uri.parse("$baseUrl/api/cart/ADDTOCART");
      final res = await http.post(uri,
       headers: {
         "Authorization": "Bearer $token",
         "Content-Type": "application/json",
       },
        body:jsonEncode({"username":username,"productId":productid})
      );
      if(res.statusCode==200) {
        return "Item is ADD";
      } else {
        return res.body;
      }

    } catch (e) {
     return throw Exception("unable to ADD to the cart");

    }


  }
  
  Future<int> cartcount(username) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');
    try {
      final uri =Uri.parse("$baseUrl/api/cart/items/count?username=$username");
      final res = await http.get(uri,headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      if(res.statusCode==200) {
        int data = int.parse(res.body) ;
        return data;
      } else {
        return 0;
      }
      
    } catch(e) {
       throw Exception(e.toString());
    }
    
  }
  Future<Map<String,dynamic>> cartpage(String username) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString('token');
    try {
      final uri =Uri.parse('$baseUrl/api/cart/items?userid=$username');
      final res =await http.get(uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });
      if(res.statusCode == 200) {
        Map<String,dynamic> data1 = jsonDecode(res.body);
        return data1;
      } else {
        Map<String,dynamic> data1 = jsonDecode(res.body);
        return data1;
      }
    } catch(e) {
      throw Exception(e.toString());

    }
  }
  Future<Map<String,dynamic>> register(String username,String email,String password,String role) async {
    try {
      final uri = Uri.parse('$baseUrl/api/User/Register');
      final res = await http.post(uri,headers: {
        "Content-Type": "application/json"
      },body: jsonEncode({
        'username':username,
        'email':email,
        'password':password,
        'role':role
      }));
      if(res.statusCode == 200) {
        Map<String,dynamic> data1 = jsonDecode(res.body);
        return data1;
      }else {
        Map<String,dynamic> data1 = jsonDecode(res.body);
        return data1;
      }
    } catch(e) {
      return throw Exception(e.toString());
    }
    
  }
  Future<void> deleteItem(String username,int productId) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString("token");
    try {
      final url =Uri.parse("$baseUrl/api/cart/delete");
      final res = await http.delete(url,headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "username":username,
        "productId":productId
      }));
      if(res.statusCode==200) {
        debugPrint(res.body);
      } else {
        debugPrint(res.body);
      }
    }catch(e) {
      throw Exception(e.toString());
    }
  }
  Future<void> update(int productid,int quantity) async {
    final log = await SharedPreferences.getInstance();
    String? token = log.getString("token");
    try {
      final url =Uri.parse("$baseUrl/api/cart/update");
      final res = await http.put(url,headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },body: jsonEncode({
        "productId":productid,
        "quantity":quantity
      })
      );
      if(res.statusCode==200) {
        debugPrint(res.body);
      }else {
        debugPrint(res.body);
      }
    } catch(e) {
      throw Exception(e.toString());
    }
  }

}
