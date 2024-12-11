import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'map_screen.dart';

class HomeScreenView extends StatefulWidget {

  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();

}

class _HomeScreenViewState extends State<HomeScreenView> {
  //Change the position navigation bar
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = '';
  String userName = '';
  List<Park> parks = [
    Park(
      name: "Park Lafontaine",
      rating: 4.8,
      imageName: "assets/parclafontaine.jpeg",
      description: "One of the most popular parks in Montreal, ideal for picnics and walks.",
      reviews: ["Incredible!", "Great place to relax.", "Very beautiful!"],
    ),
    Park(
      name: "Park Jean-Drapeau",
      rating: 4.7,
      imageName: "assets/parcjeandrapeau.jpeg",
      description: "A park with a view of the river and various outdoor activities.",
      reviews: ["I love running here.", "A perfect place for a family day."],
    ),
    Park(
      name: "Park Angrignon",
      rating: 4.6,
      imageName: "assets/parcangrignon.jpeg",
      description: "A peaceful park with large green areas and lakes.",
      reviews: ["Excellent for walks.", "Very well maintained."],
    ),
  ];

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "Unknown User";
        userName = user.displayName ?? userEmail;
      });
    } else {
      print("User not logged in");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("DogPal App"),
          ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                homeTab(),
                profileTab(),
                reviewTab(),
                mapTab(),
              ],
            ),
            bottomNavigationBar:BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.grey[800],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.pink,
              items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem( icon: Icon(Icons.home), label: 'Home',
              ),
              BottomNavigationBarItem( icon: Icon(Icons.person), label: 'Profile',
              ),
              BottomNavigationBarItem( icon: Icon(Icons.star), label: 'Reviews',
              ),
              BottomNavigationBarItem( icon: Icon(Icons.nature_people), label: 'Maps',
              ),
              ],
            ),
        ),
      ),
    );
  }

  Widget homeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
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
          SizedBox(height: 40),
          Text("Welcome, $userEmail", style: TextStyle(fontSize: 20)),
          Image.asset("assets/map.png", height: 250),
          Text("Best Parks in Montreal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: parks.map((park) => parkCard(park)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget parkCard(Park park) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.asset(park.imageName, width: 150, height: 100, fit: BoxFit.cover),
          Text(park.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Rating: ${park.rating}", style: TextStyle(color: Colors.grey)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ParkDetailView(park: park)),
              );
            },
            child: Text("View Park",  style: TextStyle(color: Colors.pink),),
          ),
        ],
      ),
    );
  }

  Widget profileTab() {
    return Center(child: Text("Profile Page"));
  }

  Widget reviewTab() {
    return Center(child: Text("Review Page"));
  }

  Widget mapTab() {
    return MapScreen();
  }
}

class Park {
  final String name;
  final double rating;
  final String imageName;
  final String description;
  final List<String> reviews;

  Park({
    required this.name,
    required this.rating,
    required this.imageName,
    required this.description,
    required this.reviews,
  });
}

class ParkDetailView extends StatelessWidget {
  final Park park;

  const ParkDetailView({required this.park});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(park.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(park.imageName, height: 300, fit: BoxFit.cover),
            Text(park.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Rating: ${park.rating}", style: TextStyle(color: Colors.grey)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(park.description),
            ),
            Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...park.reviews.map((review) => ListTile(title: Text(review))).toList(),
          ],
        ),
      ),
    );
  }
}
