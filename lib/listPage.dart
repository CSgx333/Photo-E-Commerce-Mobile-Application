import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listPage extends StatefulWidget {
  const listPage({Key? key}) : super(key: key);

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  int total = 0;

  deletedata(var key) async {
    await FirebaseFirestore.instance.collection("product").doc(key).delete();
  }

  deleteAll() async {
    var collection = FirebaseFirestore.instance.collection('product');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Total() async {
    await FirebaseFirestore.instance
        .collection('product')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          total += int.parse(doc['Price']);
        });
      });
    });
    return total.toString();
  }

  @override
  initState() {
    super.initState();
    Total();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("product").snapshots(),
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
                    'There are no images in the cart',
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
                  'Images Cart',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        child: ListTile(
                          leading: Image(
                            image:
                                AssetImage('images/${document["Image"]}.jpg'),
                          ),
                          title: Text(
                            document["Name"],
                            style: TextStyle(
                              color: Color(0xFF1c0a45),
                            ),
                          ),
                          subtitle: Text(
                            '${document["Price"]} ฿',
                            style: TextStyle(
                              color: Color(0xFF726c7f),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Image removed from the cart",
                                useRootNavigator: false,
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: (){
                                      total = total - int.parse(document["Price"]);
                                      deletedata(snapshot.data!.docs[index].id);
                                      Navigator.of(context, rootNavigator: true).pop();
                                    }
                                  )
                                ],
                              ).show();
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }),
              ),
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
                    Text(
                      "Total Price : ${total} ฿",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1c0a45),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 15),
                        SizedBox(
                          width: 120.0,
                          height: 36.0,
                          child: ElevatedButton(
                            onPressed: () {
                              deleteAll();
                              Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Your payment was successful",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    width: 120,
                                  )
                                ],
                              ).show();
                            },
                            child: Text(
                              "Payment",
                              style: TextStyle(
                                fontSize: 15,
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
              ),
            ],
          );
        }
      },
    );
  }
}
