import 'package:flutter/material.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_project/data/models/House.dart';

class CurrentBooking extends StatefulWidget {
  State<CurrentBooking> createState() => _CurrentBooking();
}

class _CurrentBooking extends State<CurrentBooking> {
  Map<List<DateTime>, List<House>> apts = {};
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SlidableAutoCloseBehavior(
              child: Column(
                children: apts.entries.map((entry) {
                  String date = entry.key.toString();
                  List<House> aptsInDate = entry.value;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                date,
                                style: TextStyle(
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontSize,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 25.0,
                                  bottom: 25.0,
                                  right: 20.0,
                                ),
                                child: Divider(
                                  thickness: 1, // سمك الخط
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary, // لون الخط
                                  height: 20, // المسافة حول الـ Divider)
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: aptsInDate.length,
                          itemBuilder: (context, i) {
                            return Slidable(
                              key: ValueKey(i),

                              // السحب من اليمين لليسار فقط
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio:
                                    0.6, // نسبة المساحة المكشوفة (60% من عرض الكارد)

                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // تنفيذ Adjust
                                        print("Adjust pressed for apt $i");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Adjust",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // تنفيذ Cancel
                                        print("Cancel pressed for apt $i");
                                      },
                                      child: Container(
                                        height: constraints.maxHeight,
                                        width: constraints.maxWidth,
                                        margin: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // الكارد نفسه
                              child: ShowAptsVertical1(
                                cardHeight: constraints.maxHeight,
                                cardWidth: constraints.maxWidth,
                                apt: aptsInDate[i],
                                classPremission: false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
