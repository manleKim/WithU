import 'package:cbhs/common/dio/xmlDio.dart';
import 'package:cbhs/user/model/score_model.dart';
import 'package:cbhs/user/xmls/xmls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>(
  (ref) {
    final dio = ref.watch(xmlDioProvider);

    final repository = ScoreRepository(
        dio: dio, baseUrl: dotenv.env['DORMITORY_URL'] as String);

    return repository;
  },
);

class ScoreRepository {
  final String baseUrl;
  final Dio dio;

  ScoreRepository({required this.baseUrl, required this.dio});

  Future<List<ScoreDetail>> getTotalScore(String dormitoryNumber) async {
    final scoreDetailListXml = await _fetchXml(
        url: '$baseUrl/webRwrPnsInfoSearch.do',
        data: getScoreDetailXml(dormitoryNumber));

    final scoreDetailElements = scoreDetailListXml.findAllElements('Row');

    if (scoreDetailElements.isEmpty) return [];

    return scoreDetailElements
        .map((element) => ScoreDetail.fromXmlElement(element))
        .toList();
  }

  Future<ScoreModel> getScoreDetailList(String dormitoryNumber) async {
    final scoreXml = await _fetchXml(
        url: '$baseUrl/webRwrPnsInfoSearch.do',
        data: getUserAndRewordXml(dormitoryNumber));

    final scoreDetailListXml = await _fetchXml(
        url: '$baseUrl/webRwrPnsSearch.do',
        data: getScoreDetailXml(dormitoryNumber));

    final score = scoreXml
        .findAllElements('Col')
        .firstWhere(
            (element) => element.getAttribute('id') == 'RWRPNS_SCORE_TOT')
        .innerText;
    final scoreDetailElements = scoreDetailListXml.findAllElements('Row');

    return ScoreModel.fromXmlElement(
        score: score, scoreDetails: scoreDetailElements);
  }

  Future<XmlDocument> _fetchXml(
      {required String url, required String data}) async {
    final resp = await dio.post(url, data: data);
    return XmlDocument.parse(resp.data);
  }
}
