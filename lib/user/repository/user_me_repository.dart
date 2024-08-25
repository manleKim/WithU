import 'package:cbhs/common/dio/xmlDio.dart';
import 'package:cbhs/user/model/user_model.dart';
import 'package:cbhs/user/xmls/xmls.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xml/xml.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>(
  (ref) {
    final dio = ref.watch(xmlDioProvider);

    final repository = UserMeRepository(
        dio: dio, baseUrl: dotenv.env['DORMITORY_URL'] as String);

    return repository;
  },
);

class UserMeRepository {
  final String baseUrl;
  final Dio dio;

  UserMeRepository({required this.baseUrl, required this.dio});

  Future<UserModel> getMe(String dormitoryNumber) async {
    final isInXml = await _fetchXml(
        url: '$baseUrl/webinoutStatus.do', data: getInOutXml(dormitoryNumber));
    final userAndRewordXml = await _fetchXml(
        url: '$baseUrl/webRwrPnsInfoSearch.do',
        data: getUserAndRewordXml(dormitoryNumber));
    final reassessListXml = await _fetchXml(
        url: '$baseUrl/webStdLifeMidCntSearch.do',
        data: getReassessCountXml(dormitoryNumber, DateTime.now().year));

    final isInElements = isInXml.findAllElements('Col');
    final userAndRewordElements = userAndRewordXml.findAllElements('Col');
    final reassesListElements = reassessListXml.findAllElements('Col');

    return UserModel.fromXmlElement(
        userAndRewordElements: userAndRewordElements,
        isInElements: isInElements,
        reassessElements: reassesListElements);
  }

  Future<XmlDocument> _fetchXml(
      {required String url, required String data}) async {
    final resp = await dio.post(url, data: data);
    return XmlDocument.parse(resp.data);
  }
}
