import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthHelper {
  Stream<User?> get isLogged => FirebaseAuth.instance.authStateChanges();
  String? logginError;

  static Future<String> signInWithGoogle() async {
    try {
      final credentials = await FirebaseAuth.instance.signInWithProvider(
        GoogleAuthProvider(),
      );
      return 'Login feito com sucesso';
    } catch (e) {
      return 'erro desconhecido ${e}';
    }
  }

  static Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Login feito com sucesso';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'usuário não encontrado';
      } else if (e.code == 'invalid-email') {
        return 'email incorreto';
      } else if (e.code == 'wrong-password') {
        return 'senha incorreta';
      } else if (e.code == 'network-request-failed') {
        return 'sem conexão com internet';
      } else {
        return 'erro desconhecido ${e.code}';
      }
    }
  }

  static Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Usuário criado com sucesso';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'email já está cadastrado';
      } else if (e.code == 'weak-password') {
        return 'sua senha é muito fraca';
      } else if (e.code == 'invalid-email') {
        return 'email com formato inválido';
      } else if (e.code == 'network-request-failed') {
        return 'sem conexão com internet';
      } else {
        return 'erro desconhecido ${e.code}';
      }
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static User? get getCurrentUser => FirebaseAuth.instance.currentUser;
}
