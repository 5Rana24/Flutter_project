import 'package:flutter/material.dart';
import 'package:flutter_project/api/CustomerApts.dart';
import 'package:flutter_project/data/models/House.dart';
import 'package:flutter_project/data/models/category-info.dart';

class HomePageModel extends ChangeNotifier {
  final List<CategoryInfo> categoryList = [];
  bool _loaded =
      false; //not to download the apts over again & again Just when i open the app
  //new House(),new House(),new House()
  List<House> allApts = [new House(), new House(), new House()];
  List<House> aptsSortedByPrice = [];
  List<House> aptsSortedByRate = [];
  

  void loadApts(bool mounted, String token) async {
    if (_loaded) return; // ✅ يمنع إعادة التحميل
    _loaded = true;
    print("loadApts homepage");
    Customerapts service = Customerapts();
    List<House> list = await service.getAllApts(token);

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
    allApts.clear();
    allApts.addAll(list);
    sortApts();
    categoryList.clear();
    categoryList.addAll([
      CategoryInfo(name: "All", image: "images/all.png", apts: allApts),
      CategoryInfo(
        name: "Top Rated",
        image: "images/top-rated.png",
        apts: aptsSortedByRate,
      ),
      CategoryInfo(
        name: "Min Prices",
        image: "images/min-price.png",
        apts: aptsSortedByPrice,
      ),
    ]);
    notifyListeners();
  }

  House? getAptById(int id) {
    try {
      return allApts.firstWhere((apt) => apt.id == id);
    } catch (e) {
      return null; // في حال لم يتم العثور على الشقة
    }
  }

  void sortApts() {
    //min price to max
    aptsSortedByPrice = List<House>.from(allApts)
      ..sort((a, b) => a.price!.compareTo(b.price!));

    // by rating & it could be not rated yet
    aptsSortedByRate = List<House>.from(allApts)
      ..sort((a, b) {
        final rateA = a.ratingAvg;
        final rateB = b.ratingAvg;

        if (rateA == null && rateB == null) return 0;
        if (rateA == null) return 1; // A come aft B
        if (rateB == null) return -1; // A come bef B
        return rateB.compareTo(rateA); // Top rated first
      });
    notifyListeners();
  }
}
