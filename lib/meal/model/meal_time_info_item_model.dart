class MealTimeInfoItem {
  final String name;
  final DateTime startAt;
  final DateTime endAt;
  final bool isCurrent;

  MealTimeInfoItem(
      {required this.name,
      required this.startAt,
      required this.endAt,
      required this.isCurrent});
}
