import 'package:flutter/material.dart';
import 'dart:io'; // used in Platform.isIOS & Platform.isAndroid
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class SteveWebview extends StatefulWidget {
  const SteveWebview({Key? key}) : super(key: key);

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
  final String urlSteveObs =
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
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.brown,
            toolbarHeight: 18.0,
          ),
          body: SafeArea(
              child: Column(children: <Widget>[
            TextField(
              // URL address field
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
              controller: urlController,
              keyboardType: TextInputType.url,
              onSubmitted: (value) {
                var url = Uri.parse(value); // parse the input field as an URL
                if (url.scheme.isEmpty) {
                  // if it doesn't look like URL, it's a search keyword
                  url = Uri.parse("https://www.google.com/search?q=" + value);
                }
                // if it is URL, load the web page
                webViewController?.loadUrl(urlRequest: URLRequest(url: url));
              },
            ),
            Expanded(
              // area to display web content
              child: Stack(
                // stack widgets one above another
                children: [
                  InAppWebView(
                    // the web content is at the bottom of the stack
                    key: webViewKey,
                    // id key to keep state of webview widget across widget tree
                    initialUrlRequest:
                        // URLRequest(url: Uri.parse("https://inappwebview.dev/")),
                        URLRequest(url: Uri.parse(urlSteveObs)),
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
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    webViewController?.goBack();
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    webViewController?.goForward();
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
              ],
            ),
          ]))),
    );
  }
}
