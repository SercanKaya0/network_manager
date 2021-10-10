import 'package:network_manager/Network/Interface/model_interface.dart';

class HomeModel extends BaseResponseModel {
  HomeModel({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  int? userId;
  int? id;
  String? title;
  String? body;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };

  @override
  fromJson(Map<String, dynamic> json) {
    return HomeModel.fromJson(json);
  }
}
