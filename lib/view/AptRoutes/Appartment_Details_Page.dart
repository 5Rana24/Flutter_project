import 'package:flutter/material.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/view/AptRoutes/ReservationPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_project/view/AptRoutes/FeatureItem.dart';
import 'package:flutter_project/data/models/House.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class ApartmentDetailsPage extends StatefulWidget {
  late House house;
  ApartmentDetailsPage({super.key, required this.house});

  @override
  State<ApartmentDetailsPage> createState() => _ApartmentDetailsPageState();
}

class _ApartmentDetailsPageState extends State<ApartmentDetailsPage> {
  final Set<int> favorites = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Details', textAlign: TextAlign.center),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          widget.house.fullImageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "images/Img.png",
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (favorites.contains(widget.house.id)) {
                                favorites.remove(widget.house.id);
                              } else {
                                favorites.add(widget.house.id!);
                              }
                            });
                          },
                          child: Icon(
                            favorites.contains(widget.house.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favorites.contains(widget.house.id)
                                ? Colors.red
                                : Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appartment Details:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange),
                          Text(
                            "3.5",
                            // '${widget.house.rating}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Text(
                        "Descrabtion: ",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        '${widget.house.description}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),

                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Id Appartment: ",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            '${widget.house.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FeatureItem(
                            icon: Icons.meeting_room,
                            label: 'Rooms',
                            value: '${widget.house.roomsCount}',
                          ),
                          FeatureItem(
                            icon: Icons.aspect_ratio,
                            label: 'Area',
                            value: '${widget.house.area}',
                          ),
                          FeatureItem(
                            icon: Icons.location_on,
                            label: 'Location',
                            value: '${widget.house.locationDetails}',
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            "price : ",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${widget.house.price}  USD',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: MaterialButton(
                color: Colors.teal,
                onPressed: () async {
                  print("Button pressed to Book the apt");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ReservationPage(house: widget.house,)
                    ),
                  );
                },
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text('Book Now', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
