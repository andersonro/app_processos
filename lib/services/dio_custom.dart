import 'package:controle_processos/services/dio_interceptor.dart';
import 'package:dio/dio.dart';

class DioCustom {
  final _dio = Dio();

  DioCustom() {
    /*
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
        */
    _dio.options.baseUrl = "https://processos.arodevsistemas.com.br";
    _dio.interceptors.add(DioInterceptor());
  }

  Dio get dio => _dio;
}
