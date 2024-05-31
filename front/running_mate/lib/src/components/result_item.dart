import 'package:flutter/material.dart';
import 'package:running_mate/src/data/model/bluetooth_device_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ResultItem extends StatelessWidget {
  final DeviceModel data;
  final void Function(BuildContext)? remove;
  final void Function(BuildContext)? connect;
  final void Function()? move;
  const ResultItem(
      {super.key, required this.data, this.remove, this.connect, this.move});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            spacing: 2,
            padding: const EdgeInsets.all(8.0),
            onPressed: remove,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'remove',
            borderRadius: BorderRadius.circular(12.0),
          ),
          SlidableAction(
            padding: const EdgeInsets.all(8.0),
            onPressed: connect,
            backgroundColor: const Color(0xff08d0fc),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'connect',
            borderRadius: BorderRadius.circular(12.0),
          ),
        ],
      ),
      child: Card(
        color: (data.isConnected) ? Colors.lightGreen : Colors.white,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ListTile(
          onTap: move,
          leading: const Icon(
            Icons.bluetooth,
            color: Color(0xff03b6dc),
            size: 40,
          ),
          title: Text(
            (data.name.isEmpty) ? 'Known' : data.name,
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w400),
          ),
          subtitle: Text(data.id.toString()),
        ),
      ),
    );
  }
}
