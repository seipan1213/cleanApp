import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rakuten_demo/services/apiService.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key, required this.user_id});
  final user_id;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<Post> postList = [];

  String? user_id;
  bool isPostSet = false;
  final List<String> intensity_str = <String>[
    'ちょっと頑張った',
    '普通に頑張った',
    'すごく頑張った！',
  ];

  @override
  void initState() {
    super.initState();
    user_id = widget.user_id;
    Future(() async {
      postList = await apiService.getPosts(user_id: user_id!);
      setState(() {
        isPostSet = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja');
    final DateFormat formatter = new DateFormat('yyyy/MM/dd', "ja_JP");
    String date = formatter.format(new DateTime.now());
    // 通信処理
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 50,
            child: Center(
              child: Column(
                children: [
                  Text(
                    user_id!,
                    style: TextStyle(),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            )),
        Expanded(
          child: ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                              postList[index].user_id!,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Expanded(
                          flex: 1,
                          child: Text(
                            formatter.format(postList[index].created_at!),
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    subtitle: Text(
                      postList[index].spot! +
                          '\n' +
                          intensity_str[postList[index].intensity!] +
                          '\n' +
                          postList[index].comment!,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
