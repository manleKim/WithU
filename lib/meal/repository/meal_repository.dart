import 'package:cbhs/common/dio/htmlDio.dart';
import 'package:cbhs/meal/model/meal_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;

final mealRepositoryProvider = Provider<MealRepository>(
  (ref) {
    final dio = ref.watch(htmlDioProvider);

    final repository =
        MealRepository(dio: dio, baseUrl: dotenv.env['MEAL_URL'] as String);

    return repository;
  },
);

class MealRepository {
  final String baseUrl;
  final Dio dio;

  MealRepository({required this.baseUrl, required this.dio});

  Future<MealListModel> getMeal(bool demo) async {
    String currentWeekHtml;
    String previousWeekHtml;
    String nextWeekHtml;
    if (demo) {
      currentWeekHtml = await _fetchHtml('http://15.164.196.234:3000/meal/0');
      previousWeekHtml = await _fetchHtml('http://15.164.196.234:3000/meal/-1');
      nextWeekHtml = await _fetchHtml('http://15.164.196.234:3000/meal/1');
    } else {
      currentWeekHtml = await _fetchHtml(baseUrl);
      previousWeekHtml = await _fetchHtml('$baseUrl?searchWeek=-1');
      nextWeekHtml = await _fetchHtml('$baseUrl?searchWeek=1');
    }

    final currentWeekMeals = _parseMeals(currentWeekHtml);
    final previousWeekMeals = _parseMeals(previousWeekHtml);
    final nextWeekMeals = _parseMeals(nextWeekHtml);

    final allMeals = [
      ...previousWeekMeals,
      ...currentWeekMeals,
      ...nextWeekMeals
    ];
    return MealListModel(mealList: allMeals);
  }

  Future<String> _fetchHtml(String url) async {
    final resp = await dio.get(url);
    return resp.data;
  }

  List<MealModel> _parseMeals(String html) {
    final doc = html_parser.parse(html);
    // .fplan_plan 각 요일 수집 => [일 식단, 월 식단, 화 식단, ... , 토 식단]
    final dailyPlans = doc.querySelectorAll('.fplan_plan');
    return dailyPlans.map((plan) {
      // 각 요일 안에 조식, 중식, 석식 수집 (p)
      final meals = plan.querySelectorAll('p');
      return MealModel.fromHtmlElement(meals);
    }).toList();
  }
}
