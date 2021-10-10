abstract class BaseResponseModel<T> {
  T fromJson(Map<String, dynamic> json);
}
