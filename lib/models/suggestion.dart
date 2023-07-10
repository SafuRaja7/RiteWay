import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  final String description;

  Suggestion({
    required this.description,
  });
}

void saveSuggestion(Suggestion suggestion) {
  FirebaseFirestore.instance.collection('suggestions').add(
    {
      'description': suggestion.description,
    },
  );
}
