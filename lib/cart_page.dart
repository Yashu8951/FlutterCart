import 'package:flutter/material.dart';
import 'package:login_reg/api.dart';
import 'package:login_reg/payment.dart';
import 'package:lottie/lottie.dart';

class CartPage extends StatefulWidget {
  final String username;
  const CartPage(this.username, {super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? cartdate;
  List<dynamic> item = [];
  int totalprice = 0;
  final api = Api();
  late final payment = Payment(widget.username,context);

  void succefullmess(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }

  void error(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess,style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.red,));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadcartdata();
  }

  void _loadcartdata() async {
    try {
      Map<String, dynamic> result = await api.cartpage(widget.username);
      setState(() {
        cartdate = result;
        item = result['cart']['product'];
        totalprice = result['cart']['overall_total_price'];
      });
    } catch (e) {
      error(e.toString());
    }
  }
  void _deleteCartItem(int productId)async {
    try {
      await api.deleteItem(widget.username, productId);
      _loadcartdata();
    } catch (e) {
      error(e.toString());
    }
  }
  void _update(int productid,int quantity) async {
    try {
      await api.update(productid, quantity);
 _loadcartdata();
    }catch(e) {
      error(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: item.isEmpty ?Center(child: Column(
              children: [
                SizedBox(height: 150),
                Lottie.asset("assert/animation/empty.json"),
                Text("Cart Is Empty",style: TextStyle(fontSize: 20,color: Colors.blueGrey,fontWeight: FontWeight.w400),)
              ],
            )) :GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.45,

              ),
              itemCount: item.length,
              itemBuilder: (context, index) {
                final i = item[index];
                return Card(
                  child: SingleChildScrollView(scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            height: 200,
                            width: 200,
                            i['imageUrl'] != null && i['imageUrl'].isNotEmpty
                                ? i['imageUrl']
                                : "https://cdn1.vectorstock.com/i/1000x1000/32/45/no-image-symbol-missing-available-icon-gallery-vector-45703245.jpg",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(i['name']),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: SingleChildScrollView(
                                    scrollDirection : Axis.horizontal,
                            child: Row(
                              children: [
                                Text('Quantity : ${i['quantity']}'),
                                SizedBox(width: 2),
                                ElevatedButton(
                                  onPressed: () {
                                   int quantity = i['quantity']+1;
                                    _update(i["product_id"],quantity );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.blue,
                                        style: BorderStyle.solid,
                                        width: 1,
                                      ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(40, 30),
                                  ),
                                  child: Text("+",style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(width: 1,),
                                ElevatedButton(
                                  onPressed: () {
                                    int quantity = i['quantity']-1;
                                    _update(i["product_id"],quantity );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size(40, 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.red,
                                    side: BorderSide(
                                      color: Colors.blue,
                                      style: BorderStyle.solid,
                                      width: 1,
                                    )
                                  ),
                                  child: Text("-",style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("PreUnit:₹ ${i['price_pre_unit']}"),
                                    Text("TotalPrice:₹ ${i['total_price']}",style: TextStyle(overflow: TextOverflow.ellipsis),),
                                    Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: ElevatedButton(onPressed: (){
                                        _deleteCartItem(i['product_id']);
                                      },style: ElevatedButton.styleFrom(
                                          minimumSize: Size(50, 40),
                                          padding: EdgeInsets.zero,

                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          )
                                      ), child: Text("Remove")),
                                    )

                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Total Price : $totalprice"),
                SizedBox(width: 130,),
                ElevatedButton(onPressed: (){
                 if(totalprice > 0) {
                  payment.createOrder(
                    totalprice.toDouble(),
                    item.map((i) => {
                      "productId": i['productId'] ?? i['id'] ?? i['product_id'],
                      "quantity": i['quantity'],
                      "price": i['price_pre_unit'] ?? i['price'],
                    }).toList(),
                  );} else {
                   error("Cart is Empty Please Add The Item");
                 }
                }, style:  ElevatedButton.styleFrom(
                    minimumSize: Size(double.minPositive+50, 40),
                    padding: EdgeInsets.zero,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),backgroundColor: Colors.blue),child: Text("Checkout",style: TextStyle(color: Colors.white),))
              ],
            ),
          )
        ],
      ),

    );
  }
}
