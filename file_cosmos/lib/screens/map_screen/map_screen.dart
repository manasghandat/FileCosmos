import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMapController mapController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        onMapCreated: (MapboxMapController controller) async {
          mapController = controller;

          await mapController.addSymbol(
            const SymbolOptions(
              iconImage: 'assets/images/file_logo.png',
              geometry: LatLng(29.867904439092197, 77.89456729138232),
              iconSize: 0.5,
              iconOffset: Offset(
                0,
                -2,
              ),
            ),
          );
        },
        accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
        initialCameraPosition: const CameraPosition(
          target: LatLng(29.867904439092197, 77.89456729138232),
          zoom: 15.0,
        ),
      ),
    );
  }
}
