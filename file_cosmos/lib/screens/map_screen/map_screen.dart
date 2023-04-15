import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MapboxMap(
        annotationOrder: const [
          AnnotationType.line,
          AnnotationType.fill,
        ],

        zoomGesturesEnabled: true,
        accessToken: const String.fromEnvironment("ACCESS_TOKEN"),
         initialCameraPosition: const CameraPosition(
          zoom: 3,
          target: LatLng(29.864935137683155, 77.8937955674538),
          ),
      ),
    );
  }
}