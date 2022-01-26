import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';
import 'package:steve_b/steve_webview.dart';

Future main() async {
  // binding to Binary Messenger, for Flutter to call platform-specific API
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  // the usual runApp starts here
  runApp(const SteveApp());
}

class SteveApp extends StatelessWidget {
  // This widget is the root of your application.
  const SteveApp({Key? key}) : super(key: key);

  // final _groceryManager = GroceryManager();
  // final _profileManager = ProfileManager();
  @override
  Widget build(BuildContext context) {
    return /*MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _groceryManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        // TODO: Add AppStateManager ChangeNotifierProvider

      ],
      child:*/
        MaterialApp(
      title: 'Steve_B Earth Observer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SteveWebview(),
    );
  }
}
