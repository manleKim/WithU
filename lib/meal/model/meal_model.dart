import 'package:html/dom.dart';

abstract class MealModelBase {}

class MealModelError extends MealModelBase {
  final String message;

  MealModelError({required this.message});
}

class MealModelLoading extends MealModelBase {}

class MealListModel extends MealModelBase {
  final List<MealModel> mealList;

  MealListModel({required this.mealList});
}

class MealModel {
  final String fullDate;
  final DateTime date;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> dinner;

  MealModel({
    required this.fullDate,
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory MealModel.fromHtmlElement(List<Element> dailyMeal) {
    // 1. 날짜 문자열 파싱
    List<String> dateParts =
        dailyMeal[0].querySelector('a')!.text.split(' ')[0].split('.');
    int year = 2000 + int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);

    // 2. DateTime 객체 생성
    DateTime date = DateTime(year, month, day);

    // 3. 요일 변환
    Map<int, String> weekdayMap = {
      1: '월요일',
      2: '화요일',
      3: '수요일',
      4: '목요일',
      5: '금요일',
      6: '토요일',
      7: '일요일',
    };
    // 요일 한국어로 변환
    String weekdayKorean = weekdayMap[date.weekday] ?? '';

    // 조식
    final breakfast = getMenuList(dailyMeal[1].text.trim());

    // 중식
    final lunch = getMenuList(dailyMeal[2].text.trim());

    // 석식
    final dinner = getMenuList(dailyMeal[3].text.trim());

    return MealModel(
        fullDate: '$month월 $day일 $weekdayKorean',
        date: date,
        breakfast: breakfast,
        lunch: lunch,
        dinner: dinner);
  }
}

List<String> getMenuList(String menuString) {
  if (menuString.trim() == '') return ['아직 식단 정보가 없습니다.'];
  // 줄 바꿈을 기준으로 문자열 분할
  List<String> lines = menuString.split('\n');

  // 결과를 저장할 리스트
  List<String> result = [];

  // 임시로 값을 저장할 변수
  String buffer = '';

  for (String line in lines) {
    // 줄이 '*'로 시작하면 이전 항목에 붙임
    if (line.startsWith('*')) {
      buffer += line;
    } else {
      // 기존에 저장된 값이 있으면 결과 리스트에 추가
      if (buffer.isNotEmpty) {
        result.add(buffer);
      }
      // 새로운 값을 버퍼에 저장
      buffer = line;
    }
  }
  // 마지막 버퍼에 저장된 값을 리스트에 추가
  if (buffer.isNotEmpty) {
    result.add(buffer);
  }

  return result;
}
