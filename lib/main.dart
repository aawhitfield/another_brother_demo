import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:another_brother_demo/print_api.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.more_horiz,
        activeIcon: Icons.close,
        spaceBetweenChildren: 16,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            onTap: () => _incrementCounter(),
            label: 'Increment Counter',
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            onTap: () async {
              await PrintAPI.printText(
                  context, 'You have pushed the button $_counter times');
            },
            label: 'Print text',
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            onTap: () async {
              await PrintAPI.printImage(
                  context, 'assets/logo.png');
            },
            label: 'Print image',
          ),
          SpeedDialChild(
            child: const Icon(Icons.print),
            onTap: () async {
              Directory tempDir = await getTemporaryDirectory();
              String tempPath = tempDir.path;
              File tempFile = File('$tempPath/copy.pdf');
              ByteData bd = await rootBundle.load('assets/chart.pdf');
              await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
              await PrintAPI.printPDF(
                  context, tempFile.path);
            },
            label: 'Print PDF',
          ),
        ],
      ),
    );
  }
}
