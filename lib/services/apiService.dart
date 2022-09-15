import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

class Post {
  final String? user_id;
  final int? intensity;
  final String? spot;
  final String? comment;
  final bool? is_share;
  final DateTime? created_at;

  Post({
    this.user_id,
    this.intensity,
    this.spot,
    this.comment,
    this.is_share,
    this.created_at,
  });

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Post(
      user_id: data?['user_id'],
      intensity: data?['intensity'],
      spot: data?['spot'],
      comment: data?['comment'],
      is_share: data?['is_share'],
      created_at: data?['created_at'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (user_id != null) "user_id": user_id,
      if (intensity != null) "intensity": intensity,
      if (spot != null) "spot": spot,
      if (comment != null) "comment": comment,
      if (is_share != null) "is_share": is_share,
      if (created_at != null) "created_at": created_at,
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

  void addPost(Post post) async {
    final docRef = db
        .collection("posts")
        .withConverter(
          fromFirestore: Post.fromFirestore,
          toFirestore: (Post post, options) => post.toFirestore(),
        )
        .doc();
    await docRef.set(post);
  }

  Future<User> getUser(String user_id) async {
    final ref = db.collection('users').doc(user_id).withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );
    final docSnap = await ref.get();
    final user = docSnap.data();
    if (user == null) {
      throw ErrorDescription('not found user (user_id = ${user_id})');
    }
    return user as User;
  }

  /**
   * 引数無 全て
   * 引数有 user_idでフィルター
   */
  Future<List<Post>> getPosts({String user_id = ""}) async {
    var ref;
    if (!user_id.isEmpty) {
      ref = db
          .collection('posts')
          .where('user_id', isEqualTo: user_id)
          .withConverter(
            fromFirestore: Post.fromFirestore,
            toFirestore: (Post post, _) => post.toFirestore(),
          );
    } else {
      ref = db.collection('posts').withConverter(
            fromFirestore: Post.fromFirestore,
            toFirestore: (Post post, _) => post.toFirestore(),
          );
    }
    final docSnap = await ref.get();
    var posts = <Post>[];
    for (final snapshot in docSnap.docs) {
      posts.add(snapshot.data() as Post);
    }
    return posts;
  }

  Future<List<CleaningSetting>> getCleaningSettings(String user_id) async {
    final ref = db
        .collection('users/${user_id}/cleaningSettings')
        .withConverter(
          fromFirestore: CleaningSetting.fromFirestore,
          toFirestore: (CleaningSetting setting, _) => setting.toFirestore(),
        );
    final docSnap = await ref.get();
    var settings = <CleaningSetting>[];
    for (final snapshot in docSnap.docs) {
      settings.add(snapshot.data() as CleaningSetting);
    }
    return settings;
  }

  void deletePost(Post post) async {
    var referenceId;
    QuerySnapshot snapshot = await db
        .collection("posts")
        .where('user_id', isEqualTo: post.user_id)
        .where('created_at', isEqualTo: post.created_at)
        .get();

    db.collection("posts").doc(snapshot.docs.first.reference.id).delete();
  }

  // Setting Update
}
