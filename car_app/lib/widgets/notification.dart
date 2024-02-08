import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/cars.dart';
import 'message.dart';

class ItemNotification extends StatelessWidget {
  //TODO: change this. u might need it
  final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.224.210:2406'));

  ItemNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        builder: (context, snapshot) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasData) {
              var item = Car.fromJson(jsonDecode(snapshot.data.toString()));
              Logger().log(Level.info, item);
              message(context, item.toString(), "Car added");
            }
          });
          return const Text('');
        },
        stream: channel.stream.asBroadcastStream());
  }
}