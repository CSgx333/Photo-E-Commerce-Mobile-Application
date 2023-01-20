import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigment/Widget/image1.dart';
import 'package:pigment/Widget/image2.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Widget/productPage .dart';
import 'Widget/register.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String phoneNumber = '';
  String _launchUrl = 'https://www.facebook.com/';
  String _launchUrl2 = 'https://www.youtube.com/';

  Future<void> _launchIn(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 825,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 550.0, 0, 0),
                    child: Text(
                      'Pigment',
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xFF1c0a45),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: Text(
                      'Find and download the best high-quality',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1c0a45),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                    child: Text(
                      'photos, designs and mockups.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1c0a45),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 30),
                    GFIconButton(
                      onPressed: () {
                        _launchIn(_launchUrl);
                      },
                      icon: Icon(Icons.facebook),
                      size: GFSize.SMALL,
                      shape: GFIconButtonShape.circle,
                    ),
                    GFIconButton(
                      onPressed: () {
                        _launchIn(_launchUrl2);
                      },
                      icon: Icon(Icons.play_arrow),
                      size: GFSize.SMALL,
                      color: Colors.red,
                      shape: GFIconButtonShape.circle,
                    ),
                    GFIconButton(
                      onPressed: () {
                        showAlert(context);
                      },
                      icon: Icon(Icons.mail),
                      size: GFSize.SMALL,
                      color: Colors.black45,
                      shape: GFIconButtonShape.circle,
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg4.jpg'), fit: BoxFit.fill),
            ),
          ),
          Container(
            // Carousel
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 35, 0, 20),
                    child: Text(
                      'What do we have ?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0082ef),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'Images Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF1c0a45),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 311,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 70),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      autoPlay: true,
                    ),
                    items: [
                      image2("Vector", "images/1.jpg"),
                      image2("Photo", "images/2.jpg"),
                      image2("Psd", "images/3.jpg"),
                      image2("3D", "images/4.jpg"),
                      image2("Icon", "images/5.jpg"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Center(
                    child: Text(
                      'Images Featured',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
              Container(
                height: 560,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29.5),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("featured")
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
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 15,
                              childAspectRatio: 1.2,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
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
                                ],
                              );
                            });
                      }),
                ),
              )
            ],
          ),
          SizedBox(height: 40),
          Container(
            // Register
            height: 200,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFa5e8fa),
                  Color(0xFF425dc6),
                ],
              ),
            ),

            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 35, 0, 15),
                  child: const Text(
                    "Join Pigment",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: const Text(
                    "Register Get premium",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFe8f3ff),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: const Text(
                    "privileges for a different experience",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFe8f3ff),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Register();
                    }));
                  },
                  child: const Text("Register"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF39a9ff),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  showAlert(BuildContext context) {
    Widget submitButton = TextButton(
        child: Center(child: Text('Ok')),
        onPressed: () {
          Navigator.of(context).pop();
        });

    AlertDialog dialog = AlertDialog(
        title: Center(
          child: Text(
            '6205002352@rumail.ru.ac.th',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        actions: [submitButton]);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}
