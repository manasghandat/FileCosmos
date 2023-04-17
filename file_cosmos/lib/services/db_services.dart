// localhost backend based db service

import 'dart:convert';
import 'dart:io';

class DbService {
  static const String _host = 'localhost';
  static const int _port = 8080;

  static Future<String> get(String path) async {
    final HttpClientRequest request = await HttpClient().getUrl(Uri(
      scheme: 'http',
      host: _host,
      port: _port,
      path: path,
    ));
    final HttpClientResponse response = await request.close();
    final String reply = await response.transform(utf8.decoder).join();
    return reply;
  }

  static Future<String> post(String path, String body) async {
    final HttpClientRequest request = await HttpClient().postUrl(Uri(
      scheme: 'http',
      host: _host,
      port: _port,
      path: path,
    ));
    request.headers.contentType = ContentType.json;
    request.write(body);
    final HttpClientResponse response = await request.close();
    final String reply = await response.transform(utf8.decoder).join();
    return reply;
  }

  static Future<String> put(String path, String body) async {
    final HttpClientRequest request = await HttpClient().putUrl(Uri(
      scheme: 'http',
      host: _host,
      port: _port,
      path: path,
    ));
    request.headers.contentType = ContentType.json;
    request.write(body);
    final HttpClientResponse response = await request.close();
    final String reply = await response.transform(utf8.decoder).join();
    return reply;
  }

  static Future<String> delete(String path) async {
    final HttpClientRequest request = await HttpClient().deleteUrl(Uri(
      scheme: 'http',
      host: _host,
      port: _port,
      path: path,
    ));
    final HttpClientResponse response = await request.close();
    final String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}