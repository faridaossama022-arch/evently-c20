import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20/model/event_model.dart';
import 'package:evently_c20/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class FirestoreManager {

  static CollectionReference<User> getUserCollection(){
    var collection = FirebaseFirestore.instance.collection("User").withConverter(
      fromFirestore:(snapshot, options) {
        Map<String,dynamic>? data = snapshot.data();
        return User.fromFireStore(data);
      } ,
      toFirestore: (user, options) {
        return user.toFireStore();
      },);
    return collection;
  }
  static Future<void> saveUser(User myUser){
    var collection = getUserCollection();
    var doc = collection.doc(myUser.id);
    return doc.set(myUser);

  }

  static Future<User?> getUser()async{
    var collection = getUserCollection();
    var doc = collection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    var snapshot = await doc.get();
    return snapshot.data();
  }

  static CollectionReference<EventModel> getEventsCollection(){
    var collection = FirebaseFirestore.instance.collection("Event").withConverter(
      fromFirestore: (snapshot, options) {
        var docSnapshot = snapshot.data();
        return EventModel.fromFirestore(docSnapshot);
      },
      toFirestore:  (value, options) {
        return value.toFirestore();
      },
    );
    return collection;
  }
  static Future<void> saveEvent(EventModel event){
    var collection = getEventsCollection();
    var doc = collection.doc();
    event.id = doc.id;
    return doc.set(event);
  }

  static Future<List<EventModel>> getAllEvents()async{
    var collection = getEventsCollection();
    var queryDocSnapshot = await collection.get();
    var docs = queryDocSnapshot.docs;
    List<EventModel> events = docs.map((document) => document.data(),).toList();
    return events;
  }
  // Sport
  static Future<List<EventModel>> getFilteredEvents(String type)async{
    var collection = getEventsCollection().where("type",isEqualTo: type);
    var queryDocSnapshot = await collection.get();
    var docs = queryDocSnapshot.docs;
    List<EventModel> events = docs.map((document) => document.data(),).toList();
    return events;
  }
  static Stream<List<EventModel>> listenAllEvents()async*{
    var collection = getEventsCollection();
    var queryDocSnapshotStream = collection.snapshots();
    var docsStream = queryDocSnapshotStream.map((querysnapshot) => querysnapshot.docs,);
    var eventsStream = docsStream.map((docs) => docs.map((document) => document.data(),).toList(),);
    yield* eventsStream;
  }

  static CollectionReference<EventModel> getFavoritesCollection(){
    var userCollection = getUserCollection();
    var userDoc = userCollection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    var collection = userDoc.collection("Favorite").withConverter(
      fromFirestore: (snapshot, options) {
        var docSnapshot = snapshot.data();
        return EventModel.fromFirestore(docSnapshot);
      },
      toFirestore:  (value, options) {
        return value.toFirestore();
      },
    );
    return collection;
  }

  static Future<void> addEventFavorite(EventModel event){
    var favoriteCollection = getFavoritesCollection();
    var doc = favoriteCollection.doc(event.id);
    return doc.set(event);
  }
  static Future<void> deleteEventFavorite(EventModel event){
    var favoriteCollection = getFavoritesCollection();
    var doc = favoriteCollection.doc(event.id);
    return doc.delete();
  }

  static Future<void> updateUser(List<String> favorites){
    var collection = getUserCollection();
    var doc = collection.doc(auth.FirebaseAuth.instance.currentUser?.uid);
    return doc.update({
      "favoriteList":favorites
    });
  }
  static Stream<List<EventModel>> listenFavoriteEvents()async*{
    var collection = getFavoritesCollection();
    var queryDocSnapshotStream = collection.snapshots();
    var docsStream = queryDocSnapshotStream.map((querysnapshot) => querysnapshot.docs,);
    var eventsStream = docsStream.map((docs) => docs.map((document) => document.data(),).toList(),);
    yield* eventsStream;
  }

  static Future<void> updateEvent(EventModel event){
    var collection = getEventsCollection();
    var doc = collection.doc(event.id);
    return doc.set(event);
  }

  static Future<void> deleteEvent(EventModel event)async{
    var collection = getEventsCollection();
    await collection.doc(event.id).delete();
    await getFavoritesCollection().doc(event.id).delete();
  }
}