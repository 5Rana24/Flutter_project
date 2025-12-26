import 'package:flutter/material.dart';
import 'package:flutter_project/api/AuthProvider.dart';
import 'package:flutter_project/api/api_service.dart';
import 'package:flutter_project/data/models/UserModel.dart';
import 'package:flutter_project/view/DrawerRoutes/Settings.dart';
import 'package:flutter_project/view/DrawerRoutes/favourite_screen.dart';
import 'package:flutter_project/view/Login/ProfileForm.dart';
import 'package:flutter_project/view/Login/loginscreen.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  double iconsSize;
  ///ImageProvider profileImg;
  GlobalKey<ScaffoldState> scaffoldKey;
  double cardwidth;
  double cardHeight;
  CustomDrawer({
    required this.iconsSize,
   // required this.profileImg,
    required this.scaffoldKey,
    required this.cardHeight,
    required this.cardwidth,
  });

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.bodySmall;
    var iconColor = Theme.of(context).colorScheme.secondary;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: iconsSize * 2,
                  height: iconsSize * 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("images/Img.png"),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      "Firstname",
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodySmall!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text("Show Profile", style: textTheme),
              leading: Icon(Icons.person, color: iconColor),
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>));
              },
            ),
            ListTile(
              title: Text("Favorite", style: textTheme),
              leading: Icon(Icons.favorite, color: iconColor),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(
                      cardHeight: cardHeight,
                      cardwidth: cardwidth,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Settings", style: textTheme),
              leading: Icon(Icons.settings, color: iconColor),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              title: Text("Log Out", style: textTheme),
              leading: Icon(Icons.logout, color: iconColor),
              onTap: () {
                showLogoutDialog(context,context.read<AuthProvider>().token!);
              
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext rootContext, String token) {
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                const Text(
                  'تأكيد تسجيل الخروج',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('إلغاء'),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogContext); // اغلق الـ dialog فقط
                        await handleLogout(
                          rootContext,
                          token,
                        ); // ✅ context الصحيح
                      },
                      child: const Text('تسجيل الخروج'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
   Future<void> handleLogout(BuildContext context, String token) async {
  // 1️⃣ انتقل فورًا إلى صفحة Login
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (route) => false,
  );

  // 2️⃣ بعدها نفّذ logout في الخلفية (best effort)
  try {
    await ApiService.logout(token);
  } catch (e) {
    // تجاهل الخطأ – المستخدم خرج بالفعل
    
  }
  if (!context.mounted) return; // ✅ أمان إضافي
}
}
