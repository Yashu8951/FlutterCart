import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_reg/cart_page.dart';
import 'package:login_reg/login.dart';
import 'package:login_reg/productinformation.dart';
import 'api.dart';

class Home extends StatefulWidget {

  final VoidCallback onCartUpdate;
  const Home({super.key,required this.onCartUpdate});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  Map<String, dynamic>? apiData;
  List<dynamic>? product = [];
  Map<String, dynamic>? user;
  final api = Api();
  int cartcount = 0;
  String cname = "Shirts";
  bool isHighlight = false;
  late CarouselSliderController innercontroller;
  late var innerpage = 0;
  int _cuurentIndex = 0;

  void addtodone(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }

  void _buttonclick() {
    setState(() {
      isHighlight = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData(cname);
    innercontroller = CarouselSliderController();
  }

  void _addtocart(name, id) async {
    try {
      String mess = await api.addTocart(name, id);
      addtodone(mess);
      _count();
    } catch (e) {
      error(e.toString());
    }
  }

  void loadData(String name) async {
    try {
      Map<String, dynamic> result = await api.product(name);
      setState(() {
        apiData = result;
        product = result['products'];
        user = result['user'];

        isLoading = false;
      });
      _count();

    } catch (e) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void navigate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void error(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }

  void _count() async {
    try {
      int count = await api.cartcount(user?['name']);
      setState(() {
        cartcount = count;
      });
    } catch (e) {
      error(e.toString());
    }
  }

  Future<String> _logout() async {
    try {
      final message = await api.logout();
      return message;
    } catch (message) {
      return throw Exception(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Discover",style: GoogleFonts.dmSans(
          fontWeight: FontWeight.bold,fontSize: 26
        ),),
        actions: [
          IconButton(
            onPressed: () {
              Future.delayed(Duration(milliseconds: 90),() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(user?['name']),
                  )
                ).then((_){
                  _count();
                });
              });

            },
            icon: Badge.count(
              padding: EdgeInsets.all(2),
              count: cartcount,
              child: Icon(Icons.shopping_cart),
            ),
          ),

          IconButton(
            onPressed: () async {
              String m = await _logout();
              if (m == 'logout Done!') {
                navigate();
              } else {
                error(m);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(2),
        child: Column(
          children: [
            SingleChildScrollView(scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          cname = "shirts";
                          loadData(cname);
                        });
                        _buttonclick();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
              
                        minimumSize: Size(25, 50),
                        backgroundColor:Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        "https://img.icons8.com/external-kiranshastry-lineal-color-kiranshastry/64/external-shirt-hygiene-kiranshastry-lineal-color-kiranshastry-1.png",
                        width: 65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: ()  {
                        setState(()  {
                          cname = 'pants';
                          loadData(cname);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(40, 50),
                        backgroundColor:Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        "https://img.icons8.com/fluency/48/trousers.png",
                        width: 65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cname = "Mobiles";
                        loadData(cname);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(25, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        "https://img.icons8.com/fluency/48/iphone14-pro--v1.png",
                        width: 65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cname = "Mobile Accessories";
                        loadData(cname);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(25, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        "https://img.icons8.com/stickers/100/phone-case.png",
                        width: 65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cname = "Accessories";
                        loadData(cname);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(25, 50),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.network(
                        "https://img.icons8.com/external-obivous-color-kerismaker/48/external-accessories-car-auto-parts-color-obivous-color-kerismaker-36.png",
                        width: 65,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(padding:
                  EdgeInsets.all(8),
                  sliver: SliverGrid(delegate: SliverChildBuilderDelegate(
                      (context,index) {
                        final i = product![index];
                        return  InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Productinformation(
                                  i['description'],
                                  i['image'] != null && i['image'].isNotEmpty
                                      ? i['image'][0]
                                      : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                                  i['price'] as double,
                                  i['stock'],
                                  i['name'],
                                  user?['name'],
                                  i['product_id'] as int,
                                ),
                              ),
                            ).then((value){
                              if(value==true) {
                                _count();
                                widget.onCartUpdate();
                              }
                            });
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Image.network(
                                      height: 170,
                                      width: double.infinity,
                                      i['image'] != null && i['image'].isNotEmpty
                                          ? i['image'][0]
                                          : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Text(
                                        i['name'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(width: 35),
                                      Text(
                                        i['description'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '₹ ${i['price']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     int id = product?[index]['product_id'];
                                          //     _addtocart(user?['name'], id);
                                          //   },
                                          //   style: ElevatedButton.styleFrom(
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(10),
                                          //     ),
                                          //   ),
                                          //   child: Icon(Icons.shopping_cart),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },childCount: min(product!.length, 4)
                  ), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.50
                  )
                  ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              children: [
                                CarouselSlider(
                                 carouselController: innercontroller,
                                  items: product!.take(5).map((i) {
                                  return Container(margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(image: NetworkImage(
                                        i['image'] != null && i['image'].isNotEmpty
                                            ? i['image'][0]
                                            : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                                      ),fit: BoxFit.contain,)
                                    ),

                                  );
                                }).toList(), options: CarouselOptions(
                                    autoPlay: true,
                                    viewportFraction: 0.50,
                                aspectRatio: 16/7,enlargeCenterPage: true,
                                 onPageChanged: (index,reason) {
                                      setState(() {
                                        innerpage = index;
                                      });
                                 }
                                ),
                                ),
                                 Row( mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                               ...List.generate(5, (index) {
                                bool isSelect = innerpage == index;
                                  return GestureDetector(
                                    onTap: (){
                                      innercontroller.animateToPage(index);
                                    },
                                    child: AnimatedContainer(duration: Duration(milliseconds: 300),
                                    height: 15,
                                    width: isSelect? 17 :14,
                                    margin: EdgeInsets.symmetric(horizontal: isSelect? 6 :3),
                                    decoration: BoxDecoration(
                                        color: isSelect?Colors.blue : Colors.grey,
                                      borderRadius: BorderRadius.circular(40)
                                    ),),
                                  );
                                })],)
                              ],
                            ),
                          ),

                        ],
                      ),
                  )
                  ),
                  SliverPadding(padding: EdgeInsets.all(8),
                  sliver: SliverGrid(delegate: SliverChildBuilderDelegate((context,index){
                    final i=product![index+4];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productinformation(
                              i['description'],
                              i['image'] != null && i['image'].isNotEmpty
                                  ? i['image'][0]
                                  : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                              i['price'] as double,
                              i['stock'],
                              i['name'],
                              user?['name'],
                              i['product_id'] as int,
                            ),
                          ),
                        ).then((value){
                          if(value==true) {
                            _count();
                            widget.onCartUpdate();
                          }
                        });
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  height: 170,
                                  width: double.infinity,
                                  i['image'] != null && i['image'].isNotEmpty
                                      ? i['image'][0]
                                      : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(
                                    i['name'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(width: 35),
                                  Text(
                                    i['description'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      '₹ ${i['price']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },childCount: product!.length-4
                  ), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.50,
                  ),),
                  )
                ],
              )
            ),
          ],
        ),
      ),

    );
  }
}
