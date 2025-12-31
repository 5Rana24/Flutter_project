import 'package:flutter/material.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_project/data/models/House.dart';

class PageShowcards extends StatefulWidget {
  double cardwidth;
  double cardHeight;
  String msg;
  List<House> apts;
  PageShowcards({
    required this.cardHeight,
    required this.cardwidth,
    required this.apts,
    required this.msg,
  });
  State<PageShowcards> createState() => _PageShowcards();
}

////////////////////////////this just to opeen an page with a msg
class _PageShowcards extends State<PageShowcards> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.apts.isEmpty
        ? Center(
            child: Text(
              widget.msg,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          )
        : ListView.builder(
            itemCount: widget.apts.length,
            itemBuilder: (context, i) {
              return Stack(
                children: [
                  ShowAptsVertical1(
                    cardHeight: widget.cardHeight,
                    cardWidth: widget.cardwidth,
                    apt: widget.apts[i],
                    classPremission: true,
                  ),
                ],
              );
            },
          );
  }
}
