import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';
import '../models/experience.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final firestore = ref.read(firebaseFirestoreProvider);
  final snapshot = await firestore
      .collection('projects')
      .orderBy('order')
      .get();
  return snapshot.docs
      .map((doc) => Project.fromJson(doc.data(), doc.id))
      .toList();
});

final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final firestore = ref.read(firebaseFirestoreProvider);
  final snapshot = await firestore
      .collection('experiences')
      .orderBy('order')
      .get();
  return snapshot.docs
      .map((doc) => Experience.fromJson(doc.data(), doc.id))
      .toList();
});
