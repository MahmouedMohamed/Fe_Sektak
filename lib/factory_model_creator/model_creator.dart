import 'package:fe_sektak/models/car.dart';
import 'package:fe_sektak/models/meet_point.dart';
import 'package:fe_sektak/models/notification.dart';
import 'package:fe_sektak/models/request.dart';
import 'package:fe_sektak/models/ride.dart';
import 'package:fe_sektak/models/user.dart';
import 'package:flutter/material.dart';

class ModelCreator {
  User getUserFromJson(json) {
    return new User(
      id: json['id'].toString(),
      nationalId: json['nationalId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      rate: double.parse(json['profile']['rate'].toString()),
      numberOfServices: int.parse(json['profile']['services'].toString()),
      totalReview: double.parse(json['profile']['totalReview'].toString()),
      car: json['car'] == null || json['car'] == 'null' ? null : getCarFromJson(json['car']),
      uPhoto: json['profile']['picture'].toString(),
    );
  }

  Car getCarFromJson(json) {
    return Car(
      json['license'],
      json['carModel'],
      json['color'],
      json['userLicense'],
    );
  }

  List<CustomNotification> getNotificationsFromJson(json) {
    List<CustomNotification> notifications = new List<CustomNotification>();
    json['notifications'].forEach((notification) {
      notifications.add(CustomNotification(
          notifyingUser: notification['data']['user'].toString(),
          eventId: notification['data']['requestId'] == null
              ? notification['data']['rideId'].toString()
              : notification['data']['requestId'].toString(),
          type: notification['type'].split('\\')[2],
          readAt: notification['read_at'] != null
              ? DateTime.parse(notification['read_at'])
              : null,
          createdAt: DateTime.parse(notification['created_at'])));
    });
    return notifications;
  }

  TimeOfDay getTime(time) {
    List<String> array = time.toString().split(':');
    return TimeOfDay(hour: int.parse(array[0]), minute: int.parse(array[1]));
  }

  List<Ride> getRidesFromJson(json) {
    List<Ride> rides = new List<Ride>();
    json.forEach((ride) {
      rides.add(new Ride(
          startPointLatitude: ride['startPointLatitude'],
          startPointLongitude: ride['startPointLongitude'],
          endPointLatitude: ride['destinationLatitude'],
          endPointLongitude: ride['destinationLongitude'],
          availableSeats: ride['availableSeats'],
          rideTime: getTime(ride['time']),
          rideId: ride['id'].toString(),
          available: ride['available'] == 1 ? true : false,
          driver: User(id: ride['user_id'].toString())));
    });
    return rides;
  }

  List<Request> getRequestsFromJson(json) {
    List<Request> returnedRequests = new List<Request>();
    json.forEach((request) {
      returnedRequests.add(new Request(
        requestId: request['id'].toString(),
        rideId: request['ride_id'].toString(),
        passenger: User(id: request['user_id'].toString()),
        response: request['response'] == 0 ? false : true,
        meetPoint: getMeetPointFromJson(request),
        endPointLatitude: request['destinationLatitude'],
        endPointLongitude: request['destinationLongitude'],
        numberOfNeededSeats: request['neededSeats'],
      ));
    });
    return returnedRequests;
  }

  MeetPoint getMeetPointFromJson(json) {
    return new MeetPoint(
      latitude: json['meetPointLatitude'],
      longitude: json['meetPointLongitude'],
      meetingTime: getTime(json['time']),
    );
  }
}
