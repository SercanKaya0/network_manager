import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'Error/network_error.dart';
import 'Interface/model_interface.dart';
import 'Interface/network_manager_interface.dart';
import 'Layers/network_connectivity.dart';
import 'Layers/network_decoding.dart';
import 'Result/network_result.dart';

class NetworkManager extends INetworkManager {
  final String? _baseURL;
  String? _path;
  String? _method;
  String? _contentType;
  Map<String, dynamic>? _body;
  Map<String, dynamic>? _queryParameters;
  Map<String, dynamic>? _header;
  int? _sendTimeout;
  int? _receiveTimeOut;
  final Dio? _dio = Dio();
  int? _connectTimeout;
  Interceptor? _interceptor;
  bool? debugMode;

  NetworkManager(this._baseURL, {this.debugMode}) : assert(_baseURL != null);

  @override
  INetworkManager setGET() {
    _method = "GET";
    return this;
  }

  @override
  INetworkManager setDELETE() {
    _method = "DELETE";
    return this;
  }

  @override
  INetworkManager setPOST() {
    _method = "POST";
    return this;
  }

  @override
  INetworkManager setPUT() {
    _method = "PUT";
    return this;
  }

  @override
  INetworkManager setConnectionTimeOut(int timeOut) {
    _connectTimeout = timeOut;
    return this;
  }

  @override
  INetworkManager setPath(String path) {
    _path = path;
    return this;
  }

  @override
  INetworkManager setContentType(String contentType) {
    _contentType = contentType;
    return this;
  }

  @override
  INetworkManager setBody(Map<String, dynamic>? body) {
    _body = body;
    return this;
  }

  @override
  INetworkManager setHeader(Map<String, dynamic>? header) {
    _header = header;
    return this;
  }

  @override
  INetworkManager setQueryParameters(Map<String, dynamic>? queryParameters) {
    _queryParameters = queryParameters;
    return this;
  }

  @override
  INetworkManager setReceiveTimeOut(int receiveTimeOut) {
    _receiveTimeOut = receiveTimeOut;
    return this;
  }

  @override
  INetworkManager setSendTimeout(int sendTimeout) {
    _sendTimeout = sendTimeout;
    return this;
  }

  @override
  INetworkManager setLoggerRequest() {
    _interceptor = InterceptorsWrapper(onRequest: (option, handler) {
      Logger.root.info(option);
      handler.next(option);
    });
    return this;
  }

  @override
  Future<Result<K, NetworkError>> execute<T extends BaseResponseModel, K>(
      T responseModel) async {
    if (await NetworkConnectivity.status) {
      try {
        final response = await _dio!.fetch(RequestOptions(
          baseUrl: _baseURL ?? '',
          path: _path ?? '',
          data: _body,
          contentType: _contentType,
          headers: _header,
          method: _method,
          connectTimeout: _connectTimeout,
          receiveTimeout: _receiveTimeOut ?? 3000,
          sendTimeout: _sendTimeout ?? 3000,
          queryParameters: _queryParameters,
          validateStatus: (statusCode) => (statusCode! >= HttpStatus.ok &&
              statusCode <= HttpStatus.multipleChoices),
        ));
        var decodeResponse = NetworkDecoding.decode<T, K>(
            response: response, responseType: responseModel);

        return Result.success(decodeResponse);
      } on DioError catch (diorError) {
        if (debugMode == true) {
          // ignore: avoid_print
          print(" => ${NetworkError.request(error: diorError)}");
        }
        return Result.failure(NetworkError.request(error: diorError));

        // TYPE ERROR
      } on TypeError catch (e) {
        if (debugMode == true) {
          // ignore: avoid_print
          print("=> ${NetworkError.type(error: e.toString())}");
        }
        if (_interceptor != null) {
          _dio?.interceptors.add(_interceptor!);
        }
        return Result.failure(NetworkError.type(error: e.toString()));
      }
    } else {
      if (debugMode == true) {
        // ignore: avoid_print
        print(
            const NetworkError.connectivity(message: 'No Internet Connection'));
      }
      return const Result.failure(
          NetworkError.connectivity(message: 'No Internet Connection'));
    }
  }
}
