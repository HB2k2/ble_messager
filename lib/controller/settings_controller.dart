import 'package:ble/view/widgets/common/custom_elevated_button.dart';
import 'package:ble/view/widgets/common/show_alert_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsController extends GetxController {
  final nearby = Nearby();
  var isLocationPermitted = false.obs;
  var isLocationServicesGranted = false.obs;

  updateLocationPermissionNeeded() async {
    if (await Permission.location.request().isGranted) {
      /// Location Permission is already granted
      isLocationPermitted = RxBool(true);
    } else {
      /// Location Permission is not yet granted so let's request for it
      if (await Permission.location.request().isGranted) {
        /// Location Permission is now granted
        isLocationPermitted = RxBool(true);
      } else {
        /// Location Permission is not granted
        isLocationPermitted = RxBool(false);
      }
    }
  }

  updateLocationServicesNeeded() async {
    if (await Permission.location.isGranted) {
      /// Location Services is already granted
      isLocationServicesGranted = RxBool(true);
    } else {
      /// Location Services is not yet granted so let's request for it
      if (await Permission.location.isGranted) {
        /// Location Services is now granted
        isLocationServicesGranted = RxBool(true);
      } else {
        /// Location Services is not yet granted
        isLocationServicesGranted = RxBool(false);
      }
    }
  }

  Future<void> checkLocation(BuildContext context) async {
    if (this.isLocationPermitted.value ||
        this.isLocationServicesGranted.value) {
      showLocationCheckerDialog(context);
    } else {
      showAlertDialogBox(
        context: context,
        header: 'Enable your location',
        message:
            'We need to know where you are in order to scan nearby app users in your neighborhood.',
        actionButtons: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
              showLocationCheckerDialog(context);
            },
          ),
          customElevatedButton(
            context: context,
            label: 'Enable',
            callback: () {
              requestLocation().then((_) {
                return showLocationCheckerDialog(context);
              });

              Navigator.of(context).pop();
            }, fontSize: 16,
          )
        ],
      );
    }
  }

  Future<void> requestLocation() async {
    await updateLocationPermissionNeeded();
    await updateLocationServicesNeeded();
  }

  showLocationCheckerDialog(BuildContext context) {
    showAlertDialogBox(
      context: context,
      header: 'Location Permission',
      message:
          this.isLocationPermitted.value && this.isLocationServicesGranted.value
              ? 'Location permission and service is granted. '
              : 'Location permission and service is not granted.',
      actionButtons: [
        OutlinedButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
