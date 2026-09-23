import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'auth_state.dart';
import 'package:flutter/material.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  StreamSubscription<User?>? _authSubscription;

  AuthCubit(this.authRepository) : super(AuthInitial());

  void checkAuthState() {
    emit(AuthLoading());

    _authSubscription = authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
      onError: (error) {
        emit(AuthError(error.toString()));
      },
    );
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      emit(AuthLoading());

      await authRepository.login(email, password);

      // We don't need to manually emit AuthAuthenticated here.
      // Firebase authStateChanges will do that.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      emit(AuthLoading());

      await authRepository.register(name, email, password);

    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());

      await authRepository.logout();

      // Firebase authStateChanges will emit AuthUnauthenticated.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(AuthError('Unable to logout. Please try again.'));
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-disabled':
        return 'This account has been disabled.';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());

      await authRepository.resetPassword(email);

      emit(AuthPasswordResetSent());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getFirebaseErrorMessage(e)));
    } catch (e) {
      emit(
        AuthError(
          'Unable to send password reset email. Please try again.',
        ),
      );
    }
  }

  Future signInWithGoogle() async {
    try {
      emit(AuthLoading());

      await authRepository.signInWithGoogle();

    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getFirebaseErrorMessage(e)));
    } catch (e) {
      debugPrint('Google Sign-In error: $e');

      emit(
        AuthError(
          'Google Sign-In failed. Please try again.',
        ),
      );
    }
  }

}