import 'package:flutter/material.dart';
import 'fragments/profile.dart';
import 'fragments/timeline.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cleaning Reminder',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(title: 'Cleaning Reminder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      PostInfo(),
      UserInfo(),
      Text('aaaaaaa'),
    ];
    void onTapItem(int index) {
      setState(() {
        selectIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: pages[selectIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
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
    );
  }
}




// required widgets
// foating button→onpushでページ遷移→form表示
// PostList→ListViewを継承した投稿表示用 Widget
// FooterNavigation→Footerの切り替えbutton
//  button onTapの処理→対応画面の描画(Navigator?)
//  _pagesにそれぞれのページのWidgetを入れ込む→NavigationBarによって状態を遷移させることで
//  _pagesに入れ込むwidgetについては、file単位で分ける(profileは編集も同時画面でできるようにしていい気がしてきた。)
//  