import 'package:flutter/material.dart';
import 'dart:io';   // used in Platform.isIOS & Platform.isAndroid
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';


class SteveWebview extends StatefulWidget {
  const SteveWebview({Key? key}): super(key: key);
  @override
  _SteveWebviewState createState() => _SteveWebviewState();
}

class _SteveWebviewState extends State<SteveWebview> {
  // this key makes any widget in the widget tree access the WebView state
  final GlobalKey webViewKey = GlobalKey();

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
  final String urlSteveBGee = 'https://ibisa.users.earthengine.app/view/mekongsalinity';
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        // refresh WebView display
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
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Steve_B Earth Observer"),
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.brown,
            toolbarHeight: 18.0,
          ),
          body: SafeArea(
              child: Column(children: <Widget>[
                // the URL field is not shown in Steve_B app
                Expanded( // area to display web content
                  child: Stack( // stack widgets one above another
                    children: [
                      InAppWebView(
                        // the web content is at the bottom of the stack
                        key: webViewKey,
                        // id key to keep state of webview widget across widget tree
                        initialUrlRequest:
                        // URLRequest(url: Uri.parse("https://inappwebview.dev/")),
                        URLRequest(url: Uri.parse(urlSteveBGee)),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          // callback when webview is created
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          // callback when web page starts loading
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url!;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the Web App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          // callback when web page finishes loading
                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController.endRefreshing();
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory: (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                      // if the web page is still loading, show progress bar
                      //  on top of the webview display
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container(),
                    ],
                  ),
                ),
                // the demo button bar is not used in Steve_B app
              ]))),
    );
  }
}