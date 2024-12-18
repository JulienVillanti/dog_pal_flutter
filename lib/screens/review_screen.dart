import 'package:flutter/material.dart';

// Wandrey
// Page created to show the idea of the ratings and comments by user.
// Need to polish and finish.

class ReviewScreen extends StatelessWidget {
  final List<ParkReviewData> parks = [
    ParkReviewData(
      name: "Park Lafontaine",
      rating: 4.8,
      imageName: "assets/images/parclafontaine.png",
      description:
      "One of the most popular parks in Montreal, ideal for picnics and walks.",
      reviews: [
        ParkReview(userName: "John", rating: 5, comment: "Incredible!"),
        ParkReview(userName: "Alice", rating: 4, comment: "Great place to relax."),
        ParkReview(userName: "Bob", rating: 4, comment: "Very beautiful!")
      ],
    ),
    ParkReviewData(
      name: "Park Jean-Drapeau",
      rating: 4.7,
      imageName: "assets/images/parcjeandrapeau.png",
      description:
      "A park with a view of the river and various outdoor activities.",
      reviews: [
        ParkReview(userName: "David", rating: 4, comment: "I love running here."),
        ParkReview(userName: "Emily", rating: 5, comment: "A perfect place for a family day.")
      ],
    ),
    ParkReviewData(
      name: "Park Angrignon",
      rating: 4.6,
      imageName: "assets/images/parcangrignon.png",
      description: "A peaceful park with large green areas and lakes.",
      reviews: [
        ParkReview(userName: "Eve", rating: 4, comment: "Excellent for walks."),
        ParkReview(userName: "Jack", rating: 5, comment: "Very well maintained.")
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Park Reviews"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/DogPalLogo2.png',
                height: 150,
                fit: BoxFit.contain,
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

