import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CleaningSettingForms extends StatefulWidget {
  const CleaningSettingForms({super.key, required userId});
  @override
  State<CleaningSettingForms> createState() => _CleaningSettingFormsState();
}

class _CleaningSettingFormsState extends State<CleaningSettingForms> {
  // 通信して現在の値を取得
  List<Map> data = [
    {'user_id': 'hoge', 'spot': '風呂', 'interval': '1'},
    {'user_id': 'hoge', 'spot': 'トイレ', 'interval': '1'},
    {'user_id': 'hoge', 'spot': 'リビング', 'interval': '1'},
  ];
  List<Widget> forms = [];
  @override
  void initState() {
    // TODO: implement initState
    forms = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    forms = [];
    data.forEach((element) {
      forms.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButtonCleanSpot(
            defaultValue: element['spot'],
          ),
          DropdownButtonCleaningInterval(
            defaultValue: element['interval'],
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                '投稿',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ));
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...forms],
    );
  }
}

class DropdownButtonCleanSpot extends StatefulWidget {
  final defaultValue;
  const DropdownButtonCleanSpot({super.key, this.defaultValue});
  @override
  State<DropdownButtonCleanSpot> createState() =>
      _DropdownButtonCleanSpotState();
}

final List<String> cleanSpotList = <String>['風呂', 'リビング', 'トイレ'];

class _DropdownButtonCleanSpotState extends State<DropdownButtonCleanSpot> {
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: cleanSpotList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropdownButtonCleaningInterval extends StatefulWidget {
  final defaultValue;
  const DropdownButtonCleaningInterval({super.key, this.defaultValue});

  @override
  State<DropdownButtonCleaningInterval> createState() =>
      _DropdownButtonCleaningIntervalState();
}

final List<String> cleaningIntervalList = <String>["1", "2", "3", "4"];

class _DropdownButtonCleaningIntervalState
    extends State<DropdownButtonCleaningInterval> {
  String? dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
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
}

const List<Widget> intensity = <Widget>[
  Text('ちょっと頑張った'),
  Text('普通に頑張った'),
  Text('すごく頑張った！')
];

class ToggleButtonsCleaningIntensity extends StatefulWidget {
  const ToggleButtonsCleaningIntensity({super.key});

  @override
  State<ToggleButtonsCleaningIntensity> createState() =>
      _ToggleButtonCleaningIntensityState();
}

class _ToggleButtonCleaningIntensityState
    extends State<ToggleButtonsCleaningIntensity> {
  final List<bool> _selectedintensity = <bool>[true, false, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < _selectedintensity.length; i++) {
            _selectedintensity[i] = i == index;
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
      isSelected: _selectedintensity,
      children: intensity,
    );
  }
}

class SwitchListTileShareFlag extends StatefulWidget {
  const SwitchListTileShareFlag({super.key});

  @override
  State<SwitchListTileShareFlag> createState() =>
      _SwitchListTileShareFlagState();
}

class _SwitchListTileShareFlagState extends State<SwitchListTileShareFlag> {
  bool _is_share = false;

  @override
  Widget build(BuildContext context) {
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
}
