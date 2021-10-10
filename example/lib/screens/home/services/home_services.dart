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
