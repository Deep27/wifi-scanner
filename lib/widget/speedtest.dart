import 'package:flutter/material.dart';

class SpeedtestWidget extends StatelessWidget {
  final Map<String, double> _results;

  SpeedtestWidget(this._results);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'Speedtest results',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('kbps: ${_results['kilobits']}'),
                    Text('mbps: ${_results['megabits']}')
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('kBps: ${_results['kilobytes']}'),
                    Text('mBps: ${_results['megabytes']}')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
