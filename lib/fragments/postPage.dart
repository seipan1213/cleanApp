import 'package:flutter/material.dart';
import 'package:rakuten_demo/pages/homePage.dart';
import 'package:rakuten_demo/services/apiService.dart';
import 'package:rakuten_demo/services/notifications_utils.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key, required this.title, required this.user_id});

  final String title;
  final String user_id;
  int _counter = 0;

  final Map<String, String> _dropDownMenu = {};

  String _selectedKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => MyHomePage(
                    title: "Home",
                    user_id: user_id!,
                  ),
                ),
              );
            }),
        automaticallyImplyLeading: false,
      ),
      body: PostForm(
        user_id: user_id,
      ),
    );
  }
}

class PostForm extends StatefulWidget {
  const PostForm({super.key, required this.user_id});
  final String user_id;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final Map<int, String?> cleanSpotList = <int, String?>{
    1: '風呂',
    2: 'リビング',
    3: 'トイレ',
  };
  final List<Widget> intensity = <Widget>[
    Center(child: Text('ちょっと\n頑張った')),
    Center(child: Text('普通に\n頑張った')),
    Center(child: Text('すごく\n頑張った！')),
  ];

  String? spot = "";
  List<bool> _selectedintensityList = <bool>[true, false, false];
  int selectedIntensity = 0;
  bool _is_share = false;
  String comment = '';
  String? user_id;
  final list = <String>[];

  @override
  void initState() {
    super.initState();
    spot = cleanSpotList[1];
    user_id = widget.user_id;
    cleanSpotList.forEach((k, v) => list.add(v!));
  }

  Widget DropdownButtonCleanSpot() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "どこを掃除した？",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          DropdownButton<String>(
            value: spot,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            // style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                spot = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget ToggleButtonsCleaningIntensity() {
    bool vertical = false;
    return ToggleButtons(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          selectedIntensity = index;
          for (int i = 0; i < _selectedintensityList.length; i++) {
            _selectedintensityList[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      constraints: BoxConstraints(
        minHeight: 50.0,
        minWidth: MediaQuery.of(context).size.width * 0.2,
      ),
      isSelected: _selectedintensityList,
      children: intensity,
    );
  }

  Widget SwitchListTileShareFlag() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              '全世界に公開する？',
              style: Theme.of(context).textTheme.titleMedium,
            )),
            Switch(
              value: _is_share,
              onChanged: (bool value) {
                setState(() {
                  _is_share = value;
                });
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                onPressed: () async {
                  final user = await apiService.getUser(user_id!);
                  final post = Post(
                    uid: user_id,
                    user_id: user.user_id,
                    is_share: _is_share,
                    comment: comment,
                    spot: spot,
                    intensity: selectedIntensity,
                    created_at: DateTime.now(),
                  );
                  await apiService.addPost(post);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => MyHomePage(
                        title: "Home",
                        user_id: user_id!,
                      ),
                    ),
                  );

                  int id;
                  for (id = 1; id <= cleanSpotList.length; id++) {
                    if (spot == cleanSpotList[id]) {
                      break;
                    }
                  }
                  List<CleaningSetting> cleaningSettings =
                      await apiService.getCleaningSettings(user_id!);

                  NotificationsUtils.cancelNotificationsSchedule(id);
                  NotificationsUtils.scheduleNotifications(
                    id,
                    DateTime.now().add(Duration(
                        seconds:
                            cleaningSettings[id - 1].remind_interval! + 5)),
                  );
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Center(
                    child: Text(
                      '掃除した',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            ToggleButtonsCleaningIntensity(),
            SizedBox(
              height: 30,
            ),
            DropdownButtonCleanSpot(),
            SwitchListTileShareFlag(),
            TextField(
              onChanged: (String txt) {
                comment = txt;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "コメント(任意)"),
              maxLength: 140,
            ),
          ],
        ),
      ),
    );
  }
}
