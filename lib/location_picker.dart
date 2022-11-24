import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatelessWidget {
  const LocationPicker({
    Key? key,
    required this.onLocationChange,
    required this.currentLocation,
  }): super(key: key);
  final void Function(LatLng) onLocationChange;
  final LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    print("Location picker got lat ${currentLocation.latitude}, lng: ${currentLocation.longitude}");
    return FlutterMap(
      options: MapOptions(
        center: currentLocation,
        zoom: 18,
        maxZoom: 18,
        keepAlive: true,
        absorbPanEventsOnScrollables: false,
        // bounds: LatLngBounds(
        //     LatLng(-90, -180.0),
        //     LatLng(90.0, 180.0),
        // ),
        // maxBounds: LatLngBounds(
        //   LatLng(-90, -180.0),
        //   LatLng(90.0, 180.0),
        // ),
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.tipper.app',
        ),
        DragMarkers(
          markers: [
            DragMarker(
              key: const ValueKey(1), // if you reorder your markers a lot, check your keys are unique
              point: currentLocation,
              width: 80.0,
              height: 80.0,
              offset: const Offset(0.0, -8.0),
              builder: (ctx) => const Icon(Icons.location_on, size: 50, color: Colors.pink,),
              onDragEnd: (details, point) {
                onLocationChange(point);
              },
              onDragUpdate: (details, point) {},
              feedbackBuilder: (ctx) =>
              const Icon(Icons.edit_location, size: 75, color: Colors.pink),
              feedbackOffset: const Offset(0.0, -18.0),
              updateMapNearEdge: true,
              nearEdgeRatio: 2.0,
              nearEdgeSpeed: 1.0,
            ),
            // DragMarker(
            //   key: const ValueKey(2),
            //   point: currentLocation,
            //   width: 80.0,
            //   height: 80.0,
            //   builder: (ctx) => const Icon(Icons.location_on, size: 50, color: Colors.pink),
            //   updateMapNearEdge: false,
            // )
          ],
        ),
      ],
    );
  }
}
