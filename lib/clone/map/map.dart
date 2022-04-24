// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:plugin_helper/plugin_map.dart';
// import 'package:plugin_helper/plugin_navigator.dart';

// class Map extends StatefulWidget {
//   const Map({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<Map> createState() => _MapState();
// }

// class _MapState extends State<Map> {
//   late ClusterManager _manager;
//   bool _isUserDragging = true;
//   final Completer<GoogleMapController> _controller = Completer();
//   Set<Marker> markers = {};
//   GoogleMapController? googleMapController;

//   @override
//   void initState() {
//     _manager = _initClusterManager();
//     super.initState();
//   }

//   ClusterManager _initClusterManager() {
//     return ClusterManager<Place>(
//       [],
//       _updateMarkers,
//       markerBuilder: _markerBuilder,
//       stopClusteringZoom: 10.0,
//     );
//   }

//   void _updateMarkers(Set<Marker> markers) {
//     setState(() {
//       this.markers = markers;
//     });
//     if (!_isUserDragging) {
//       _isUserDragging = true;
//       //TODO: call api
//     }
//   }

//   _moveCameraTo(double lat, double lng) async {
//     var x = await _controller.future;
//     _isUserDragging = false;
//     await x.moveCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat, lng), zoom: 16)));
//   }

//   _getLatLng() async {
//     var context = MyPluginNavigation.instance.navigationKey!.currentContext!;
//     double screenWidth = MediaQuery.of(context).size.width *
//         MediaQuery.of(context).devicePixelRatio;
//     double screenHeight = MediaQuery.of(context).size.height *
//         MediaQuery.of(context).devicePixelRatio;

//     ScreenCoordinate bottomRight =
//         ScreenCoordinate(x: screenWidth.round(), y: screenHeight.round());
//     ScreenCoordinate topLeft = const ScreenCoordinate(x: 0, y: 0);
//     LatLng latLngTopLeft = await googleMapController!.getLatLng(topLeft);
//     LatLng latLngBottomRight =
//         await googleMapController!.getLatLng(bottomRight);
//     return {
//       "topLeft": "${latLngTopLeft.latitude},${latLngTopLeft.longitude}",
//       'bottomRight':
//           "${latLngBottomRight.latitude},${latLngBottomRight.longitude}"
//     };
//   }

//   _setItems() async {
//     List<Place> items = [];
//     _manager.setItems(items);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Listener(
//       onPointerDown: (e) {
//         _isUserDragging = true;
//       },
//       onPointerUp: (e) {
//         _isUserDragging = false;
//       },
//       child: GoogleMap(
//           mapType: MapType.normal,
//           initialCameraPosition: const CameraPosition(
//               target: LatLng(48.856613, 2.352222), zoom: 12.0),
//           markers: markers,
//           onMapCreated: (GoogleMapController controller) {
//             googleMapController = controller;
//             _controller.complete(controller);
//             _manager.setMapId(controller.mapId);
//             //TODO: call api
//           },
//           onCameraMove: (position) {
//             _manager.onCameraMove(position);
//             _isUserDragging = false;
//           },
//           onCameraIdle: _manager.updateMap),
//     ));
//   }

//   Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
//       (cluster) async {
//         var min = 110;
//         var max = 130;
//         if (Platform.isAndroid) {
//           min = (MediaQuery.of(context).size.width * 0.4).toInt();
//           max = min + 50;
//         }
//         return Marker(
//           markerId: MarkerId(cluster.getId()),
//           position: cluster.location,
//           onTap: () {
//             //TODO
//           },
//           icon: cluster.items.length > 1
//               ? await MyPluginMap.defaultMarker(cluster.isMultiple ? max : min,
//                   number: cluster.items.length)
//               : cluster.items.first.bitmapDescriptor,
//         );
//       };
// }

// class Place with ClusterItem {
//   final String name;
//   final bool isClosed;
//   final LatLng latLng;
//   final String imageUrl;
//   final String id;
//   final BitmapDescriptor bitmapDescriptor;

//   Place(
//       {required this.imageUrl,
//       required this.id,
//       required this.bitmapDescriptor,
//       required this.name,
//       required this.latLng,
//       this.isClosed = false});

//   @override
//   String toString() {
//     return 'Place $name (closed : $isClosed)';
//   }

//   @override
//   LatLng get location => latLng;
// }
