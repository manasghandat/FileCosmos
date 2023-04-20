import 'package:file_cosmos/models/file_model.dart';
import 'package:file_cosmos/services/db_services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController mapController;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MyFile>>(
          future: DbService().getAllFiles(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final list = snapshot.data;
              return MapboxMap(
                onMapClick: (point, coordinates) async {
                  for (var file in list!) {
                    await mapController.addSymbol(
                      SymbolOptions(
                        iconImage: 'assets/images/file_logo.png',
                        geometry: LatLng(
                          double.parse(file.coordinates.split(',')[0]),
                          double.parse(file.coordinates.split(',')[1]),
                        ),
                        iconSize: 0.5,
                        iconOffset: const Offset(
                          0,
                          -2,
                        ),
                      ),
                    );
                  }
                },
                onMapCreated: (MapboxMapController controller) async {
                  mapController = controller;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tap on the map to see files'),
                    ),
                  );
                },
                accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(29.867904439092197, 77.89456729138232),
                  zoom: 15.0,
                ),
              );
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
            return Container();
          }),
    );
  }
}
