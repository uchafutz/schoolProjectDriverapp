//import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:driverapp/push_notifications/notification_dialog_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../global/global.dart';
import '../models/user_ride_request_information.dart';

class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future InitialeCloudMessage(BuildContext context) async {
    //1 termination(when app complete close and open for push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //displace -user Information for Truck request
        //print("Request id by User:");
        //print(remoteMessage.data);
        //print(remoteMessage!.data["rideRequestId"]);
        UserReadRequestInformation(
            remoteMessage.data["rideRequestId"], context);
      }
    });
    //2.background
    //when app in background and open direct for push notification

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //displace -user Information for Truck request
      // print("Request id by User:");
      //print(remoteMessage!.data);
      // print(remoteMessage!.data["rideRequestId"]);
      UserReadRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });

    //3.Foreground
    //when app is open to receice push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //displace -user Information for Truck request

      //print("Request id by User:");
      // print(remoteMessage!.data);
      //  print(remoteMessage!.data["rideRequestId"]);
      UserReadRequestInformation(remoteMessage!.data["rideRequestId"], context);
    });
  }

  UserReadRequestInformation(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("TruckRequest")
        .child(userRideRequestId)
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        String originalAddress =
            (value.snapshot.value! as Map)["originalAddress"];
        double originaL = double.parse(
            (value.snapshot.value! as Map)["original"]["latitude"]);
        double originaLng = double.parse(
            (value.snapshot.value! as Map)["original"]["longitude"]);

        String destinationAddress =
            (value.snapshot.value! as Map)["destinationAddress"];
        double destinationL = double.parse(
            (value.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (value.snapshot.value! as Map)["destination"]["longitude"]);

        String Username = (value.snapshot.value! as Map)["Username"];
        String? rideRequestId = value.snapshot.key;
        String PhoneNumber = (value.snapshot.value! as Map)["PhoneNumber"];

        UserRideRequestInformation userRideRequestDetails =
            UserRideRequestInformation();
        userRideRequestDetails.originLatLng = LatLng(originaL, originaLng);
        userRideRequestDetails.destinationLatLng =
            LatLng(destinationL, destinationLng);
        userRideRequestDetails.originAddress = originalAddress;
        userRideRequestDetails.destinationAddress = destinationAddress;
        userRideRequestDetails.userName = Username;
        userRideRequestDetails.userPhone = PhoneNumber;
        userRideRequestDetails.rideRequestId = rideRequestId;

        showDialog(
            context: context,
            builder: (BuildContext context) => NotificationDialogBox(
                  userRideRequestDetails: userRideRequestDetails,
                ));
      } else {
        Fluttertoast.showToast(msg: "This Request doent Extit");
      }
    });
  }

  Future GenerateUserToken() async {
    String? RegisationToken = await messaging.getToken();
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("Token")
        .set(RegisationToken);
    messaging.subscribeToTopic("AllDrivers");
    messaging.subscribeToTopic("AllUsers");
  }
}
