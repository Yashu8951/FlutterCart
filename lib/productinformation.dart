import 'package:flutter/material.dart';
import 'package:login_reg/api.dart';
import 'package:lottie/lottie.dart';

class Productinformation extends StatefulWidget {
  String url;
  String descrpition;
  double price;
  int stock;
  String name;
  String username;
  int productId;

  Productinformation(
      this.descrpition,
      this.url,
      this.price,
      this.stock,
      this.name,
      this.username,
      this.productId,
      {super.key});


  @override
  State<Productinformation> createState() => _ProductinformationState();
}

class _ProductinformationState extends State<Productinformation>  with SingleTickerProviderStateMixin{
  late final AnimationController _controller;
  double? targetProgress;
  final api =Api();
  int cartcount = 0;
  bool animationstart = false;
  int lottieKey = 0;
  bool isAdd = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _count();
    _controller = AnimationController(vsync: this,
    duration: Duration(seconds: 2));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  // void _showdilog(BuildContext context,mess) {
  //   showDialog(context: context, builder:(BuildContext context)
  //   {
  //     return AlertDialog(
  //       title: Text("Alert"),
  //       content: Text(mess),
  //     );
  //   }
  //
  //   );
  // }
  void addtodone(mess) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
    // _showdilog(context, mess);
  }
  void error(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }
  void _count() async {
    try {
      int count = await api.cartcount(widget.username);
      setState(() {
        cartcount = count;
      });
    } catch (e) {
      error(e.toString());
    }
  }
  void _addtocart(name, id) async {
    try {
      String mess = await api.addTocart(name, id);
      Navigator.pop(context, true);
      addtodone(mess);
       _count();
    } catch (e) {
      error(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body:
              Container( height: 900, width: 600,
                child: SingleChildScrollView( scrollDirection: Axis.vertical,
                  child: Card(elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 3,color: Colors.blue)
                              ),
                              child: Image.network(widget.url ,height: 500,)),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(widget.name,style: TextStyle(
                              fontWeight: FontWeight.w500,fontSize: 20,color: Colors.purpleAccent
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(widget.descrpition,style:
                              TextStyle(
                                  fontSize: 14,color: Colors.blueGrey
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text("ItemStock : ${widget.stock}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text("Price : ${widget.price}"),
                          ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                      onPressed: () {
                        _addtocart(widget.username, widget.productId);

                        _controller.stop();
                        _controller.reset();
                        _controller.forward();
                       Future.delayed(Duration(seconds: 3),(){
                         setState(() {

                         });
                       });
                      },
                    style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Lottie.asset(
                      "assert/animation/Addtocart.json",
                      controller: _controller,
                      onLoaded: (comp) {
                        _controller.duration = comp.duration;
                        targetProgress = 72 / comp.endFrame;
                        _controller.addListener(() {
                          if (_controller.value >= targetProgress!) {
                            _controller.stop();
                          }
                        });

                      },
                    ),
                  ),

                ),
                  )

                  ],
                      ),
                    ),
                  ),
                ),
              )
    );
  }
}
