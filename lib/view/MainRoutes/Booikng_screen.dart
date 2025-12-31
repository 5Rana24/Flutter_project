import 'package:flutter/material.dart';
import 'package:flutter_project/components/CustomNavBar.dart';
import 'package:flutter_project/view/BookingRoutes/canceled_booking.dart';
import 'package:flutter_project/view/BookingRoutes/current_booking.dart';
import 'package:flutter_project/view/BookingRoutes/previous_booking.dart';

class BooikngScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> options = [
      [
        "Current",
        "images/current.png",
        CurrentBooking(),
        Theme.of(context).colorScheme.primary,
      ],
      [
        "Previous",
        "images/previous.jpg",
        PreviousBooking(),
        Theme.of(context).colorScheme.secondary,
      ],
      [
        "Canceled",
        "images/cancel.jpg",
        CanceledBooking(),
        Color.fromARGB(255, 145, 170, 167),
      ],
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return Container(
                          width: constraints.maxWidth * 0.2,
                          height: constraints.maxHeight * 0.2,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => options[i][2],
                                ),
                              );
                            },
                            child: Card(
                              color: options[i][3],
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: ClipRRect(
                                      child: Image.asset(
                                        options[i][1].toString(),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        options[i][0].toString(),
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(left: 20, right: 20, bottom: 20, child: CustomNavBar()),
        ],
      ),
    );
  }
}
