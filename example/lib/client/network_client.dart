import 'package:network_manager/Network/network_builder.dart';

class NetworkClient {
  static final NetworkClient instance = NetworkClient();
  final NetworkManager networkManager = NetworkManager("https://jsonplaceholder.typicode.com/",debugMode: true);
}
