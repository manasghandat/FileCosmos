import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData(Map<String, dynamic> data, String path) async {
    await _firestore.collection(path).add(data);
  }

  final user = FirebaseAuth.instance.currentUser;
  // update uFile list of map in users

  Future<void> updateUfiles(Map<String, dynamic> data) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'Ufiles': FieldValue.arrayUnion([data]),
      });
    }
  }

  // update dFile list of map in users
  Future<void> updateDfiles(Map<String, dynamic> data) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'Dfiles': FieldValue.arrayUnion([data]),
      });
    }
  }

  // delete uFile list of map in users
  Future<void> deleteUfiles(Map<String, dynamic> data) async {
    if (user != null) {
      await _firestore.collection('users').doc(user!.uid).update({
        'Ufiles': FieldValue.arrayRemove([data]),
      });
      await _firestore.collection('files').doc(data['id']).delete();
    }
  }

  // get uFile list of map in users
  Future<List<Map<String, dynamic>>> getUfiles() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      return List<Map<String, dynamic>>.from(doc.data()!['Ufiles']);
    }
    return [];
  }

  // get dFile list of map in users

  Future<List<Map<String, dynamic>>> getDfiles() async {
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      return List<Map<String, dynamic>>.from(doc.data()!['Dfiles']);
    }
    return [];
  }
  // createFile

  Future<String> addFile(Map<String, dynamic> data) async {
    if (user != null) {
      final docRef = await _firestore.collection('files').doc();
      docRef.set(data);
      return docRef.id;
    }
    return 'Error : User not logged in';
  }

}
