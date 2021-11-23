import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //collection
  final CollectionReference userDrinksCollection =
      FirebaseFirestore.instance.collection('userdrinks');

  Future updateUserDrinks(List<int> dealsFavorited) async {
    return await userDrinksCollection.doc(uid).set({
      'favorites': dealsFavorited,
    });
  }

  // Stream<QuerySnapshot> get brews {}
}
