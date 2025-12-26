import 'package:flutter/material.dart';
import 'package:flutter_project/api/CustomerApts.dart';
import 'package:flutter_project/components/homePage/CustomStarRate.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/favourite.dart';
import 'package:flutter_project/view/AptRoutes/Appartment_Details_Page.dart';
import 'package:flutter_project/view/DrawerRoutes/favourite_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowCategoriesHoriontal extends StatefulWidget {
  double cardWidth;
  double cardHeigth;
  String category;
   final Widget Function(double cardWidth, double cardHeight) pageBuilder;
  List<House> apts;

  ShowCategoriesHoriontal({
    required this.cardWidth,
    required this.cardHeigth,
    required this.category,
    required this.apts,
    required this.pageBuilder,
  });
  State<ShowCategoriesHoriontal> createState() => _ShowCategoriesHoriontal(
    cardWidth: this.cardWidth,
    cardHeigth: this.cardHeigth,
    category: this.category,
  );
}

class _ShowCategoriesHoriontal extends State<ShowCategoriesHoriontal> {
 
  double cardWidth;
  double cardHeigth;
  String category;
  _ShowCategoriesHoriontal({
    required this.cardWidth,
    required this.cardHeigth,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // spacing: cardWidth*0.5,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.category,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.black
                  //fontWeight: FontWeight.bold
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => widget.pageBuilder(cardWidth,cardHeigth)));
                },
                child: Text(
                  "show all",
                  style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                   color:Theme.of(context).colorScheme.secondary,
                    ),
                  
                ),
              ),
            ],
          ),
        ),
        //////////////////////////////////shows horizonatl scroll for each cate
        Container(
          width: this.cardWidth ,
          padding: EdgeInsets.all(8),
          height: this.cardHeigth * 30 / 100,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: widget.apts.isEmpty ? 0 : (widget.apts.length > 6? 6 :widget.apts.length ),
            itemBuilder: (context, i) {
              bool favState = Favourite.isFavourite(widget.apts[i]);
              return InkWell(
                onTap: () => Navigator.of(context).push(
      MaterialPageRoute(builder: (context)=>ApartmentDetailsPage(house: widget.apts[i]))),
      child:Card(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    ///////////////////////////////////PICTURE
                    Container(
                      // padding: EdgeInsets.all(10),
                      height: this.cardHeigth * 30 / 100,
                      width: this.cardWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.apts[i].fullImageUrl,
                          fit: BoxFit.cover,

                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),

                          errorWidget: (context, url, error) =>
                              Image.asset("images/Img.png", fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    ///////////////////////////////////////// //TEXT
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: widget.cardWidth * 0.5,
                        height: widget.cardHeigth * 0.1,

                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.fontSize,
                                  ),
                                  Text(
                                    "${widget.apts[i].cityName} - ${widget.apts[i].zoneName}",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              /////////////////////////////////Rate
                              CustomStarRate(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //////////////////////////////////////Fav
                    Positioned(
                      top: 15,
                      left: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            favState = !favState;
                            if (favState) {
                              Favourite.addApt(widget.apts[i]);
                            } else {
                              if (Favourite.isFavourite(widget.apts[i]))
                                Favourite.removeApt(widget.apts[i]);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // خلفية بيضاء
                            shape: BoxShape.circle, // دائري
                          ),
                          padding: EdgeInsets.all(8), // مسافة داخلية
                          child: Icon(
                            favState ? Icons.favorite : Icons.favorite_border,
                            color: favState
                                ?Theme.of(context).colorScheme.secondary
                                : Colors.grey, // أحمر عند التفعيل
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            },
          ),
        ),
        SizedBox(height: cardHeigth * 0.02),
      ],
    );
  }
}
