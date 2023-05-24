import 'package:flutter/material.dart';

class Post {
  final String label;
  final String content;
  final String type;
  final int client_id;
  DateTime date;

  Post({
    required this.label,
    required this.content,
    required this.type,
    required this.client_id,
    required this.date,
  });
}

class User {
  final int client_id;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String phoneNumber;
  final String bio;
  final List<Post> posts;

  User({
    required this.client_id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.bio,
    required this.posts,
  });
}

class UserProfile {
  String name;
  String email;
  int age;
  String gender;
  String location;
  List<Post> posts;

  UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.location,
    required this.posts,
  });

  get imagePath => null;
}

final currentUser = UserProfile(
    email: 'mbi@gmail.com',
    name: 'mbi network',
    age: 15,
    gender: 'male',
    location: 'Tunisia',
    posts: [
      Post(
          label: 'label',
          content: 'content',
          type: ' type',
          client_id: 1,
          date: DateTime.now()),
      Post(
          label: 'label',
          content: 'content',
          type: ' type',
          client_id: 1,
          date: DateTime.now()),
    ]);
