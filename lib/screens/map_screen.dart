import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_geocoding/google_geocoding.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  TextEditingController _searchController = TextEditingController();
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  //Add location MONTREAL
  late LatLng _userLocation = LatLng(45.5017, -73.5673);
  bool _isLoading = true;

  List<Park> parks = [

    Park(name: "Mount Royal Park", coordinate: LatLng(45.5017, -73.5673)),
    Park(name: "Jean-Drapeau Park", coordinate: LatLng(45.5088, -73.5530)),
    Park(name: "La Fontaine Park", coordinate: LatLng(45.5200, -73.6167)),


  ];
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

      _addMarkers();

     _findClosestPark();
    });
  }

  //Add markers-red
  void _addMarkers() {
    for (var park in parks) {
      _markers.add(
        Marker(
          markerId: MarkerId(park.name),
          position: park.coordinate,
          infoWindow: InfoWindow(title: park.name),
        ),
      );
    }
  }

  void _findClosestPark() {

    double minDistance = double.infinity;
    Park? closest = parks.first;

    for (var park in parks) {
      double distance = _calculateDistance(_userLocation, park.coordinate);
      if (distance < minDistance) {
        minDistance = distance;
        closest = park;
      }
    }
    setState(() {
      closestPark = closest;
    });
  }


  double _calculateDistance(LatLng userLocation, LatLng parkLocation) {
    double distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      parkLocation.latitude,
      parkLocation.longitude,
    );
    return distance;
  }

  //Try Install API
  Future<void> _geocodeAddress(String address) async {

    const apiKey = "YOUR_API_KEY";

    final geocoding = GoogleGeocoding(apiKey);

    // var result = await geocoding.geocoding.get(address);
    //
    // if (result != null &&
    //     result.results != null &&
    //     result.results!.isNotEmpty) {
    //   var location = result.results!.first.geometry!.location!;
    //   LatLng coordinate = LatLng(location.lat!, location.lng!);
    //
    //   setState(() {
    //     _userLocation = coordinate;
    //     mapController.animateCamera(CameraUpdate.newLatLngZoom(coordinate, 14));
    //     _findClosestPark();
    //   });
    // } else {
    //   print("Adress not found.");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Logo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
                child: Image.asset("assets/dogpal-logo.png", height: 100,
                ),
              )
            ],
          ),
          // User type
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
