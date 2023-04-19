import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DownloadService {
  // Future downloadFile(String url, String filename) async {
  //   try {
  //     var dir = await getTemporaryDirectory();

  //     final dio = Dio();
  //     print(url);
  //     print(dir);
  //     const filen = "kashif.jpg";
  //     // final fName = url.split('/').last;
  //     // final f = await File('${dir!}/$fName').create(recursive: true);
  //     await dFile(url, '$dir/$filen');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> dFile(String downloadUrl) async {
    try {
      final name = downloadUrl.split('?').first.split('/').last;

      final path = await getDownloadPath();
      print(name);
      // print(url);
      // final http.StreamedResponse response =
      //     await http.Client().send(http.Request('GET', Uri.parse('$url?alt=media')));
      final user = FirebaseAuth.instance.currentUser!.displayName;
      final tim = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$user';
      final response =
          await Dio().download(downloadUrl, '$path/$fileName/$name');
      
      OpenFile.open('$path/$fileName/$name');
      print(response);
      // final file = File(savePath);
      // final sink = file.openWrite();
      // int downloaded = 0;

      // response.stream.listen((data) {
      //   downloaded += data.length;
      //   sink.add(data);
      //   // Calculate download progress here
      //   double progress = downloaded / response.contentLength!;
      //   print('Download progress: ${(progress * 100).toStringAsFixed(2)}%');
      // }, onDone: () async {
      //   await sink.close();
      //   print('File downloaded successfully');
      // });
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
