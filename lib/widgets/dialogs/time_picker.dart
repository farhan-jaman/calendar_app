import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final bool isFrom;
  final Function(DateTime) onValueSelected;
  final DateTime time;

  const TimePicker({
    super.key,
    required this.isFrom,
    required this.onValueSelected,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    DateTime _time = time;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
      ),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isFrom ? 'From' : 'To',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              inherit: false,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: _time,
              onDateTimeChanged: (value) {
                _time = value;
              },
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  onValueSelected(_time);
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
          SizedBox(height: 24),
        ],
      )
    );
  }
}