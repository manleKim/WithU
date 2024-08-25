String getDormitoryFormatted(String dormitoryNumber) {
  // 123456 -> 12-3456
  return '${dormitoryNumber.substring(0, 2)}-${dormitoryNumber.substring(2)}';
}
