import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osc_client/constants/constants.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CommonWebPage extends StatefulWidget {
  final String title;
  final String url;


  CommonWebPage({Key key, this.title, this.url})
      : assert(title != null),
        assert(url != null),
        super(key: key);

  @override
  _CommonWebPageState createState() => _CommonWebPageState();
}

class _CommonWebPageState extends State<CommonWebPage> {
  bool isLoading = true;
  FlutterWebviewPlugin _flutterWebviewPlugin = FlutterWebviewPlugin();


  @override
  void initState() {
    super.initState();
    //监听url变化
    _flutterWebviewPlugin.onStateChanged.listen((state) {
      if(state.type == WebViewState.finishLoad){
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }else  if(state.type == WebViewState.startLoad){
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _appBarTitle = [
      Text(
        widget.title,
        style: TextStyle(
          color: Color(AppColors.APPBAR),
        ),
      ),
    ];
    if (isLoading) {
      _appBarTitle.add(SizedBox(
        width: 10.0,
      ));
      _appBarTitle.add(CupertinoActivityIndicator());
    }

    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        title: Row(
          children: _appBarTitle,
        ),
        iconTheme: IconThemeData(color: Color(AppColors.APPBAR)), //0412 added
      ),
      withJavascript: true,
      //允许执行js
      withLocalStorage: true,
      //允许本地存储
      withZoom: true, //允许网页缩放
    );
  }
}
