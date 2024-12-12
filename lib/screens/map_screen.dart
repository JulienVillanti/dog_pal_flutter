import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'config.dart';


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
    Park(name: "Jarry Park", coordinate: LatLng(45.4230, -73.6032)),
    Park(name: "Berri Park", coordinate: LatLng(45.4710, -73.5590)),
    Park(name: "Lachine Canal Park", coordinate: LatLng(45.4485, -73.5752)),
    Park(name: "Parc des Rapides", coordinate: LatLng(45.4539, -73.6787)),
    Park(name: "Parc Angrignon", coordinate: LatLng(45.4537, -73.5942)),
    Park(name: "Parc Maisonneuve", coordinate: LatLng(45.5540, -73.5777)),
    Park(name: "Parc de la Visitation", coordinate: LatLng(45.5473, -73.6360)),
    Park(name: "Dorchester Square", coordinate: LatLng(45.4984, -73.5678)),
    Park(name: "Parc du Mont-Saint-Bruno", coordinate: LatLng(45.5165, -73.3167)),
    Park(name: "Biodome and Botanical Garden", coordinate: LatLng(45.5576, -73.5456)),
    Park(name: "Parc de la Fontaine", coordinate: LatLng(45.5205, -73.6165)),
    Park(name: "Park Avenue Green Alley", coordinate: LatLng(45.5225, -73.5773)),
    Park(name: "Parc Mont-Royal Summit", coordinate: LatLng(45.5100, -73.5800)),
    Park(name: "Beaver Lake", coordinate: LatLng(45.5075, -73.5794)),
    Park(name: "Parc Jeanne-Mance", coordinate: LatLng(45.5119, -73.5806)),
    Park(name: "Westmount Park", coordinate: LatLng(45.4936, -73.6021)),
    Park(name: "Parc Outremont", coordinate: LatLng(45.5136, -73.6116)),
    Park(name: "Parc du Bois-de-Liesse", coordinate: LatLng(45.5121, -73.7595)),
    Park(name: "Parc des Iles-de-Boucherville", coordinate: LatLng(45.5585, -73.4990)),
    Park(name: "Parc Beaudet", coordinate: LatLng(45.4862, -73.6583)),
    Park(name: "Parc Nature de l'Île-de-la-Visitation", coordinate: LatLng(45.5595, -73.6543)),
    Park(name: "Parc du Millénaire", coordinate: LatLng(45.5020, -73.6083)),
    Park(name: "Parc des Moulins", coordinate: LatLng(45.4410, -73.5535)),
    Park(name: "Parc de la Rivière-des-Prairies", coordinate: LatLng(45.6193, -73.6651)),
    Park(name: "Parc Léon-Provancher", coordinate: LatLng(45.5654, -73.6026)),
    Park(name: "Parc de l'Anse-à-l'Orme", coordinate: LatLng(45.4815, -73.9302)),


  ];
  Park? closestPark;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _addMarkers();
        _findClosestPark();
        _isLoading = false;
      });
    } catch (e) {
      print("Error getting user location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Add markers-red
  void _addMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("UserLocation"),
          position: _userLocation,
          infoWindow: InfoWindow(title: "Your Location"),
        ),
      );

      for (var park in parks) {
        _markers.add(
          Marker(
            markerId: MarkerId(park.name),
            position: park.coordinate,
            infoWindow: InfoWindow(title: park.name),
          ),
        );
      }
    });
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
    // try {
    //   const apiKey = googleMapsApiKey;
    //
    //   final url = Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
    //   );
    //
    //   print("URL gerada: $url");
    //
    //   final response = await http.get(url);
    //
    //   print("Status Code: ${response.statusCode}");
    //   print("Corpo da resposta: ${response.body}");
    //
    //   // Verifica se a resposta foi bem-sucedida
    //   if (response.statusCode != 200) {
    //     print("Erro: Código ${response.statusCode}");
    //     return;
    //   }
    //
    //   // Valida o tipo do corpo da resposta
    //   if (response.body.isEmpty) {
    //     print("Erro: Resposta vazia.");
    //     return;
    //   }
    //
    //   // Tenta decodificar o JSON
    //   late final data;
    //   try {
    //     data = jsonDecode(response.body);
    //   } catch (e) {
    //     print("Erro ao decodificar JSON: $e");
    //     return;
    //   }
    //
    //   // Valida o conteúdo decodificado
    //   if (data['results'] == null || data['results'].isEmpty) {
    //     print("Erro: Nenhum resultado encontrado no JSON.");
    //     return;
    //   }
    //
    //   final location = data['results'][0]['geometry']['location'];
    //   LatLng coordinate = LatLng(location['lat'], location['lng']);
    //
    //   setState(() {
    //     _userLocation = coordinate;
    //     mapController.animateCamera(CameraUpdate.newLatLngZoom(coordinate, 14));
    //     _findClosestPark();
    //   });
    //
    // } catch (e) {
    //   print("Erro geral: $e");
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
               _geocodeAddress(value);
              },
            ),
          ),
          // Mapa
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;

                _addMarkers();
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
