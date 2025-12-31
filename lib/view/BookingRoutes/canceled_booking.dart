import 'package:flutter/material.dart';
import 'package:flutter_project/components/Booking/AptsWithDate.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_project/data/models/HomePageModel.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:provider/provider.dart';

class CanceledBooking extends StatefulWidget {
  Map<String, List<House>> apts = {
    // "2020.5.12":[new House(), new House(), new House()],
    // "2029.4.1":[new House(), new House()]
  };
  State<CanceledBooking> createState() => _CanceledBooking();
}

class _CanceledBooking extends State<CanceledBooking> {
  String formatted(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomePageModel>();
    final userModel = context.watch<UserModel>();
    final canceledReservations = context
        .watch<UserModel>()
        .canceledReservations;
    print("${canceledReservations.toString()}");
    return Scaffold(
      appBar: AppBar(),
      body: userModel.isLoadingReservations
          ? const Center(child: CircularProgressIndicator())
          : userModel.currentReservations.isEmpty
          ? const Center(child: Text("No Canceled Reservations"))
          : LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  itemCount: canceledReservations.length,
                  itemBuilder: (context, index) {
                    final reservation = canceledReservations[index];

                    if (reservation.startDate == null ||
                        reservation.houseId == null) {
                      return const SizedBox.shrink();
                    }

                    final apt = context.read<HomePageModel>().getAptById(
                      reservation.houseId!,
                    );

                    if (apt == null) return const SizedBox.shrink();

                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 📅 التاريخ
                          Center(
                            child: Text(
                              "${formatted(reservation.startDate!)} - ${formatted(reservation.endDate!)}",
                              style: TextStyle(
                                fontSize: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.fontSize,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),

                          /// 🏠 الشقة
                          ShowAptsVertical1(
                            cardHeight: constraints.maxHeight,
                            cardWidth: constraints.maxWidth,
                            apt: apt,
                            classPremission: false,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1, // ✅ ثلث المساحة
                                  child: Text(
                                    "Id : ${reservation.id}",
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.fontSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 20,
                                  child: VerticalDivider(thickness: 1),
                                ),

                                Expanded(
                                  flex: 2, // ✅ باقي المساحة
                                  child: Text(
                                    "Status : ${reservation.status}",
                                    style: TextStyle(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.fontSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
