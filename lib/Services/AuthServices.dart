import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:net4moly/Model/user.dart';

class AuthServices {
  var storage = GetStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userCollection = FirebaseFirestore.instance.collection('users');

  Future<bool> signIn(String emailController, String passwordController) async {
    try {
      await auth.signInWithEmailAndPassword(email: emailController, password: passwordController);

      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signUp(AppUser appUser) async {
    try {
      await auth.createUserWithEmailAndPassword(email: appUser.email, password: appUser.password!);

      await saveUser(AppUser(
          id: user!.uid,
          name: appUser.name,
          email: appUser.email,
          role: appUser.role,
          profile: appUser.profile,
          phone_number: appUser.phone_number,
          last_name: appUser.last_name,
          birth_date: appUser.birth_date));

      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  Future<AppUser> getUserData() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    return AppUser.fromJson(userData.data()!);
  }

  User? get user => auth.currentUser;

  saveUser(AppUser user) async {
    try {
      await userCollection.doc(user.id).set(user.toJson());
    } catch (e) {}
  }

  saveUserLocally(AppUser user) {
    storage.write("role", user.role);

    storage.write("user", {
      'id': user.id,
      'name': user.name,
      'last_name': user.last_name,
      'email': user.email,
      'phone_number': user.phone_number,
      'role': user.role,
      'profile': user.profile,
    });
  }

  logOut(BuildContext context) {
    storage.remove('role');
    storage.remove('user');
    Navigator.of(context).pushNamedAndRemoveUntil('/signin', (Route<dynamic> route) => false);
  }

  Future<String> changeEmail(String email, String password) async {
    var userFromStorage = GetStorage().read('user');
    print(email);
    print(userFromStorage['email']);
    try {
      await auth.signInWithEmailAndPassword(email: userFromStorage['email'], password: password);
      await user!.updateEmail(email);
      await userCollection.doc(userFromStorage['id']).update({'email': email});

      userFromStorage['email'] = email;
      await GetStorage().write('user', userFromStorage);

      return 'done';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        return "Email deja utilisé";
      } else {
        return "Mot de passe incorrecte";
      }
    }
  }

  Future<bool> changePassword(String password, String newPassword) async {
    var userFromStorage = GetStorage().read('user');

    try {
      await auth.signInWithEmailAndPassword(email: userFromStorage['email'], password: password);
      await user!.updatePassword(newPassword);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
