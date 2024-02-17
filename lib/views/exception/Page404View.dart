import 'package:flutter/material.dart';

class Page404View extends StatefulWidget {
  const Page404View({Key? key}) : super(key: key);

  @override
  _Page404ViewState createState() => _Page404ViewState();
}

class _Page404ViewState extends State<Page404View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page404"),
      ),
      body: const Center(
        child: Text("Page404"),
      ),
    );
  }
}