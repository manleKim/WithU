String getDormitoryFormatted(String dormitoryNumber) {
  // 12-3456 -> 123456
  return '${dormitoryNumber.substring(0, 2)}${dormitoryNumber.substring(3)}';
}

String getPasswordFormatted(String password) {
  // 000101 -> 20000101, 990101 -> 19990101
  String prefix = int.parse(password.substring(0, 2)) >= 50 ? '19' : '20';
  return prefix + password;
}

String getDateStringFormatted(DateTime date) {
  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$year$month$day';
}
