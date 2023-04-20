import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_cosmos/services/db_services.dart';
import 'package:file_cosmos/services/firestore_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isLoading = false;

  File? _file;

  Future<void> _pickFiles() async {
    var _paths;
    var _directoryPath = null;
    try {
      _paths = await FilePicker.platform
          .pickFiles(allowMultiple: false)
          .then((value) {
        value!.files.forEach((element) {
          _directoryPath = element.path;
        });
      });
    } on PlatformException catch (e) {
      print('Unsupported operation$e');
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    print('This path : $_directoryPath');
    _file = File(_directoryPath);
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
                  'FileCosmos',
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
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await _pickFiles().then((value) {
                              showDialog(
                                context: context,
                                builder: (cont) {

                                  bool loading = false;
                                  // dialog for taking input of file title
                                  final _titleController =
                                      TextEditingController();
                                  return StatefulBuilder(
                                    builder: (context, setStat) {
                                      return Dialog(
                                        child: Container(
                                          height: 200,
                                          padding: const EdgeInsets.all(18),
                                          child: Center(
                                            child: loading?
                                            const CircularProgressIndicator() :
                                             Column(
                                              children: [
                                                const Text(
                                                  'Name your file',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                TextField(
                                                  controller: _titleController,
                                                  decoration: InputDecoration(
                                                      hintText: 'Enter file title',
                                                      border: OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                      )),
                                                ),
                                                const Spacer(),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.black,
                                                  ),
                                                  onPressed: () async {
                                                    setStat(() {
                                                      loading = true;
                                                    });
                                                    await DbService.uploadFile(_titleController.text,
                                                        _file!);
                                                    setStat(() {
                                                      loading = false;
                                                    });
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    Navigator.pop(cont);
                                                  },
                                                  child: const Text(
                                                    'Upload',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  );
                                });
                            });
                            setState(() {
                              _isLoading = false;
                            });
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
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: FirestoreServices().getUfiles(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.none) {
                        return Container();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No files uploaded'),
                        );
                      }

                      final _data = snapshot.data;

                      return Container(
                        child: ListView.builder(
                          itemCount: _data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _data[index]['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(255, 4, 4, 4),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          _data[index]['location'],
                                          style: const TextStyle(
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
                                                title:
                                                    const Text('Delete File'),
                                                content: const Text(
                                                    'Are you sure you want to delete this file?',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await FirestoreServices()
                                                          .deleteUfiles(
                                                              _data[index])
                                                          .then((value) =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop());
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
                      );
                    }),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
