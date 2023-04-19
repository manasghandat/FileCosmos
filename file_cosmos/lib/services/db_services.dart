// localhost backend based db service
import 'dart:convert';
import 'dart:io';
import 'package:file_cosmos/models/file_model.dart';
import 'package:file_cosmos/services/firestore_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class DbService {
  static const base_url = 'http://10.38.1.163:8080';

  static Future<List<dynamic>> get(String path) async {
    var url = Uri.parse('$base_url/$path');
    var response = await HttpClient().getUrl(url);
    var responseBody = await response.close();
    var responseString = await responseBody.transform(utf8.decoder).join();
    return jsonDecode(responseString);
  }

  //multipart request for fileupload
  static Future uploadFile(String s, File file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$base_url/uploadFile'), // Replace with your server URL
      );
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: file.path.split('/').last);
      request.files.add(multipartFile);
      var response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        // current location
        final location = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude, location.longitude);
        final id = await FirestoreServices().addFile(
          {
            'name': s,
            'url': respStr,
            'latlong': '${location.latitude},${location.longitude}',
            'location': placemarks[0].subLocality,
          },
        );
        FirestoreServices().updateUfiles({
          'id': id,
          'name': s,
          'url': respStr,
          'latlong': '${location.latitude},${location.longitude}',
          'location': placemarks[0].subLocality,
        });
        print('File uploaded successfully');
      } else {
        print('Failed to upload file');
      }
    } catch (e) {
      print("error in uploadFile: $e");
    }
  }

  // createUser
  static Future createUser(String email, String name, String id) async {
    final Map<String, dynamic> requestBody = {
      'Name': name,
      'Email': email,
      'ID': id,
      'Ufiles': [],
      'Dfiles': []
    };

    // Convert the request body to JSON
    final String requestBodyJson = json.encode(requestBody);

    // Set the headers for the request
    final Map<String, String> headers = {
      'Content-Type': 'application/json', // Specify the content type as JSON
    };

    // Make the HTTP POST request
    final http.Response response = await http.post(
      Uri.parse('$base_url/createUser'), // Replace with your API endpoint
      headers: headers,
      body: requestBodyJson,
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print('HTTP request successful!');
      print('Response body: ${response.body}');
    } else {
      print('HTTP request failed with status code ${response.statusCode}');
    }
  }

  Future<List<MyFile>> getFiles(String coordinate) async {
    // request with body cord : coordinate
    final Map<String, dynamic> requestBody = {
      'cord': coordinate,
    };

    // Convert the request body to JSON
    final String requestBodyJson = json.encode(requestBody);

    // Set the headers for the request
    final Map<String, String> headers = {
      'Content-Type': 'application/json', // Specify the content type as JSON
    };

    // Make the HTTP POST request
    final http.Response response = await http.post(
      Uri.parse('$base_url/getFile'), // Replace with your API endpoint
      headers: headers,
      body: requestBodyJson,
    );

    if (response.statusCode == 200) {
      final respStr =  response.body;
      List<MyFile> list = [];
      final data = jsonDecode(respStr);
      for (var i = 0; i < data.length; i++) {
        list.add(MyFile(
          id: data[i]["id"],
          coordinates: data[i]["latlong"],
          location: data[i]["location"],
          name: data[i]["name"],
          url: data[i]["url"],
        ));
      }
      print(list);
      return list;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }
}
