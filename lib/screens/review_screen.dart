import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// Wandrey
// Page created to show the idea of the ratings and comments by user.
// Need to polish and finish.


class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _commentText = '';
  int _rating = 0;
  String _userName = '';
  String _dogBreed = '';
  int _selectedParkIndex = 0;
  List<ParkReviewData> _parks = [];

  final List<String> parkNames = [
    "Mount Royal Park", "Jean-Drapeau Park", "La Fontaine Park", "Jarry Park",
    "Berri Park", "Lachine Canal Park", "Parc des Rapides", "Parc Angrignon",
    "Parc Maisonneuve", "Parc de la Visitation", "Dorchester Square",
    "Parc du Mont-Saint-Bruno", "Biodome and Botanical Garden", "Parc de la Fontaine",
    "Park Avenue Green Alley", "Parc Mont-Royal Summit", "Beaver Lake",
    "Parc Jeanne-Mance", "Westmount Park", "Parc Outremont", "Parc du Bois-de-Liesse",
    "Parc des Iles-de-Boucherville", "Parc Beaudet", "Parc Nature de l'Île-de-la-Visitation",
    "Parc du Millénaire", "Parc des Moulins", "Parc de la Rivière-des-Prairies",
    "Parc Léon-Provancher", "Parc de l'Anse-à-l'Orme"
  ];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    _fetchParksReviews();
  }

  void fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final userRef = FirebaseDatabase.instance.ref("users/$userId");

      print("Fetching details for user ID: $userId");

      try {
        final event = await userRef.once();
        final snapshot = event.snapshot;

        if (snapshot.exists) {
          print("Snapshot data: ${snapshot.value}");

          final userData = Map<String, dynamic>.from(snapshot.value as Map);

          setState(() {
            _userName = userData["name"] ?? "Unknown User";
            _dogBreed = userData["dogBreed"] ?? "No Breed";
          });
        } else {
          print("No user data found at path users/$userId.");
        }
      } catch (error) {
        print("Error fetching user details: $error");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  void _fetchParksReviews() {
    _ref.child("comments").once().then((DatabaseEvent event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<dynamic, dynamic>? parksData = snapshot.value as Map<dynamic, dynamic>?;

        Map<String, List<ParkReview>> parksDict = {};
        Map<String, List<int>> parkRatings = {};

        if (parksData != null) {
          parksData.forEach((userId, comments) {
            if (comments is Map) {
              comments.forEach((_, commentData) {
                if (commentData is Map) {
                  int? parkIndex = commentData["selectedPark"] as int?;
                  if (parkIndex != null && parkIndex < parkNames.length) {
                    String parkName = parkNames[parkIndex];
                    String userName = commentData["userName"] as String? ?? "Anonymous";
                    int rating = commentData["rating"] as int? ?? 0;
                    String comment = commentData["commentText"] as String? ?? "";

                    ParkReview review = ParkReview(userName: userName, rating: rating, comment: comment);
                    parksDict.putIfAbsent(parkName, () => []).add(review);
                    parkRatings.putIfAbsent(parkName, () => []).add(rating);
                  }
                }
              });
            }
          });
        }

        //------------------------------------------

        List<ParkReviewData> parks = parksDict.entries.map((entry) {
          String parkName = entry.key;
          List<ParkReview> reviews = entry.value;
          double avgRating = (parkRatings[parkName]?.reduce((a, b) => a + b) ?? 0) / reviews.length;

          return ParkReviewData(name: parkName, rating: avgRating, reviews: reviews);
        }).toList();

        setState(() {
          _parks = parks;
        });
      } else {
        print("No comments data found.");
      }
    }).catchError((error) {
      print("Error fetching parks reviews: $error");
    });
  }


  //------------------------------------------

        @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.pink, BlendMode.srcIn),
              child: Image.asset("assets/dogpal-logo.png", height: 100,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Park Reviews",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            ...parks.map((park) => buildParkReview(park)).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildParkReview(ParkReviewData park) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            park.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "Rating: ${park.rating.toStringAsFixed(1)}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ...park.reviews.map((review) => buildReviewCard(review)).toList(),
          const Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }

  Widget buildReviewCard(ParkReview review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.userName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                  5,
                      (index) => Icon(
                    Icons.star,
                    color: index < review.rating ? Colors.yellow : Colors.grey,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}


//------------------------------------------------------------
  class ParkReviewData {
  final String name;
  final double rating;
  final List<ParkReview> reviews;

  ParkReviewData({required this.name, required this.rating, required this.reviews});
  }

//----------------------------------------------------------------
class ParkReview {
  final String userName;
  final int rating;
  final String comment;

  ParkReview({required this.userName, required this.rating, required this.comment});
}