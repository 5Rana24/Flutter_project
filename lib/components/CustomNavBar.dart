import 'package:flutter/material.dart';
import 'package:flutter_project/api/AuthProvider.dart';
import 'package:flutter_project/components/NotAcceptedYet.dart';
import 'package:flutter_project/view/AptRoutes/Appartment_Details_Page.dart';
import 'package:flutter_project/view/Login/ProfileForm.dart';
import 'package:flutter_project/view/MainRoutes/Booikng_screen.dart';
import 'package:flutter_project/view/MainRoutes/SearchPage.dart';
import 'package:flutter_project/view/MainRoutes/homepage.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      //Bottom Nav Bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      Homepage(token: context.read<AuthProvider>().token!),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      Scaffold(appBar: AppBar(), body: SearchPage()),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.book_online),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => BooikngScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => BooikngScreen()));
            },
          ),
        ],
      ),
    );
  }
}
