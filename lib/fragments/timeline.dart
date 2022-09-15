import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rakuten_demo/services/apiService.dart';

class PostInfo extends StatefulWidget {
  const PostInfo({super.key});

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  List<Post> postList = [];

  bool isPostSet = false;
  final List<String> intensity_str = <String>[
    'ちょっと頑張った',
    '普通に頑張った',
    'すごく頑張った！',
  ];

  @override
  void initState() {
    super.initState();

    Future(() async {
      postList = await apiService.getPosts();
      setState(() {
        isPostSet = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // dbアクセスを待つ処理
    // date formatting
    initializeDateFormatting('ja');
    final DateFormat formatter = new DateFormat('yyyy/MM/dd', "ja_JP");
    String date = formatter.format(new DateTime.now());

    if (isPostSet == false) {
      return const CircularProgressIndicator();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
