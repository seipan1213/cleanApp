import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key, required this.title});

  final String title;
  int _counter = 0;

  final Map<String, String> _dropDownMenu = {};

  String comment = '';
  String _selectedKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ToggleButtonsCleaningIntensity(),
            DropdownButtonCleanSpot(),
            TextField(onChanged: (String txt) {
              comment = txt;
            }),
            SwitchListTileShareFlag(),
            ElevatedButton(
                onPressed: () {},
                child: const Text(
                  '投稿',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonCleanSpot extends StatefulWidget {
  const DropdownButtonCleanSpot({super.key});

  @override
  State<DropdownButtonCleanSpot> createState() =>
      _DropdownButtonCleanSpotState();
}

final List<String> cleanSpotList = <String>['風呂', 'リビング', 'トイレ'];

class _DropdownButtonCleanSpotState extends State<DropdownButtonCleanSpot> {
  String dropdownValue = cleanSpotList.first;

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
