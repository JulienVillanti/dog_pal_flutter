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

class ParkReviewData {
  final String name;
  final double rating;
  final String imageName;
  final String description;
  final List<ParkReview> reviews;

  ParkReviewData({
    required this.name,
    required this.rating,
    required this.imageName,
    required this.description,
    required this.reviews,
  });
}

class ParkReview {
  final String userName;
  final int rating;
  final String comment;

  ParkReview({
    required this.userName,
    required this.rating,
    required this.comment,
  });
}