import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Widget/productPage .dart';
import 'models/product.dart';

class likePage extends StatefulWidget {
  const likePage({Key? key}) : super(key: key);

  @override
  State<likePage> createState() => _likePageState();
}

class _likePageState extends State<likePage> {
  deletedata(var key) async {
    await FirebaseFirestore.instance.collection("like").doc(key).delete();
  }

  product myProduct = product(image: '', name: '', price: '');
  CollectionReference _productCollection = FirebaseFirestore.instance.collection("product");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("like").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        int dataLength = snapshot.data!.docs.length;
        if (dataLength == 0) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.clear,
                    size: 30,
                  ),
                  SizedBox(height: 9),
                  Text(
                    'There are no images you like yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1c0a45),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Column(
            children: [
              SizedBox(height: 120),
              Center(
                child: Text(
                  'Like Images',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 29.5),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("like")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              padding: EdgeInsets.only(top: 20.0),
                              itemCount: snapshot.data!.docs.length,
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return productPage(
                                                document["Image"],
                                                document["Name"],
                                                document["Price"]);
                                          }));
                                        },
                                        child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'images/${document["Image"]}.jpg'),
                                                fit: BoxFit.fill),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.shopping_cart,
                                              size: 17,
                                            ),
                                            onPressed: () => {
                                              Alert(
                                                context: context,
                                                type: AlertType.success,
                                                title:
                                                    "Image have been add to the cart",
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
                                                        "Image": myProduct.image = document["Image"],
                                                        "Name": myProduct.name = document["Name"],
                                                        "Price": myProduct.price = document["Price"].toString(),
                                                      });
                                                      deletedata(snapshot.data!.docs[index].id);
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                    },
                                                    width: 120,
                                                  )
                                                ],
                                              ).show(),
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            onPressed: () => {
                                              Alert(
                                                context: context,
                                                type: AlertType.success,
                                                title:
                                                    "Image was removed from the liked list",
                                                useRootNavigator: false,
                                                buttons: [
                                                  DialogButton(
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        deletedata(snapshot
                                                            .data!
                                                            .docs[index]
                                                            .id);
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      })
                                                ],
                                              ).show(),
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              });
                        })),
              ),
            ],
          );
        }
      },
    );
  }
}
