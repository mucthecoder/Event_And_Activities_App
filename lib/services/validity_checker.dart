class ValidityChecker {
  static bool isEmailUnique(String email, List existingEmails) {
    return !existingEmails.contains(email);
  }

  static bool isNameUnique(String name, List existingNames) {
    return !existingNames.contains(name);
  }

  static bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(name);
  }

  static bool isValidPassword(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
  }

  static bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  static bool isValidUser(String email, String name, String password,
      List existingEmails, List existingNames) {
    return isValidEmail(email) &&
        isEmailUnique(email, existingEmails) &&
        isValidName(name) &&
        isNameUnique(name, existingNames) &&
        isValidPassword(password);
  }

  static bool emptyInput(String input) {
    return input.isEmpty;
  }

  static bool nullInput(String? input) {
    return input == null;
  }

  // void addUser(String email, String name) {
  //   existingEmails.add(email);
  //   existingNames.add(name);
  // }
}
