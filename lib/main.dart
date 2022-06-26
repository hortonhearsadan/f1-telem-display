import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:convert';
import 'globals.dart' as globals;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8000'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                // print('${snapshot.data}');
                if (snapshot.hasData) {
                  final String s = '${snapshot.data}';

                  final Map<String, dynamic> d = jsonDecode(s);

                  if (d['header']['packet_type'] == 'LapData') {
                    globals.packetData.lapData = d;
                  }
                }
                return LeaderboardWidget();
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Connect to socket',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
      _channel.sink.add("poke");
    }


  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}

class LeaderboardWidget extends StatefulWidget {
  const LeaderboardWidget({Key? key}) : super(key: key);

  @override
  State<LeaderboardWidget> createState() => _LeaderboardWidgetState();
}

class _LeaderboardWidgetState extends State<LeaderboardWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(2.0),
        itemCount: (globals.packetData.lapData["lap_data"] != null?  globals.packetData.lapData["lap_data"].length * 2 : 40),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          final title = (globals.packetData.lapData["lap_data"] != null
              ? globals.packetData.lapData["lap_data"][index]["car_position"]
              : 'no data');
          return SizedBox(
              height: 25,
              child: ListTile(title: Text('${title}'),dense: true,))
          
          ;
        });
  }
}
