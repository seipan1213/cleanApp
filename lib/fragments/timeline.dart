import 'package:flutter/material.dart';

List postList = [
  {'username': 'あ', 'content': 'aaaaaa'},
  {'username': 'い', 'content': 'bbbbb'},
  {'username': 'う', 'content': 'cccccc'}
];

class PostInfo extends StatelessWidget {
  const PostInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postList[index % 3]['username']),
                  subtitle: Text(postList[index % 3]['content']),
                );
              }),
        )
      ],
    );
  }
}
