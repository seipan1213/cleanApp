import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final apiService = ApiService();

class CleaningSetting {
  final int? name;
  final String? spot;
  final int? remind_interval;

  CleaningSetting({
    this.name,
    this.spot,
    this.remind_interval,
  });

  factory CleaningSetting.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CleaningSetting(
      name: data?['name'],
      spot: data?['spot'],
      remind_interval: data?['remind_interval'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (spot != null) "spot": spot,
      if (remind_interval != null) "remind_interval": remind_interval,
    };
  }
}

class User {
  final String? name;
  final String? uid;

  User({this.name, this.uid});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      name: data?['name'],
      uid: data?['uid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (uid != null) "uid": uid,
    };
  }
}

class ApiService {
  void addCleaningSetting(CleaningSetting request) async {}

  void addUser(User user) async {
    final docRef = db
        .collection("users")
        .withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, options) => user.toFirestore(),
        )
        .doc(user.uid);
    await docRef.set(user);
  }
}
