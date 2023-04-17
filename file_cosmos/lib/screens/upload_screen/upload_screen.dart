import 'dart:collection';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isLoading = false;

  void _pickFiles() async {
    var _paths;
    try {
      var _directoryPath = null;
      _paths = await FilePicker.platform.pickFiles(allowMultiple: false);
    } on PlatformException catch (e) {
      print('Unsupported operation$e');
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      var _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      var _userAborted = _paths == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Upload Screen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              DottedBorder(
                dashPattern: const [10, 10],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _isLoading? const CircularProgressIndicator() : ElevatedButton(
                    onPressed: () {
                      setState(() {

                      _isLoading = true;
                      });
                      _pickFiles();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 31, 31, 31),
                      ),
                    ),
                    child: const Text(
                      'Upload file in your location',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Container(
                padding: const EdgeInsets.only(left: 18),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Uploaded Files',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 173, 173, 173),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: 200,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 43,
                          padding: const EdgeInsets.only(left: 18),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'File Title',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 4, 4, 4),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'File location',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFbfbdbf),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    // dialog for delete file

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete File'),
                                          content: const Text(
                                              'Are you sure you want to delete this file?',
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
