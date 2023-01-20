import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigment/Widget/productPage%20.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  String name = "";
  List<Map<String, dynamic>> data = [];
  bool isExcecuted = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF0f0735),
                    Color(0xFF24307a),
                  ],
                ),
              ),
            ),
            title: Card(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                    isExcecuted = false;
                  });
                  if (name == '') {
                    isExcecuted = true;
                  };
                },
              ),
            )),
        body: isExcecuted
            ? textSearch()
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("listProduct")
                    .snapshots(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;
                            if (data['Name']
                                .toString()
                                .toLowerCase()
                                .startsWith(name.toLowerCase())) {
                              return ListTile(
                                title: Text(
                                  data['Name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(
                                  "${data['Price']} ฿",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                                leading: Image(
                                  image:
                                      AssetImage('images/${data["Image"]}.jpg'),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return productPage(
                                        data["Image"],
                                        data['Name'],
                                        data['Price']);
                                  }));
                                },
                              );
                            }
                            return Container();
                          });
                },
              ));
  }
}

class textSearch extends StatelessWidget {
  const textSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 5),
            Text(
              'No image searched',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF1c0a45),
              ),
            ),
          ],
        )
      ),
    );
  }
}
