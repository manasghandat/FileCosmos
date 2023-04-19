import 'dart:async';

import 'package:file_cosmos/services/db_services.dart';
import 'package:file_cosmos/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/file_model.dart';
// import 'package:../../models/file_model.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

// Stream of single geolocation updates.
  Stream<Position> positionStream() {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      // do what you want to do with the position here
      print(' ${position!.latitude} , ${position.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MyFile> list = [
      MyFile(
          id: "id",
          name: "Name",
          location: "location",
          coordinates: "coordinates")
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.purple.shade700,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'File Transfer',
          style: GoogleFonts.lato(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            StreamBuilder<Position>(
                stream: positionStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final position = snapshot.data;
                  print(position!.latitude);

                  return Container(
                      padding: const EdgeInsets.all(25),
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Files in your location',
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              // alignment: LexicalFocusOrder,
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<MyFile>>(
                                future: DbService().getFiles(
                                    "${position.latitude},${position.longitude}"),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.none) {
                                    return Container();
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final list = snapshot.data;

                                  return ListView.builder(
                                    itemCount: list!.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          height: 43,
                                          padding:
                                              const EdgeInsets.only(left: 18),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
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
                                                    list[index].name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromARGB(
                                                          255, 4, 4, 4),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    list[index].location,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFFbfbdbf),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Download File'),
                                                          content: const Text(
                                                              'Are you sure you want to download this file?',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await DownloadService()
                                                                    .dFile(
                                                                        list[index]
                                                                            .url!);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Download'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.get_app,
                                                    color: Color(0xFFbfbdbf),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          )
                        ],
                      ));
                }),
            const SizedBox(height: 56),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Text(
                  'Recieved Files',
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    // alignment: LexicalFocusOrder,
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 60,
                      // width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 5, 157, 99),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.insert_drive_file,
                              color: Colors.purple,
                              size: 35,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(children: [
                              Text(
                                list[index].name,
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                list[index].location,
                                style: GoogleFonts.lato(
                                  color: Color.fromARGB(125, 18, 17, 17),
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
