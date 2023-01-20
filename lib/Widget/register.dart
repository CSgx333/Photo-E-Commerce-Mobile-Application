import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pigment/models/profile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../main.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/bg5.jpg'), fit: BoxFit.cover)),
          ),
          Positioned(
            left: 15,
            top: 10 + MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => {
                Navigator.pop(context),
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
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
              child: formRegister(),
            ),
          )
        ],
      ),
    );
  }
}

class formRegister extends StatefulWidget {
  const formRegister({Key? key}) : super(key: key);

  @override
  State<formRegister> createState() => _formRegisterState();
}

class _formRegisterState extends State<formRegister> {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwords = TextEditingController();
  TextEditingController confirmpasswords = TextEditingController();
  profile myProfile = profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: EdgeInsets.all(30),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF1c0a45),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text("Email", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: MultiValidator([
                          EmailValidator(errorText: 'Invalid email format'),
                          RequiredValidator(errorText: 'Please enter email'),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? email) {
                          myProfile.email = email!;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Password", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: passwords,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (String? value){
                          if(value!.isEmpty){
                            return 'Please enter password';
                          }
                          if(value.length < 8){
                            return "Password must be 8 characters or more";
                          }
                          return null;
                        },
                        obscureText: true,
                        onSaved: (String? password) {
                          myProfile.password = password!;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Confirm Password", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: confirmpasswords,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "Enter Confirm Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (String? value){
                          if(value!.isEmpty){
                            return "Please enter confirm password";
                          }
                          if(passwords.text!=confirmpasswords.text){
                            return "Password does not match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 45),
                      Center(
                        child: SizedBox(
                          width: 210,
                          height: 47,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5),
                              ),
                              primary: Color(0xFF39a9ff),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: myProfile.email,
                                    password: myProfile.password,
                                  );
                                  auth.signOut().then((value) {
                                    formKey.currentState?.reset();
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "The user account has been created.",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                    Navigator.pop(context);
                                  });
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                    msg: e.message.toString(),
                                    gravity: ToastGravity.TOP,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
