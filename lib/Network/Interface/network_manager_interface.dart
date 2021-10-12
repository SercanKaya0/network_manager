import '../Error/network_error.dart';
import '../Result/network_result.dart';
import 'model_interface.dart';

abstract class INetworkManager {
  INetworkManager setGET();
  INetworkManager setPUT();
  INetworkManager setDELETE();
  INetworkManager setPOST();
  INetworkManager setConnectionTimeOut(int timeOut);
  INetworkManager setPath(String path);
  INetworkManager setContentType(String contentType);
  INetworkManager setLoggerRequest();
  INetworkManager setBody(Map<String, dynamic>? body);
  INetworkManager setQueryParameters(Map<String, dynamic>? queryParameters);
  INetworkManager setHeader(Map<String, dynamic>? header);
  INetworkManager setSendTimeout(int sendTimeout);
  INetworkManager setReceiveTimeOut(int receiveTimeOut);
  Future<Result<K, NetworkError>> execute<T extends BaseResponseModel, K>(
      T responseModel);
}
