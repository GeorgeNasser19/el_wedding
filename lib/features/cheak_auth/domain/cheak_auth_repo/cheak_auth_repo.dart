import 'package:dartz/dartz.dart';
import 'package:el_wedding/features/cheak_auth/model/entity_cheak_auth.dart';

abstract class CheakAuthRepo {
  Future<Either<String, EntityCheakAuth>> fetchEnitiyModel(String userId);
}
