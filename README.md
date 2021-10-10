
## Features

With Network Manager, you can now easily manage your internet requests, send and receive data.


## Usage

#### home_services.dart
```dart
import 'package:network_manager/Network/Error/network_error.dart';
import 'package:network_manager/Network/Result/network_result.dart';
import '../../../client/network_client.dart';
import '../model/home_model.dart';

class HomeServices {
  Result<List<HomeModel>, NetworkError> result = const Result.success([]);

  Future<void> getHomeList() async {
    Future.delayed(const Duration(seconds: 1));
    final response = await NetworkClient.instance.networkManager
        .setGET()
        .setPath("posts")
        .execute<HomeModel, List<HomeModel>>(HomeModel());
    result = response;
  }
}

```

#### home_model.dart
```dart
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

```



#### home_screen.dart
```dart
import 'package:flutter/material.dart';

import '../services/home_services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeServices homeServices = HomeServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Example Network Manager"),
        ),
        body: FutureBuilder(
          future: homeServices.getHomeList(),
          builder: (context, snapshot) => homeServices.result.when(
            success: (data) {
              return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].title ?? ""),
                  subtitle: Text(data[index].body ?? ""),
                ),
                itemCount: data.length,
              );
            },
            failure: (error) {
              return Text(error.toString());
            },
          ),
        ));
  }
}
```


#### network_client.dart
```dart
import 'package:network_manager/Network/network_builder.dart';

class NetworkClient {
  static final NetworkClient instance = NetworkClient();
  final NetworkManager networkManager = NetworkManager("https://jsonplaceholder.typicode.com/",debugMode: true);
}
```

# ScreenShot
![](https://meetmighty.com//codecanyon/document/mightynews/images/ic_logo.png)




## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
