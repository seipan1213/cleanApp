import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PostInfo extends StatelessWidget {
  const PostInfo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // dbアクセスを待つ処理
    // date formatting
    initializeDateFormatting('ja');
    final DateFormat formatter = new DateFormat('yyyy/MM/dd HH:mm', "ja_JP");
    String date = formatter.format(new DateTime.now());

    var postList = [
      {
        'username': 'ああああああああああああああああああ',
        'intensity': 'ちょっと頑張った',
        'spot': '風呂',
        'content': 'aaaaaa',
        'created_at': formatter.format(new DateTime.now()),
      },
      {
        'username': 'Disaster',
        'intensity': '普通に頑張った',
        'spot': 'リビング',
        'content':
            'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
        'created_at': formatter.format(new DateTime.now()),
      },
      {
        'username': 'う',
        'intensity': 'すごく頑張った！',
        'spot': 'トイレ',
        'content': 'cccccc',
        'created_at': formatter.format(new DateTime.now())
      }
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                  isThreeLine: true,
                  leading: Container(
                      width: 80,
                      child: Text(postList[index % 3]['username']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ))),
                  title: Text(
                    '場所：' + postList[index % 3]['spot']!,
                    style: TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(postList[index % 3]['intensity']! +
                      '\n${postList[index % 3]["content"]}'),
                  trailing: Text(postList[index % 3]['created_at']!,
                      style: TextStyle(fontSize: 10)),
                ));
              }),
        )
      ],
    );
  }
}
