import 'package:event_and_activities_app/services/validity_checker.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('password', () {
    test('Short password', () {
      expect(ValidityChecker.isValidPassword('1234567'), false);
    });
    test('No digit', () {
      expect(ValidityChecker.isValidPassword('abcdefg'), false);
    });
    test('No uppercase', () {
      expect(ValidityChecker.isValidPassword('abcdefg123'), false);
    });
    test('No lowercase', () {
      expect(ValidityChecker.isValidPassword('ABCDEFG123'), false);
    });
    test('No special character', () {
      expect(ValidityChecker.isValidPassword('Abcdefg123'), false);
    });
    test('Valid password', () {
      expect(ValidityChecker.isValidPassword('Abcdefg123!'), true);
    });
  });

  group('user', () {
    test('invalid user', () {
      expect(ValidityChecker.isValidUser('a@a.com', '@', 'Abcdefg123!', [], []),
          false);
    });
    test('valid user', () {
      expect(ValidityChecker.isValidUser('a@a.com', 'a', 'Abcdefg123!', [], []),
          true);
    });
  });

  group('name', () {
    test('invalid name', () {
      expect(ValidityChecker.isValidName('@'), false);
    });
    test('valid name', () {
      expect(ValidityChecker.isValidName('a'), true);
    });
    test('not unique name', () {
      expect(ValidityChecker.isNameUnique('a', ['a']), false);
    });
    test('unique name', () {
      expect(ValidityChecker.isNameUnique('a', []), true);
    });
  });

  group('email', () {
    test('invalid email', () {
      expect(ValidityChecker.isValidEmail('a@a'), false);
    });
    test('valid email', () {
      expect(ValidityChecker.isValidEmail('a@a.com'), true);
    });

    test('not unique email', () {
      expect(ValidityChecker.isEmailUnique('a@a.com', ['a@a.com']), false);
    });
    test('unique email', () {
      expect(ValidityChecker.isEmailUnique('a@a.com', []), true);
    });
  });
}
