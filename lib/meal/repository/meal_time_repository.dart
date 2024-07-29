import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> getIsVacation() async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('isVacation')
      .doc('isVacation')
      .get();

  return doc['isVacation'];
}
