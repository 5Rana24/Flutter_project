import 'package:flutter/material.dart';
import 'package:flutter_project/api/AuthProvider.dart';
import 'package:flutter_project/api/api_service.dart';
import 'package:flutter_project/view/Login/ProfileForm.dart';
import 'package:flutter_project/view/MainRoutes/homepage.dart';
import 'package:provider/provider.dart';

class Notacceptedyet extends StatefulWidget {
  State<Notacceptedyet> createState() => _Notacceptedyet();
}

class _Notacceptedyet extends State<Notacceptedyet> {
  bool isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkApproval();
  }

  Future<void> _checkApproval() async {
    if (isChecking) return;
    isChecking = true;

    final res = await ApiService.getProfile(
      context.read<AuthProvider>().token!,
    );

    if (!mounted) return;

    if (res['data'] != null && res['data']['status'] == 'approved') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => Homepage(token: context.read<AuthProvider>().token!),
        ),
      );
    } else {
      // إعادة الفحص بعد 5 ثواني
      Future.delayed(const Duration(seconds: 5), () {
        isChecking = false;
        _checkApproval();
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "بانتظار موافقة الإدارة...",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
