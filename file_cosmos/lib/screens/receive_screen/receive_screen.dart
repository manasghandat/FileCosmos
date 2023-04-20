import 'dart:async';

import 'package:file_cosmos/services/db_services.dart';
import 'package:file_cosmos/services/download_service.dart';
import 'package:file_cosmos/services/firestore_service.dart';
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
  final LocationSettings locationSettings = const LocationSettings(
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
      position = position;
      print(' ${position!.latitude} , ${position.longitude}');
    });
  }

  var rlist = <MyFile>[];
  var dlist = <MyFile>[];
  Position? position;

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
          'FileCosmos',
          style: GoogleFonts.lato(
            color: Colors.black,
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
                  if(snapshot.hasData){
                    position = snapshot.data;
                  }
                  if(position != null){
                  return Container(
                      padding: const EdgeInsets.all(25),
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(),
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
                                    "${position!.latitude},${position!.longitude}"),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.none) {
                                    return Container();
                                  }
                                  if (snapshot.data != null) {
                                    rlist = snapshot.data!.length > rlist.length
                                        ? snapshot.data!
                                        : rlist;
                                  }
                                  if (rlist.length > 0) {
                                    return ListView.builder(
                                      itemCount: rlist.length,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        rlist[index].name,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Color.fromARGB(
                                                              255, 4, 4, 4),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        rlist[index].location,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Color(0xFFbfbdbf),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                                                                style:
                                                                    TextStyle(
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
                                                                          rlist[index]
                                                                              .url!,
                                                                          rlist[
                                                                              index])
                                                                      .then(
                                                                          (value) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            const SnackBar(
                                                                      content: Text(
                                                                          'File Downloaded'),
                                                                    ));
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  });
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

                                  return Container();
                                }),
                          )
                        ],
                      ));
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  
                  
                }),
            const SizedBox(height: 56),
            Text(
              'Recieved Files',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                fontSize: 16,
                // alignment: LexicalFocusOrder,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: FirestoreServices().getDfiles(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.none) {
                      return Container();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data != null) {
                      if (snapshot.data!.length > dlist.length) {
                        final temp = snapshot.data!
                            .map((e) => MyFile(
                                  coordinates: e['latlong'],
                                  location: e['location'],
                                  name: e['name'],
                                  url: e['url'],
                                  id: e['id'],
                                ))
                            .toList();
                        dlist = temp;
                      }
                    }
                    return Container(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: dlist.length,
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
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dlist[index].name,
                                            style: GoogleFonts.lato(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            dlist[index].location,
                                            style: GoogleFonts.lato(
                                              color: const Color.fromARGB(
                                                  125, 18, 17, 17),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }
}
