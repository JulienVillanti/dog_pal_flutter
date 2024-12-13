import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {

  final dynamic review;

  ReviewScreen({required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Parks"),
      ),
      body: Center(
        child: Text(
          "Review for: $review",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
