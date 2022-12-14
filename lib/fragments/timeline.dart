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
      return Center(child: const CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                Color fill_color;
                Color border_color;
                if (postList[index].intensity! == 0) {
                  fill_color = Colors.grey[700]!;
                  border_color = Colors.grey;
                } else if (postList[index].intensity! == 1) {
                  fill_color = Colors.blue;
                  border_color = Colors.lightBlue;
                } else {
                  fill_color = Colors.red;
                  border_color = Colors.redAccent;
                }

                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: Text(
                              "@${postList[index].user_id!}",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                        Expanded(
                          flex: 3,
                          child: Text(
                            formatter.format(postList[index].created_at!),
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.right,
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postList[index].spot!,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            intensity_str[postList[index].intensity!],
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: border_color),
                            borderRadius: BorderRadius.circular(10),
                            color: fill_color,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          postList[index].comment!,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
