import 'package:firebase_database/firebase_database.dart';

class DatabaseService {

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {

    final userRef = _database.ref('users/$uid');
    await userRef.set({
      'name': name,
      'email': email,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot = await _database.ref('users/$uid').get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  Stream<DatabaseEvent> getUserProfileStream(String uid) {
    return _database.ref('users/$uid').onValue;

  }

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    try {
      final snapshot = await _database.ref('users/$uid').get();
      if (snapshot.exists && snapshot.value is Map) {


        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }
}
