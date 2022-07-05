import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  String message = '';
  // Dart client
  io.Socket socket = io.io(
    'http://192.168.1.28:3000/',
    // 'http://agro-teronum.com.tm:3001',
    io.OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
        .disableAutoConnect()
        .build(),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: textEditingController,
              onChanged: (value) {
                if (socket.connected) {
                  socket.emit('new_message', value);
                }
              },
            ),
            Text(
              message,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> socketInit() async {
    socket.connect();

    socket.onConnect((_) {
      print('connected');
    });

    socket.on('new_message', (data) async {
      setState(() {
        message = data;
      });
    });

    socket.onConnectError((data) {
      print(data);
      // print('connect error');
    });
    socket.onConnectTimeout((data) {
      print('connect timeout');
    });
    socket.onConnecting((data) {
      print('connecting');
    });
    socket.onReconnect((data) {
      print('reconnect');
    });
    socket.onReconnectAttempt((data) {
      print('reconnect attempt');
    });
    socket.onConnectTimeout((data) {
      print('connection timeout');
    });
    socket.onReconnectError((data) {
      print(data);
      // print('reconnect error');
    });
    socket.onDisconnect((_) {
      print('disconnected');
    });
  }
}
