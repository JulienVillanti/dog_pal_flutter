import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
<<<<<<< HEAD
  final FirebaseDatabase _database = FirebaseDatabase.instance;
=======
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
>>>>>>> e168c7e ( change the version in pubspec.yaml + create database service)

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
<<<<<<< HEAD
    final userRef = _database.ref().child('users').child(uid);
    await userRef.set({
      'name': name,
      'email': email,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _database.ref().child('users').child(uid).get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  Stream<DatabaseEvent> getUserProfileStream(String uid) {
    return _database.ref().child('users').child(uid).onValue;
=======
    try {
      await _database.child('users/$uid').set({
        'name': name,
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final snapshot = await _database.child('users/$uid').get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
>>>>>>> e168c7e ( change the version in pubspec.yaml + create database service)
  }
}
