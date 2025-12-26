import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_project/api/CustomerApts.dart';
import 'package:flutter_project/components/CustomNavBar.dart';
import 'package:flutter_project/components/homePage/ShowAptsVertical1.dart';
import 'package:flutter_project/components/homePage/CustomDrawer.dart';
import 'package:flutter_project/components/homePage/CustomStarRate.dart';
import 'package:flutter_project/components/homePage/ShowCategoriesHoriontal.dart';
import 'package:flutter_project/components/homePage/categoriesButton.dart';
import 'package:flutter_project/data/models/HomePageModel.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/data/models/category-info.dart';
import 'package:flutter_project/view/BookingRoutes/current_booking.dart';
import 'package:flutter_project/view/DrawerRoutes/notifications_screen.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  //////////////////////what i changed
  final String token; // ✅ التوكن
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  double iconsSize = 30;
  Homepage({Key? key, required this.token}) : super(key: key);


  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> with ChangeNotifier {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomePageModel>().loadApts(mounted);
     /////////////////////////////////////////////////dont forget it
  }
  @override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      /////////////////////////////////////////////Drawer
      drawer: CustomDrawer(
        cardHeight: MediaQuery.of(context).size.height * 0.9,
        cardwidth: MediaQuery.of(context).size.width,
        iconsSize: widget.iconsSize,
        //profileImg: context.watch<UserModel>().profileImage,
        scaffoldKey: widget.scaffoldKey,
      ),
      //////////////////////////////////////////////////AppBar
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              widget.scaffoldKey.currentState!.openDrawer();
            },
            child: CircleAvatar(
              radius: widget.iconsSize,
              //backgroundImage: context.watch<UserModel>().image // إذا كان ImageProvider مثل NetworkImage , i should see it /////////////////////////////
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              color: Theme.of(context).colorScheme.primary,
              iconSize: widget.iconsSize,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
              },
              icon: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      ////////////////////////////////////Body
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, Constraints) {
              return SizedBox(
                height: Constraints.maxHeight,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //////////////////////////////////////////Categories Button on the Top for  scrolling
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.fontSize,
                            color: Colors.black,
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...context.watch<HomePageModel>().categoryList.map((cat) {
                                return Categoriesbutton(
                                  category: cat.name,
                                  imageUrl: cat.image,
                                  widthScreen: Constraints.maxWidth,
                                  heightScreen: Constraints.maxHeight,
                                  onTap: () => scrollTo(cat.sectionKey),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                       ////////////////////////////////////////////////// //categories cards horizontal without All
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: context.watch<HomePageModel>().categoryList.length-1,
                          itemBuilder: (context, i) {
                            return Container(
                              key: context.watch<HomePageModel>().categoryList[i+1].sectionKey,
                              child: ShowCategoriesHoriontal(
                                category: context.watch<HomePageModel>().categoryList[i+1].name,
                                cardWidth: Constraints.maxWidth,
                                cardHeigth: Constraints.maxHeight,
                                apts: context.watch<HomePageModel>().categoryList[i+1].apts,
                                pageBuilder: context.watch<HomePageModel>().categoryList[i+1].pageBuilder,
                              ),
                            );
                          },
                        ),
                        ///////////////////////////////////////////////////////////////All  displayed in vertical cards
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            context.watch<HomePageModel>().categoryList[0].name,
                            key: context.watch<HomePageModel>().categoryList[0].sectionKey,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.fontSize,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: context.watch<HomePageModel>().categoryList[0].apts.length,
                          itemBuilder: (context, i) {
                            print("${context.watch<HomePageModel>().categoryList[0].apts[i].toString()}");
                            return ShowAptsVertical1(
                              cardHeight: Constraints.maxHeight,
                              cardWidth: Constraints.maxWidth,
                              apt: context.watch<HomePageModel>().categoryList[0].apts[i],
                              classPremission: false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(left: 20, right: 20, bottom: 20, child: CustomNavBar()),
        ],
      ),
    );
  }
}

void scrollTo(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
