class CustomNotification {
  String notifyingUser;
  String eventId;
  String type;
  DateTime readAt;
  DateTime createdAt;
  CustomNotification(
      {this.notifyingUser,
      this.eventId,
      this.type,
      this.readAt,
      this.createdAt});
}
