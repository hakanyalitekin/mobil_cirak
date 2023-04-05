import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  //Region - Potrait Sabitleme
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: const WebViewApp(),
          // home: Home(),
        ),
      ));
  //Enregion - Potrait Sabitleme

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> with WidgetsBindingObserver {
  late final WebViewController controller;
  // final _service = FirebaseNotificationService();  // Notification Servisi

  @override
  void initState() {
    super.initState();
    // _service.connectNotification();  // Notification Servisi
    WidgetsBinding.instance.addObserver(this);
    controller = WebViewController()
      ..enableZoom(false) // Webview zoom disable
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JS open
      ..loadRequest(
        Uri.parse('https://mobilcirak.com/firmalar'),
      );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.reload();
    }
    if (state == AppLifecycleState.paused) {
      print("HAKAN durdu");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final String isOpenDrawer = await controller.runJavaScriptReturningResult(
                  "document.getElementById('_drawerCloseHiddenForMobile').value")
              as String;
          if (isOpenDrawer == '"1"') {
            await controller.runJavaScript(
                '[].forEach.call(document.getElementsByClassName("closeButton"), function (el) {el.click()});');
            return false;
          } else if (await controller.canGoBack()) {
            await controller.goBack();
            return false;
          } else {
            return await _onWillPop(context);
          }
        },
        child: SafeArea(
            child: Scaffold(body: WebViewWidget(controller: controller))));
  }
}

//WillPopScope içerisinde .goBack olasılıgı yoksa çıkış uyarısı göstermek
Future<bool> _onWillPop(var context) async {
  return (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Çıkış'),
                content: const Text('Çıkmak istediğinize emin misiniz?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Hayır'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Evet'),
                  ),
                ]);
          }) ??
      false);
}
