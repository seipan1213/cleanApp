import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final apiService = ApiService();

class CleaningSetting {
  final String? user_uid;
  final String? spot;
  final int? remind_interval;

  CleaningSetting({
    this.user_uid,
    this.spot,
    this.remind_interval,
  });

  factory CleaningSetting.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CleaningSetting(
      user_uid: data?['user_uid'],
      spot: data?['spot'],
      remind_interval: data?['remind_interval'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (user_uid != null) "user_uid": user_uid,
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
  void addCleaningSettings(List<CleaningSetting> settings) async {
    for (final setting in settings) {
      final docRef = db
          .collection("users/${setting.user_uid}/cleaningSettings")
          .withConverter(
            fromFirestore: CleaningSetting.fromFirestore,
            toFirestore: (CleaningSetting setting, options) =>
                setting.toFirestore(),
          )
          .doc();
      await docRef.set(setting);
    }
  }

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

  void addUserWithCleaningSettings(
      User user, List<CleaningSetting> settings) async {
    addUser(user);
    addCleaningSettings(settings);
  }
}
