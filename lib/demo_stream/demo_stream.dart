import 'dart:async';

import 'package:flutter/material.dart';

class DemoStream extends StatefulWidget {
  const DemoStream({Key? key}) : super(key: key);

  @override
  State<DemoStream> createState() => _DemoStreamState();
}

class _DemoStreamState extends State<DemoStream> {
  late StreamController _streamController;
  late Stream _stream;
  int data = 0;

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    _stream.listen((event) {
      setState(() {
        event as int;
        data += event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _streamController.sink.add(1);
          },
        ),
        body: Center(
          child: Text("The data is added is: $data"),
        ));
  }
}

class DemoStream2 extends StatefulWidget {
  const DemoStream2({Key? key}) : super(key: key);

  @override
  State<DemoStream2> createState() => _DemoStream2State();
}

class _DemoStream2State extends State<DemoStream2> {
  late StreamController _streamController;
  late Stream _stream;
  int data = 0;

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          data++;
          _streamController.sink.add(data);
        },
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text("The data is added is: ${snapshot.data}"),
            );
          }
          return const Center(
            child: Text(
              "The data is added is: 0",
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
