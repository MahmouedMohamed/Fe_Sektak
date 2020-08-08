import 'package:fe_sektak/api_callers/notification_api.dart';
import 'package:fe_sektak/session/session_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fe_sektak/models/notification.dart';
import 'main_screen.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationApi apiCaller = new NotificationApi();
  final SessionManager sessionManager = new SessionManager();
  static final id = 'Notification_Screen';
  Future<List<CustomNotification>> getNotifications() async {
    List<CustomNotification> requests = await apiCaller
        .getAll(userData: {'userId': sessionManager.getUser().id});
    return requests;
  }
  Widget showNotification() {
    return FutureBuilder<List<CustomNotification>>(
      future: getNotifications(),
      builder: (BuildContext context, AsyncSnapshot<List<CustomNotification>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          List<CustomNotification> notifications = new List<CustomNotification>();
          notifications = snapshot.data;
          return showBody(notifications);
        } else if (snapshot.error != null) {
          return Container(
            alignment: Alignment.center,
            child: Text(
                'Error Showing Requests, Please Restart ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 30,
              animating: true,
            ),
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Notifications'),
          leading: BackButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, MainPage.id);
            },
          ),
        ),
        body: showNotification());
  }
  Widget showBody(List<CustomNotification> notifications) {
    return Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(color: Colors.white),
        height: double.infinity,
        child: ListView(
            children: notifications.map((notification) {
              return Card(
                  color: notification.readAt!=null? Colors.white: Colors.grey.withOpacity(0.2),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ListTile(
                    title: Text(
                      '${notification.type} from ${notification.notifyingUser}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text('${notification.createdAt.toLocal()}'),
                    trailing: SizedBox(),

                  ));
            }).toList()));
  }
}
