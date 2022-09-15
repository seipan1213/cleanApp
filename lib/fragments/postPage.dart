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
      ),
      body: Center(
        child: PostForm(
          user_id: user_id,
        ),
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
    Text('ちょっと頑張った'),
    Text('普通に頑張った'),
    Text('すごく頑張った！'),
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
    return DropdownButton<String>(
      value: spot,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
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
    );
  }

  Widget ToggleButtonsCleaningIntensity() {
    bool vertical = false;
    return ToggleButtons(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          selectedIntensity = index;
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < _selectedintensityList.length; i++) {
            _selectedintensityList[i] = i == index;
          }
        });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.red[700],
      selectedColor: Colors.white,
      fillColor: Colors.red[200],
      color: Colors.red[400],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 80.0,
      ),
      isSelected: _selectedintensityList,
      children: intensity,
    );
  }

  Widget SwitchListTileShareFlag() {
    return SwitchListTile(
      title: const Text('isShare'),
      value: _is_share,
      onChanged: (bool value) {
        setState(() {
          _is_share = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ToggleButtonsCleaningIntensity(),
        DropdownButtonCleanSpot(),
        TextField(onChanged: (String txt) {
          comment = txt;
        }),
        SwitchListTileShareFlag(),
        ElevatedButton(
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
                    seconds: cleaningSettings[id - 1].remind_interval! + 5)),
              );
            },
            child: const Text(
              '投稿',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
