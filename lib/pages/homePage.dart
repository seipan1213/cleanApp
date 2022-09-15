import 'package:flutter/material.dart';
import 'package:rakuten_demo/firebase_options.dart';
import 'package:rakuten_demo/fragments/postPage.dart';
import 'package:rakuten_demo/pages/loginPage.dart';
import 'package:rakuten_demo/services/apiService.dart';
import '../fragments/profile.dart';
import '../fragments/timeline.dart';
import 'package:firebase_core/firebase_core.dart';
import '../fragments/cleaningSetting.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user_id});

  final String title;
  final String user_id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectIndex = 0;
  String? user_id;

  @override
  void initState() {
    super.initState();
    user_id = widget.user_id;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      PostInfo(),
      UserInfo(user_id: user_id),
      CleaningSettingForms(user_id: user_id)
    ];
    void onTapItem(int index) {
      setState(() {
        selectIndex = index;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          automaticallyImplyLeading: false,
        ),
        body: pages[selectIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => PostPage(
                  title: "Post Page",
                  user_id: user_id!,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'TimeLine',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: selectIndex,
          onTap: onTapItem,
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
