import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:registrationpage/Screens/homescreen.dart';
import 'package:registrationpage/Screens/login_screen.dart';

class Registrationscreen extends StatefulWidget {
  const Registrationscreen({super.key});

  @override
  State<Registrationscreen> createState() => _RegistrationscreenState();
}

class _RegistrationscreenState extends State<Registrationscreen> {
  final _formkey = GlobalKey<FormState>();

  bool isloading = false;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Center(
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (item) {
                            if (item == null || !item.contains("@gmail.com")) {
                              return "Enter a valid email (must contain \"@gmail.com\")";
                            }
                            return null;
                          },
                          onChanged: (item) {
                            setState(() {
                              _email = item;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (item) {
                            if (item == null || item.length < 6) {
                              return "Password must be at least 6 characters (try including special characters and numbers also)";
                            }
                            return null;
                          },
                          onChanged: (item) {
                            setState(() {
                              _password = item;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Loginscreen()));
                              },
                              child: const Text(
                                "Login here",
                                style: TextStyle(
                                    color: Color.fromRGBO(127, 0, 255, 1)),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              signup();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: const Text("Register"),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }

  void signup() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      try {
        // Create a new user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        // Navigate to the home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Homescreen()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase exceptions
        setState(() {
          isloading = false;
        });
        String message = 'An undefined error occurred.';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        }
        Fluttertoast.showToast(msg: message);
      } catch (e) {
        // Handle any other exceptions
        setState(() {
          isloading = false;
        });
        Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      }
    }
  }
}
