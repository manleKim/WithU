import 'package:cbhs/common/dio/xmlDio.dart';
import 'package:cbhs/user/model/reassess_model.dart';
import 'package:cbhs/user/xmls/xmls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';

final reassessRepositoryProvider = Provider<ReassessRepository>(
  (ref) {
    final dio = ref.watch(xmlDioProvider);

    final repository = ReassessRepository(
        dio: dio, baseUrl: dotenv.env['DORMITORY_URL'] as String);

    return repository;
  },
);

class ReassessRepository {
  final String baseUrl;
  final Dio dio;

  ReassessRepository({required this.baseUrl, required this.dio});

  Future<ReassessModel> getReassessDetailList(String dormitoryNumber) async {
    XmlDocument reassessCountXml;
    XmlDocument reassessDetailListXml;
    if (dormitoryNumber == "19-1049") {
      reassessCountXml = await _fetchXml(
          url: 'http://15.164.196.234:3000/reassess/cnt',
          data: getReassessCountXml(dormitoryNumber, DateTime.now().year));
      reassessDetailListXml = await _fetchXml(
          url: 'http://15.164.196.234:3000/reassess/list',
          data: getReassessCountXml(dormitoryNumber, DateTime.now().year));
    } else {
      reassessCountXml = await _fetchXml(
          url: '$baseUrl/webStdLifeMidCntSearch.do',
          data: getReassessCountXml(dormitoryNumber, DateTime.now().year));
      reassessDetailListXml = await _fetchXml(
          url: '$baseUrl/webStdLifeBotSearch.do',
          data: getReassessDetailXml(dormitoryNumber, DateTime.now().year));
    }

    final reassessCount = reassessCountXml.findAllElements('Col');
    final reassessDetailElements = reassessDetailListXml.findAllElements('Row');

    return ReassessModel.fromXmlElement(
        reassessCountElements: reassessCount,
        reassessDetailElements: reassessDetailElements);
  }

  Future<XmlDocument> _fetchXml(
      {required String url, required String data}) async {
    final resp = await dio.post(url, data: data);
    return XmlDocument.parse(resp.data);
  }
}
