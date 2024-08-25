import 'package:cbhs/common/dio/xmlDio.dart';
import 'package:cbhs/overNight/model/over_night_detail_model.dart';
import 'package:cbhs/user/xmls/xmls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';

final overNightRepositoryProvider = Provider<OverNightRepository>(
  (ref) {
    final dio = ref.watch(xmlDioProvider);

    final repository = OverNightRepository(
        dio: dio, baseUrl: dotenv.env['DORMITORY_URL'] as String);

    return repository;
  },
);

class OverNightRepository {
  final String baseUrl;
  final Dio dio;

  OverNightRepository({required this.baseUrl, required this.dio});

  Future<OverNightDetailEvent> getOverNightDetailList(
      String dormitoryNumber) async {
    final overNightDetailXml = await _fetchXml(
        url: '$baseUrl/webStyoutHomeDetailSearch.do',
        data: getOverNightDetailXml(dormitoryNumber));
    final rows = overNightDetailXml.findAllElements('Row');

    return OverNightDetailEvent.fromXmlElement(rows);
  }

  Future<XmlDocument> _fetchXml(
      {required String url, required String data}) async {
    final resp = await dio.post(url, data: data);
    return XmlDocument.parse(resp.data);
  }
}
