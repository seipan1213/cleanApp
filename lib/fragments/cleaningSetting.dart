import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rakuten_demo/main.dart';
import 'package:rakuten_demo/services/apiService.dart';

class CleaningSettingForms extends StatefulWidget {
  const CleaningSettingForms({super.key, required this.user_id});
  final user_id;

  @override
  State<CleaningSettingForms> createState() => _CleaningSettingFormsState();
}

class _CleaningSettingFormsState extends State<CleaningSettingForms> {
  List<Widget> forms = [];
  List<int?> dropdownValue = [];
  final List<String> cleaningIntervalList = <String>["1", "2", "3", "4"];

  String? user_id;

  @override
  void initState() {
    // TODO: implement initState
    user_id = widget.user_id;
    forms = [];
    super.initState();
    for (final setting in cleaningSettings) {
      dropdownValue.add(setting.remind_interval);
    }
  }

  Widget DropdownButtonCleaningInterval(int id) {
    if (dropdownValue[id] == null) {
      return const CircularProgressIndicator();
    }
    return DropdownButton<String>(
      value: dropdownValue[id].toString(),
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue[id] = int.parse(value!);
        });
      },
      items: cleaningIntervalList.map<DropdownMenuItem<String>>((String value) {
        final text;
        if (value == '4') {
          text = Text('1ヶ月');
        } else {
          text = Text('${value}週間');
        }
        return DropdownMenuItem<String>(
          value: value,
          child: text,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    forms = [];
    for (int i = 0; i < cleaningSettings.length; i++) {
      final setting = cleaningSettings[i];
      forms.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(setting.spot!),
          DropdownButtonCleaningInterval(i),
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...forms,
          ElevatedButton(
              onPressed: () {
                List<CleaningSetting> settings = [
                  CleaningSetting(
                      user_uid: cleaningSettings[0].user_uid,
                      spot: cleaningSettings[0].spot,
                      remind_interval: dropdownValue[0]),
                  CleaningSetting(
                      user_uid: cleaningSettings[1].user_uid,
                      spot: cleaningSettings[1].spot,
                      remind_interval: dropdownValue[1]),
                  CleaningSetting(
                      user_uid: cleaningSettings[2].user_uid,
                      spot: cleaningSettings[2].spot,
                      remind_interval: dropdownValue[2]),
                ];
                apiService.updateCleaningSettings(settings);
                cleaningSettings = settings;
              },
              child: const Text(
                '投稿',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Divider(),
        ],
      ),
    );
  }
}
