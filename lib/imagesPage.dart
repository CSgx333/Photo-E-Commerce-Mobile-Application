import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Widget/productPage .dart';

class imagesPage extends StatefulWidget {
  @override
  State<imagesPage> createState() => _imagesPageState();
}

class _imagesPageState extends State<imagesPage> {
  List<String> category = ["Vector","Photo", "Psd", "3D", "Icon"];
  List<String> category2 = ["vector","photo", "psd", "3d", "icon"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 115),
                Center(
                  child: Text(
                    'Images Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category.length,
                    itemBuilder: (context, index) => buildCategory(index),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29.5),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                  .collection("${category2[selectedIndex]}")
                  .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }return GridView.builder(
                      padding: EdgeInsets.only(top: 20.0),
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return productPage(
                                            document["Image"],
                                            document['Name'],
                                            document['Price']);
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
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                              child: Text(
                                document["Name"],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "${document["Price"]} ฿",
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        );
                      }
                  );
              }
              ),
            ),
          )
        ],
    );
  }

    Widget buildCategory(int index) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category[index],
                style: TextStyle(
                  fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                  color: selectedIndex == index ? Colors.black : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      );
  }
}

