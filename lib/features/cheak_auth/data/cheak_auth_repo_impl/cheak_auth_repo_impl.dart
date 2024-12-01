import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/auth/data/model/user_model.dart';
import 'package:el_wedding/features/cheak_auth/domain/cheak_auth_repo/cheak_auth_repo.dart';
import 'package:el_wedding/features/cheak_auth/model/entity_cheak_auth.dart';
import 'package:el_wedding/features/employesViews/data/model/employes_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheakAuthRepoImpl extends CheakAuthRepo {
  final _firebase = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Future<Either<String, EntityCheakAuth>> fetchEnitiyModel(
      String userId) async {
    final doc = await _firebase.collection("users").doc(userId).get();

    if (doc.exists) {
      return Right(EntityCheakAuth.fromDoc(
          UserModel.fromDoc(doc.data()!), EmployesModel.fromDoc(doc.data()!)));
    }

    throw UnimplementedError();
  }
}
