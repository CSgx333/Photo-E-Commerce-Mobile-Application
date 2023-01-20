import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

class user extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        Center(
          child: Text(
            "My Account",
            style: TextStyle(
              fontSize: 25,
              color: Color(0xFF1c0a45),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 30),
        Image(
          image: AssetImage('images/user.png'),
        ),
        SizedBox(height: 20),
        Text(
          auth.currentUser!.email.toString(),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(30),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1, //spread radius
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 28,
                  left: 64,
                  right: 80,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.red,
                      size: 18,
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 40,
                  right: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Like Photos',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Photos in the cart',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 70,
                  right: 85,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("like")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center();
                        }
                        int like = snapshot.data!.docs.length;
                        return Text(
                          '${like}',
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("product")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center();
                        }
                        int product = snapshot.data!.docs.length;
                        return Text(
                          '${product}',
                          style: TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15),
            ),
            primary: Color(0xFF39a9ff),
          ),
          child: Text("Logout"),
          onPressed: () {
            Alert(
              context: context,
              type: AlertType.info,
              title: "Logout Complete.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MyApp();
                      }));
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  width: 120,
                )
              ],
            ).show();
          },
        ),
      ],
    );
  }
}
