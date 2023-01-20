import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigment/models/product.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class productPage extends StatefulWidget {
  String img;
  String title;
  String price;

  productPage(this.img, this.title, this.price);

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {
  final formKey = GlobalKey<FormState>();
  product myProduct = product(image: '', name: '', price: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _productCollection =
      FirebaseFirestore.instance.collection("product");
  CollectionReference _likeCollection =
      FirebaseFirestore.instance.collection("like");
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/${widget.img}.jpg'),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            left: 30,
            top: 10 + MediaQuery.of(context).padding.top,
            child: ClipOval(
              child: Container(
                height: 42,
                width: 41,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 40,
                      right: 40,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Color(0xFF1c0a45),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: toggle
                              ? Icon(
                                  Icons.favorite,
                                  size: 35,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 35,
                                ),
                          onPressed: () {
                            setState(() {
                              toggle = !toggle;
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Added as a favorite image",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      await _likeCollection.add({
                                        "Image": myProduct.image = widget.img,
                                        "Name": myProduct.name = widget.title,
                                        "Price": myProduct.price =
                                            widget.price.toString(),
                                      });
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 40,
                      right: 40,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 23,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1c0a45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 40,
                      right: 40,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'Limited Image',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      left: 40,
                      right: 150,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1c0a45),
                            ),
                          ),
                        ),
                        Text(
                          "size",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1c0a45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 40,
                      right: 73,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.price} ฿",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1c0a45),
                            ),
                          ),
                        ),
                        Text(
                          "1920 x 1080",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF1c0a45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 40,
                      right: 73,
                    ),
                    child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
                      " Lorem Ipsum has been the industry's dtandard dummy text ever since. "
                      "When an unknown printer took a show.",
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF1c0a45),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.07),
                            offset: Offset(0, -3),
                            blurRadius: 12),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 5.0),
                        Column(
                          children: [
                            SizedBox(height: 15),
                            SizedBox(
                              width: 170.0,
                              height: 42.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  Alert(
                                    context: context,
                                    type: AlertType.success,
                                    title: "Image have been add to the cart",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () async {
                                          await _productCollection.add({
                                            "Image": myProduct.image =
                                                widget.img,
                                            "Name": myProduct.name =
                                                widget.title,
                                            "Price": myProduct.price =
                                                widget.price.toString(),
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                },
                                child: Text(
                                  "+ Add to Cart",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF39a9ff),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                        SizedBox(width: 5.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
