import 'package:flutter/material.dart';
import 'package:pigment/Widget/productPage%20.dart';


class image1 extends StatelessWidget {
  String img;
  String title;
  double size;
  String price;
  image1(this.img,this.title,this.size,this.price);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return productPage(img,title,price);
            }));
          },
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/${img}.jpg'),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

