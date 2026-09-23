import 'package:flutter_developer_as_final_78518_damini/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthRepository authRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();

    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
    );
  });

  group('AuthRepository', () {
    test('currentUser returns null when no user is logged in', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(authRepository.currentUser, isNull);
    });

    test('login successfully logs in user', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();

      when(() => mockUser.email)
          .thenReturn('test@gmail.com');

      when(() => mockCredential.user)
          .thenReturn(mockUser);

      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@gmail.com',
          password: 'password123',
        ),
      ).thenAnswer(
        (_) async => mockCredential,
      );

      final credential = await authRepository.login(
        'test@gmail.com',
        'password123',
      );

      expect(credential.user, isNotNull);
      expect(credential.user?.email, 'test@gmail.com');
    });

    test('login throws error for invalid credentials', () async {
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'invalid@gmail.com',
          password: 'wrongpassword',
        ),
      ).thenThrow(
        FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credentials',
        ),
      );

      expect(
        () => authRepository.login(
          'invalid@gmail.com',
          'wrongpassword',
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

test('register successfully creates a user', () async {
  final mockUser = MockUser();
  final mockCredential = MockUserCredential();

  when(() => mockUser.email)
      .thenReturn('newuser@gmail.com');

  when(() => mockUser.updateDisplayName('Test User'))
      .thenAnswer((_) async {});

  when(() => mockUser.reload())
      .thenAnswer((_) async {});

  when(() => mockCredential.user)
      .thenReturn(mockUser);

  when(
    () => mockFirebaseAuth.createUserWithEmailAndPassword(
      email: 'newuser@gmail.com',
      password: 'password123',
    ),
  ).thenAnswer(
    (_) async => mockCredential,
  );

  final credential = await authRepository.register(
    'Test User',
    'newuser@gmail.com',
    'password123',
  );

  expect(credential.user, isNotNull);
  expect(credential.user?.email, 'newuser@gmail.com');
});

    test('resetPassword completes successfully', () async {
      when(
        () => mockFirebaseAuth.sendPasswordResetEmail(
          email: 'reset@gmail.com',
        ),
      ).thenAnswer(
        (_) async {},
      );

      await expectLater(
        authRepository.resetPassword('reset@gmail.com'),
        completes,
      );
    });

    test('logout successfully logs out user', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();

      when(() => mockCredential.user)
          .thenReturn(mockUser);

      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'logout@gmail.com',
          password: 'password123',
        ),
      ).thenAnswer(
        (_) async => mockCredential,
      );

      when(() => mockFirebaseAuth.currentUser)
          .thenReturn(mockUser);

      when(
        () => mockFirebaseAuth.signOut(),
      ).thenAnswer(
        (_) async {},
      );

      await authRepository.login(
        'logout@gmail.com',
        'password123',
      );

      expect(authRepository.currentUser, isNotNull);

      when(() => mockFirebaseAuth.currentUser)
          .thenReturn(null);

      await authRepository.logout();

      expect(authRepository.currentUser, isNull);
    });

    test('authStateChanges emits logged in user', () async {
      final mockUser = MockUser();

      when(() => mockUser.email)
          .thenReturn('stream@gmail.com');

      when(() => mockFirebaseAuth.authStateChanges())
          .thenAnswer(
            (_) => Stream.value(mockUser),
          );

      final user = await authRepository.authStateChanges.first;

      expect(user, isNotNull);
      expect(user?.email, 'stream@gmail.com');
    });
  });
}