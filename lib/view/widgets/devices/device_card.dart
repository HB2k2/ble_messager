import 'dart:math' as math;
import 'package:ble/controller/devices_controller.dart';
import 'package:ble/model/device.dart';
import 'package:ble/model/message.dart';
import 'package:ble/view/pages/chat.dart';
import 'package:ble/view/widgets/common/show_alert_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final String username;
  final List<Message> messages;

  const DeviceCard({
    super.key,
    required this.device,
    required this.username,
    required this.messages,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  late bool isConnected;
  late DevicesController bleMessengerController;

  @override
  void initState() {
    super.initState();
    isConnected = widget.device.isConnected;
    bleMessengerController = DevicesController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(10, 10),
              color: Colors.black12,
            ),
          ],
        ),
        child: Card(
          color: isConnected ? Colors.blue[50] : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: InkWell(
            onTap: () {
              isConnected
                  ? Navigator.push(
                      context,
                      PageTransition(
                          child: Chat(
                            deviceId: widget.device.id,
                            deviceUsername: widget.device.name,
                            appUser: widget.username,
                          ),
                          type: PageTransitionType.fade),
                    )
                  : showAlertDialogBox(
                      context: context,
                      header: 'Note:',
                      message: 'You are not yet connected to the user.',
                      actionButtons: [
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    isConnected ? Icons.chat_rounded : Icons.person_pin_rounded,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  widget.device.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: ElevatedButton(
                  child: Text(
                    btnLabel(
                        condition: isConnected,
                        leftText: 'Disconnect',
                        rightText: 'Connect'),
                    style: TextStyle(
                      color: isConnected ? Colors.white : Colors.black54,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith(getColor),
                  ),
                  onPressed: () {
                    if (!isConnected) {
                      bleMessengerController.requestDevice(
                        requestContext: context,
                        nickname: widget.username,
                        deviceId: widget.device.id,
                        onConnectionResult: (endpointId, status) {
                          if (status.toString() == 'Status.CONNECTED') {
                            setState(() {
                              isConnected = true;
                            });
                          } else {
                            setState(() {
                              isConnected = false;
                            });
                          }
                        },
                        onDisconnected: (id) {
                          setState(() {
                            isConnected = false;
                          });
                        },
                      );
                    } else {
                      bleMessengerController.disconnectDevice(
                        id: widget.device.id,
                        updateStateFunction: () {
                          setState(() {
                            isConnected = false;
                          });
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return isConnected ? Colors.redAccent : Colors.greenAccent;
    }
    return isConnected ? Colors.red : Color(0xFF69f0ae);
  }

  String btnLabel({required bool condition, required String leftText, required String rightText}) {
    return condition ? leftText : rightText;
  }
}
