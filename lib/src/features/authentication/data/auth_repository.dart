import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_management/src/exceptions/app_exception.dart';
import 'package:task_management/src/features/authentication/application/firebase_service.dart';
import 'package:task_management/src/features/authentication/domain/app_user.dart';
import 'package:task_management/src/utils/delay.dart';
import 'package:task_management/src/utils/in_memory_store.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  // List to keep track of all user accounts

  final firebaseService = FirebaseService();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);

    final user = await firebaseService.signInWithEmailPassword(email, password);
    if (user != null) {
      _authState.value = user;
    } else {
      throw UserNotFoundException();
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    await delay(addDelay);

    // minimum password length requirement
    if (password.length < 8) {
      throw WeakPasswordException();
    }
    // create new user
    await _createNewUser(email, password);
  }

  Future<void> signOut() async {
    _authState.value = null;
    await firebaseService.signOutWithPassword();
  }

  void dispose() => _authState.close();

  Future<void> _createNewUser(String email, String password) async {
    final user = await firebaseService.signUpWithEmailPassword(email, password);

    // update the auth state
    _authState.value = user;
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
}

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
