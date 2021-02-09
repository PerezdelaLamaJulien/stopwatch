import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsPage(title: "#Day1 of Flutter"),
    );
  }
}

class TabsPage extends StatefulWidget {
  TabsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.timer),
                text: "Chronomètre",
              ),
              Tab(
                icon: Icon(Icons.timelapse),
                text: "Minuteur",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [ChronoPage(), TimerPage()],
        ),
      ),
    );
  }
}

class ChronoPage extends StatefulWidget {
  @override
  _ChronoPageState createState() => _ChronoPageState();
}

class _ChronoPageState extends State<ChronoPage> {
  var stringTime = "00.00.00.00";
  Stopwatch _stopwatch = new Stopwatch();
  Icon timeIcon = Icon(Icons.play_arrow);
  List<String> times = [];

  void _launchTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      timeIcon = Icon(Icons.stop);
    } else {
      _stopwatch.stop();
      timeIcon = Icon(Icons.play_arrow);
    }
    Timer.periodic(Duration(milliseconds: 10), (interval) {
      setState(() {
        stringTime = _printDuration(_stopwatch.elapsed);
      });
    });
  }

  void _addTimer() {
    if (_stopwatch.isRunning && stringTime != "00.00.00.00") {
      setState(() {
        times.add(stringTime);
      });
    }
  }

  void _restart() {
    if (stringTime != "00.00.00.00") {
      setState(() {
        times.clear();
        _stopwatch.reset();
      });
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitsMilliSeconds =
        twoDigits(duration.inMilliseconds.remainder(100));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds:$twoDigitsMilliSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lancer le timer:',
          ),
          Text(
            stringTime,
            style: Theme.of(context).textTheme.headline4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(onPressed: _launchTimer, icon: timeIcon),
              IconButton(onPressed: _addTimer, icon: Icon(Icons.pause)),
              IconButton(onPressed: _restart, icon: Icon(Icons.autorenew)),
            ],
          ),
          Container(
            height: 400.0,
            child: ListView.builder(
                itemCount: times.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Center(
                    child: Text(times[index],
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.5)),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _hour, _minutes, _seconds = 0;
  Timer _timer;
  int _start = 10;

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Régler le timer:',
          ),
          Text("$_start"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NumberPicker.integer(
                  initialValue: 0,
                  minValue: 0,
                  maxValue: 10,
                  onChanged: (newValue) => setState(() => _hour = newValue)),
              new NumberPicker.integer(
                  initialValue: _start,
                  minValue: 0,
                  maxValue: 60,
                  onChanged: (newValue) => setState(() => _minutes = newValue)),
              new NumberPicker.integer(
                  initialValue: _start,
                  minValue: 0,
                  maxValue: 60,
                  onChanged: (newValue) => setState(() => _start = newValue)),
            ],
          ),
          IconButton(onPressed: _startTimer, icon: Icon(Icons.play_arrow)),
        ],
      ),
    ));
  }
}
