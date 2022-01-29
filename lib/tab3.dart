/*
  Flutter 2.8.1 stable, Android Studio 2021.1 Bumblebee, Android SDK 32
  Displays tutorial screen of Steve Observer
 */
import 'package:flutter/material.dart';
import 'dart:io'; // used in Platform.isIOS & Platform.isAndroid
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Tab3 extends StatefulWidget {
  const Tab3({Key? key}) : super(key: key);
  @override
  _Tab3State createState() => _Tab3State();
}

class _Tab3State extends State<Tab3> {
  // this key makes any widget in the widget tree access the Tutorial state
  final GlobalKey tutoKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    // see all options in https://inappwebview.dev/docs/in-app-webview/webview-options/
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController; // refresh display
  String url = "";
  final String urlSteveTuto =
      'https://apps.sentinel-hub.com/eo-browser/?zoom=12&lat=41.58684&lng=-85.82676&themeId=DEFAULT-THEME&visualizationUrl=https%3A%2F%2Fcreodias.sentinel-hub.com%2Fogc%2Fwms%2Fdae04f05-3a74-4563-9faa-0d05d2f8fbeb&datasetId=GLOBAL_HUMAN_SETTLEMENT&fromTime=2018-01-01T00%3A00%3A00.000Z&toTime=2018-01-01T23%3A59%3A59.999Z&layerId=GHS-BUILT-S2&gain=1.3';
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {               // refresh WebView display
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(children: <Widget>[  // fill window with children widgets
          Expanded(
            // area to display tutorial content
            child: FutureBuilder(
              // source of the markdown text to display
                future: rootBundle.loadString('assets/machupicchu.md'),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if(snapshot.hasData) {
                    return Markdown(
                      data: snapshot.data!,
                      styleSheet: MarkdownStyleSheet(
                        h1: TextStyle(color: Colors.blue, fontSize: 30.0),
                      ),
                    );
                  }
                  return Center (
                    child: CircularProgressIndicator(),
                  );
                }
            ),
          ),
        ]),
      ),
    );
  }
}
