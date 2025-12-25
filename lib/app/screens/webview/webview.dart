import 'package:flutter/material.dart';
import 'package:my_artist_demo/app/widgets/custom_app_bar.dart';
import 'package:my_artist_demo/base.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, this.url, this.title});

  final String? url, title;

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends Base<WebViewScreen> {
  late String url;
  late final WebViewController _controller;
  double progress = 0;
  int index = 1;

  @override
  void initState() {
    super.initState();
    url = widget.url!;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..runJavaScript(
          "document.getElementsByTagName('header')[0].style.display='none'")
      ..runJavaScript(
          "document.getElementsByTagName('footer')[0].style.display='none'")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            showLoading();
          },
          onPageFinished: (String url) {
            Future.delayed(const Duration(seconds: 1), () {
              hideLoading();
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            else if(request.url.contains("mailto:")) {
              launchURL(request.url);
              return NavigationDecision.prevent;
            } else if (request.url.contains("tel:")) {
              launchURL(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: widget.title.toString().isNotEmpty
              ? CustomAppBar(title: widget.title) : null,

          body: Column(
            children: [
              // progress < 1
              //     ? Container(
              //         child: LinearProgressIndicator(
              //         value: progress,
              //         color: ColorConstants.android_blue_dark,
              //       ))
              //     : Container(),
              Expanded(
                child:

                WebViewWidget(controller: _controller),
                // WebView(
                //   initialUrl: url,
                //   javascriptMode: JavascriptMode.unrestricted,
                //   onWebViewCreated: (WebViewController webViewController) {
                //     _controller = webViewController;
                //   },
                //   onProgress: (int progress) {
                //     // setState(() {
                //     //   this.progress = progress / 100;
                //     // });
                //   },
                //   onPageStarted: (value) {
                //     showLottieLoading();
                //   },
                //   onPageFinished: (value) {
                //     // _controller
                //     //     .evaluateJavascript('fromMobile("From Flutter")');
                //     _controller.runJavascript(
                //         "document.getElementsByClassName(\"zGVn2e\")[0].style.display='none';");
                //     Future.delayed(const Duration(seconds: 1), () {
                //       hideLottieLoading();
                //     });
                //   },
                //   javascriptChannels: <JavascriptChannel>{
                //     _toasterJavascriptChannel(context),
                //   },
                //   gestureNavigationEnabled: true,
                //   navigationDelegate: (NavigationRequest request) {
                //     if(request.url.contains("mailto:")) {
                //       launchURL(request.url);
                //       return NavigationDecision.prevent;
                //     } else if (request.url.contains("tel:")) {
                //       launchURL(request.url);
                //       return NavigationDecision.prevent;
                //     }
                //     return NavigationDecision.navigate;
                //   },
                // ),
              ),
            ],
          )),
    );
  }

}



