import 'package:flutter/material.dart';
import 'package:flutter_project/api/favoruite_service.dart';
import 'package:flutter_project/components/PageShowcards.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_project/data/models/HomePageModel.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/data/models/favourite.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatefulWidget {
  double cardwidth;
  double cardHeight;
  FavouriteScreen({required this.cardHeight, required this.cardwidth});
  State<FavouriteScreen> createState() => _FavouriteScreen();
}

class _FavouriteScreen extends State<FavouriteScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserModel>().loadFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allApts = context.watch<HomePageModel>().allApts;
    final favHouses =
        context.watch<UserModel>().getFavouriteHouses(allApts);
    return Scaffold(
      appBar: AppBar(),
      body: PageShowcards(
        cardHeight: widget.cardHeight,
        cardwidth: widget.cardwidth,
        apts: favHouses,
        msg: "No Favorite Apts",
      ),
    );
  }
}
