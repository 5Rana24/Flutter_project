import 'package:flutter/material.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_project/constants/Enums/reservationMode.dart';
import 'package:flutter_project/data/models/HomePageModel.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/data/models/reservation.dart';
import 'package:flutter_project/view/AptRoutes/ReservationPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_project/data/models/House.dart';
import 'package:provider/provider.dart';

class CurrentBooking extends StatefulWidget {
  State<CurrentBooking> createState() => _CurrentBooking();
}

class _CurrentBooking extends State<CurrentBooking> {
  @override
  void initState() {
    super.initState();
    // context.watch<T>() لا يقوم بتحميل البيانات من تلقاء نفسه، هو فقط يُعيد بناء الـ widget عندما تتغير البيانات التي يوفرها الـ Provider.
    // إذا كانت البيانات لم تُحمَّل بعد، فالقائمة التي تشاهدها ستكون فارغة عند أول build، ولن ترى أي شيء حتى تقوم بتحميل البيانات.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserModel>().loadUserReservations();
    });
  }

  String formatted(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomePageModel>();
    final userModel = context.watch<UserModel>();
    final currentReservations = context.watch<UserModel>().currentReservations;
    print("${currentReservations.toString()}");
    return Scaffold(
      appBar: AppBar(),
      body: userModel.isLoadingReservations
          ? const Center(child: CircularProgressIndicator())
          : userModel.currentReservations.isEmpty
          ? const Center(child: Text("No Current Reservations"))
          : LayoutBuilder(
              builder: (context, constraints) {
                return SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: currentReservations.length,
                    itemBuilder: (context, index) {
                      final reservation = currentReservations[index];

                      if (reservation.startDate == null ||
                          reservation.houseId == null) {
                        return const SizedBox.shrink();
                      }

                      final apt = context.read<HomePageModel>().getAptById(
                        reservation.houseId!,
                      );

                      if (apt == null) return const SizedBox.shrink();

                      return Slidable(
                        key: ValueKey(reservation.id),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.6,
                          children: [
                            SlidableAction(
                              onPressed: (actionContext) async {
                                print("Pressed Update");

                                // أغلق الـ Slidable
                                Slidable.of(actionContext)?.close();
                                final updated = await Navigator.push<bool>(
                                  context, // ⚠️ استخدم context الخارجي
                                  MaterialPageRoute(
                                    builder: (context) => ReservationPage(
                                      house: context
                                          .read<HomePageModel>()
                                          .getAptById(reservation.houseId!)!,
                                      mode: ReservationMode.update,
                                      reservation: reservation,
                                    ),
                                  ),
                                );

                                // 0nly if the reservation was updated
                                if (updated == true) {
                                  context
                                      .read<UserModel>()
                                      .loadUserReservations();
                                }
                                print("Update ${reservation.id}");
                              },
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              label: 'Update',
                              padding: EdgeInsets.all(10),
                            ),
                            SlidableAction(
                              onPressed: (_) {
                                print("Cancel ${reservation.id}");
                              },
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.tertiary,
                              label: 'Cancel',
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(10),
                            ),
                          ],
                        ),
                        child: Container(
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
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
                                          fontWeight: FontWeight.normal
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
                                          fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
