import 'package:flutter/material.dart';
import 'package:flutter_project/components/PageShowcards.dart';
import 'package:flutter_project/data/models/House.dart';

class CategoryInfo extends ChangeNotifier {
  final String name;
  final String image;
  final List<House> apts;
  final GlobalKey sectionKey;
  //final Widget Function(double cardWidth, double cardHeight) pageBuilder;

  CategoryInfo({
    required this.name,
    required this.image,
    //required this.pageBuilder,
    required this.apts,
  }) : sectionKey = GlobalKey();

  Widget pageBuilder(double cardWidth, double cardHeight) {
    return Scaffold(
      appBar: AppBar(),
      body: PageShowcards(
        cardHeight: cardHeight,
        cardwidth: cardWidth,
        apts: apts,
        msg: "Not found",
      ),
    );
  }
}
