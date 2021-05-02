class Validation {
  static bool isStringValid(String text, int length) {
    return text != null && text.length >= length;
  }

  static bool isNameValid(String name){
    return RegExp(
        r'^[a-zA-Z\s]+$')
        .hasMatch(name);
  }

  static bool isAddressValid(String address){
    return RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(address);
  }

  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }

  static bool isBudgetValid(String budget) {
    double budgetDouble = double.parse(budget.replaceAll(",", ""));
    return budgetDouble > 100000 && budgetDouble % 1000 == 0;
  }
}
