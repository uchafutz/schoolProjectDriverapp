import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userPhone;
  String? userName;

  TripsHistoryModel({
    this.time,
    this.originAddress,
    this.destinationAddress,
    this.status,
    this.userPhone,
    this.userName,
  });

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
    userName = (dataSnapshot.value as Map)["userName"];
  }
}
