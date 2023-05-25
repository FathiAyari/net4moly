class ReportModel {
  String userId;
  String postId;
  String subject;
  DateTime date;

  ReportModel({
    required this.userId,
    required this.postId,
    required this.subject,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'postId': postId,
      'subject': subject,
      'dateTime': date.toIso8601String(),
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      userId: json['userId'],
      postId: json['postId'],
      subject: json['subject'],
      date: json['date'].toDate(),
    );
  }
}
