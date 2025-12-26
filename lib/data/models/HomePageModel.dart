import 'package:flutter/material.dart';
import 'package:flutter_project/api/CustomerApts.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/category-info.dart';

class HomePageModel extends ChangeNotifier {
  final List<CategoryInfo> categoryList = [];
  //new House(),new House(),new House()
   List<House> apts = [new House(),new House(),new House() ];
   List<House> aptsSortedByPrice = [];
  HomePageModel() {
    categoryList.addAll([
      CategoryInfo(
        name: "All",
        image: "images/all.png",
        apts: apts,
      ),
      CategoryInfo(
        name: "Top Rated",
        image: "images/top-rated.png",
        apts: apts,
      ),
      CategoryInfo(
        name: "Top Rented",
        image: "images/top-rented2.png",
        apts: apts,
      ),
      CategoryInfo(
        name: "Min Prices",
        image: "images/min-price.png",
        apts: apts,
      ),
    ]);
    notifyListeners();
  }

  void loadApts(bool mounted) async {
    print("loadApts homepage");
    Customerapts service = Customerapts();
    List<House> list = await service.getAllApts();

    if (!mounted) return; // 🔴 الحل هنا

    //   setState() called after dispose(): _Homepage (not mounted)
    //   معناها:

    // loadApts() دالة async

    // أثناء تحميل الصفحات (واضح أنك تحمل 5 صفحات + تأخير)

    // المستخدم أو النظام:

    // غيّر الصفحة

    // أو حصل Hot Restart

    // أو تم التخلص من Widget

    // 👉 لكن بعد انتهاء await
    // تم استدعاء setState() على Widget لم يعد موجودًا
    // 🧠 لماذا mounted مهم؟

    // mounted == true → الـ Widget ما زال على الشاشة

    // mounted == false → تم التخلص منه (dispose)

    // Flutter لن يحميك تلقائيًا في async
    // أنت مسؤول عن هذا الفحص.
    print("🚀 عدد الشقق القادمة من API = ${list.length}");
    apts.clear();
    apts.addAll(list);
    notifyListeners();

  }
}
