import 'package:flutter/material.dart';

List postList = [
  {'content': 'aaaaaa'},
  {'content': 'bbbbb'},
  {'content': 'cccccc'}
];

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 80,
          child: Text('USERNAME'),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postList[index % 3]['content']),
                );
              }),
        )
      ],
    );
  }
}
