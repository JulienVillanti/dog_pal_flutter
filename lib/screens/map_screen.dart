import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  TextEditingController _searchController = TextEditingController();
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  late LatLng _userLocation;

  // List<Park> parks = [
  //   Park(name: "Mount Royal Park", coordinate: LatLng(45.5017, -73.5673)),
  //   Park(name: "Jean-Drapeau Park", coordinate: LatLng(45.5088, -73.5530)),
  //   Park(name: "La Fontaine Park", coordinate: LatLng(45.5200, -73.6167)),
  //
  //
  // ];
  Park? closestPark;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      // _addMarkers();
      // _findClosestPark();
    });
  }

  // void _addMarkers() {
  //   for (var park in parks) {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(park.name),
  //         position: park.coordinate,
  //         infoWindow: InfoWindow(title: park.name),
  //       ),
  //     );
  //   }
  // }

  // void _findClosestPark() {
  //   double minDistance = double.infinity;
  //   Park? closest = parks.first;
  //   for (var park in parks) {
  //     double distance = _calculateDistance(_userLocation, park.coordinate);
  //     if (distance < minDistance) {
  //       minDistance = distance;
  //       closest = park;
  //     }
  //   }
  //   setState(() {
  //     closestPark = closest;
  //   });
  // }

  
  double _calculateDistance(LatLng userLocation, LatLng parkLocation) {
    double distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      parkLocation.latitude,
      parkLocation.longitude,
    );
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parks Near You"),
      ),
      body: Column(
        children: [
          // Logo
          Image.asset(
            "assets/dogpal-logo.png",
            height: 150,
          ),
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Enter address or postal code",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                // Implementar geocodificação (localização por endereço)
              },
            ),
          ),
          // Mapa
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 14,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),

          if (closestPark != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "The nearest park is: ${closestPark!.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

          ElevatedButton(
            onPressed: () {

            },
            child: Text("Review Parks"),
          ),
        ],
      ),
    );
  }
}

class Park {

  final String name;
  final LatLng coordinate;

  Park({required this.name, required this.coordinate});
}
