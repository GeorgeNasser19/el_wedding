import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cheak_auth_state.dart';

class CheakAuthCubit extends Cubit<CheakAuthState> {
  CheakAuthCubit() : super(CheakAuthInitial());
}
