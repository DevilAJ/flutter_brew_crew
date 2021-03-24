import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brew');

  Future updateUserData(String name, String sugar, int strenth) async {
    return await brewCollection.doc(uid).set(
      {
        'sugar': sugar,
        'name': name,
        'strength': strenth,
      },
    );
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        return Brew(
          name: doc.data()['name'] ?? '',
          sugar: doc.data()['sugar'] ?? '0',
          strength: doc.data()['strength'] ?? 0,
        );
      },
    ).toList();
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugar'],
      strength: snapshot.data()['strength'],
    );
  }

  // get user data
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
