import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
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

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://mobilcirak.com/firmalar'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
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
