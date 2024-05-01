import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const/data.dart';

class CustomInterceptor extends Interceptor{

  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ][${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERR][${err.requestOptions.method}] ${err.requestOptions.uri}');

    // refreshToken 없으면 에러를 던진다.
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    if(refreshToken == null){
      return handler.reject(err); // 에러를 던진다.
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh){
      final dio = Dio();
      try{
        final response = await dio.post('http://$ip/auth/token',options: Options(
            headers: {
              'authorization' : 'Bearer $refreshToken',
            }
        ));
        final accessToken = response.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization' : 'Bearer $accessToken',
        });
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final res = await dio.fetch(options); // 요청 재전송

        return handler.resolve(res);

      }catch(e){
        return handler.reject(err); // 에러를 던진다.
      }
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES][${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

}