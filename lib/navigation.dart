import 'package:flutter/material.dart';
import 'package:login_reg/api.dart';
import 'package:login_reg/cart_page.dart';
import 'package:login_reg/home.dart';

class Navigation extends StatefulWidget {
  String username;
  Navigation(this.username,{super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _cuurentIndex = 0;
final api = Api();
int cartcount = 0;
  late final List<Widget> _pages=[
    Home(onCartUpdate: _count,),
    Center(child: Text("Profile Page")),
    CartPage(widget.username)
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _count();
  }
  void _count() async {
    try {
      int count = await api.cartcount(widget.username);
      setState(() {
        cartcount = count;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages[_cuurentIndex] ,
        bottomNavigationBar:BottomNavigationBar(
            currentIndex: _cuurentIndex,
            onTap: (index){
              setState(() {
                _cuurentIndex = index;
              });
            },
            items:[
              BottomNavigationBarItem(icon: Icon(Icons.home,
              ),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person,
              ),label: 'Profile'),
              BottomNavigationBarItem(icon: Badge.count(
                padding: EdgeInsets.all(2),
                count: cartcount,

                child: Icon(Icons.shopping_cart),
              ),label: "Cart"),


            ] )
    );

  }
}
