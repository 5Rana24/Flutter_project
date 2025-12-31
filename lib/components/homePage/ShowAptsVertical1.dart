import 'package:flutter/material.dart';
import 'package:flutter_project/api/CustomerApts.dart';
import 'package:flutter_project/components/homePage/CustomStarRate.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/User.dart';
import 'package:flutter_project/data/models/favourite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_project/view/AptRoutes/Appartment_Details_Page.dart';
import 'package:flutter_project/view/DrawerRoutes/favourite_screen.dart';
import 'package:provider/provider.dart';

class ShowAptsVertical1 extends StatefulWidget {
  double cardWidth;
  double cardHeight;
  House apt;
  bool classPremission;
  ShowAptsVertical1({
    required this.cardHeight,
    required this.cardWidth,
    required this.apt,
    required this.classPremission,
  });
  House getApt() {
    return apt;
  }

  State<ShowAptsVertical1> createState() => _ShowAptsVertical1();
}

class _ShowAptsVertical1 extends State<ShowAptsVertical1> {
  final String baseUrl = Customerapts.baseUrl;

  String resolveImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return "";
    }

    // إذا الرابط كامل من الإنترنت
    if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
      return imagePath;
    }

    // غير ذلك → رابط من السيرفر
    return "$baseUrl$imagePath";
  }

  @override
  Widget build(BuildContext context) {
    bool favState = context.watch<UserModel>().isFavourite(widget.getApt());
    return Container(
      margin: EdgeInsets.all(10),
      width: widget.cardWidth,
      height: widget.cardHeight * 0.20, // ارتفاع البطاقة
      child: Card(
        child: Stack(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ApartmentDetailsPage(house: widget.apt),
                ),
              ),
              child: Row(
                children: [
                  // الصورة
                  Container(
                    // padding: EdgeInsets.all(10),
                    width: widget.cardWidth * 0.30, // عرض الصورة
                    height: widget.cardHeight * 0.20, // ارتفاع الصورة
                    child: CachedNetworkImage(
                      imageUrl: widget.apt.fullImageUrl,
                      fit: BoxFit.cover,

                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),

                      errorWidget: (context, url, error) =>
                          Image.asset("images/Img.png", fit: BoxFit.cover),
                    ),
                  ),

                  ////////////////////////////////////////CityName-Zone
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 5),

                              Expanded(
                                child: Text(
                                  "${widget.apt.cityName} - ${widget.apt.zoneName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis, // ...
                                  softWrap: false, // يمنع النزول لسطر جديد
                                  style: TextStyle(
                                    fontSize: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          /////////////////////////////////////show Price
                          RichText(
                            text: TextSpan(
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall, // ستايل عام
                              children: [
                                TextSpan(
                                  text: "${widget.apt.price!.floor()} ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ), // فقط الرقم Bold
                                ),
                                TextSpan(
                                  text: "SYP/day",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall, // الباقي عادي
                                ),
                              ],
                            ),
                          ),
                          //////////////////////////////////////////////////////Rate
                          Align(
                            alignment: Alignment.bottomRight,

                            child: Row(
                              children: [
                                Text(
                                  "${widget.apt.ratingAvg==null? "Not Rated Yet" : widget.apt.ratingAvg.toString()}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Icon(Icons.star, color: Colors.yellow),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //////////////////////////FAV Icon
            Positioned(
              top: 15,
              left: 12,
              child: GestureDetector(
                onTap: () {
                  if (favState) {
                    context.read<UserModel>().removeFromFavourite(widget.apt);
                  } else {
                    context.read<UserModel>().addToFavourite(widget.apt);
                  }
                  // setState(() {
                  //   favState = !favState;
                  //   //clicked fav so added to favLIst
                  //   if (favState) {
                  //     Favourite.addApt(widget.apt);
                  //   }
                  //   //two cases
                  //   else {
                  //     //was fav but i clicked on unfav
                  //     setState(() {
                  //       if (Favourite.isFavourite(widget.apt)) {
                  //         Favourite.removeApt(widget.apt);
                  //         if (widget.classPremission)
                  //           Navigator.of(context).pushReplacement(
                  //             MaterialPageRoute(
                  //               builder: (context) => FavouriteScreen(
                  //                 cardHeight: widget.cardHeight,
                  //                 cardwidth: widget.cardWidth,
                  //               ),
                  //             ),
                  //           );
                  //       }
                  //     });
                  //     // wasnot fav and i click add it to fav  => do nothing just show it
                  //   }
                  // });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // خلفية بيضاء
                    shape: BoxShape.circle, // دائري
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    favState ? Icons.favorite : Icons.favorite_border,
                    color: favState
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
