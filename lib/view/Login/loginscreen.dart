import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../MainRoutes/homepage.dart';
import 'VirifingPage.dart';
import 'ProfileForm.dart';
import 'dart:io';
import 'package:flutter_project/api/AuthProvider.dart';
//import 'AuthProvider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading=false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showError('يرجى إدخال رقم الهاتف');
      return;
    }

    setState(() => isLoading = true);

    final status = await auth.login(phone);
    print("LOGIN STATUS = $status");

    setState(() => isLoading = false);

    if (status == 'pending') {
      // المستخدم ما دخل OTP
      Navigator.pushReplacementNamed(context, '/otp');

    }else if (status == 'verify') {
      final profile = await auth.getProfile();

      if (profile == null) {
        // المستخدم ما عامل بروفايل
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        // المستخدم عامل بروفايل → بانتظار الموافقة
        Navigator.pushReplacementNamed(context, '/waiting');
      }


    } else if (status == 'approved') {
      // تمت الموافقة
      Navigator.pushReplacementNamed(context, '/home');

    } else {
      _showError('حدث خطأ غير متوقع');
    }
  }






  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: SizedBox(height: 400,
                child: Image.asset("images/damas.jpg", fit: BoxFit.cover,),
              )
          ),
          Positioned(
              top: 290,
              child: Container(height: 320,
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5
                    )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text("Login",
                      style: TextStyle(fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),),

                    SizedBox(height: 40,),

                    Container(height: 30, width: 300,
                        child: Text(" Enter your  phone number :",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),)
                    ),

                    Container(height: 50, width: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F7F7),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: Text("Phone", style: TextStyle(color: Colors
                                .grey[500]),),
                            prefixIcon: Icon(Icons.phone_android_outlined,
                              color: Colors.grey[500],),
                            enabled: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal)),
                          ),
                        )
                    ),


                    SizedBox(height: 50,),
                    SizedBox(
                      height: 50,
                      child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18, color: Colors.white),),
                        onPressed:
                             handleLogin

                        ,

                      ),
                    )
                  ],),
              )

          )
        ],
      ),
    );
  }
}