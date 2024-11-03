import 'package:cbhs/common/dio/xmlDio.dart';
import 'package:cbhs/overNight/model/over_night_detail_model.dart';
import 'package:cbhs/overNight/xmls.dart';
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
    XmlDocument overNightDetailXml;
    if (dormitoryNumber == "19-1049") {
      overNightDetailXml = await _fetchXml(
          url: 'http://15.164.196.234:3000/overNight/list',
          data: getOverNightDetailXml(dormitoryNumber));
    } else {
      overNightDetailXml = await _fetchXml(
          url: '$baseUrl/webStyoutHomeDetailSearch.do',
          data: getOverNightDetailXml(dormitoryNumber));
    }

    final rows = overNightDetailXml.findAllElements('Row');

    return OverNightDetailEvent.fromXmlElement(rows);
  }

  Future<XmlDocument> _fetchXml(
      {required String url, required String data}) async {
    final resp = await dio.post(url, data: data);
    return XmlDocument.parse(resp.data);
  }

  Future<bool> postOverNight(
      {required String id,
      required String type,
      required String startDate,
      required String endDate,
      required String reasonType,
      required String reasonDetail,
      required String destinationState,
      required String destinationCity}) async {
    Response<dynamic> resp;
    if (type == 'overNight') {
      if (id == "7057") {
        resp = await dio.post('http://15.164.196.234:3000/overNight/save',
            data: postOverNightXml(
                id: id,
                startDate: startDate,
                endDate: endDate,
                reasonType: reasonType,
                reasonDetail: reasonDetail,
                destinationState: destinationState,
                destinationCity: destinationCity));
      } else {
        resp = await dio.post('$baseUrl/webOverNightPopSave.do',
            data: postOverNightXml(
                id: id,
                startDate: startDate,
                endDate: endDate,
                reasonType: reasonType,
                reasonDetail: reasonDetail,
                destinationState: destinationState,
                destinationCity: destinationCity));
      }
    } else {
      if (id == "7057") {
        resp = await dio.post('http://15.164.196.234:3000/goHome/save',
            data: postGoHomeXml(
                id: id,
                startDate: startDate,
                endDate: endDate,
                reasonType: reasonType,
                reasonDetail: reasonDetail,
                destinationState: destinationState,
                destinationCity: destinationCity));
      } else {
        resp = await dio.post('$baseUrl/webGoHomePopSave.do',
            data: postGoHomeXml(
                id: id,
                startDate: startDate,
                endDate: endDate,
                reasonType: reasonType,
                reasonDetail: reasonDetail,
                destinationState: destinationState,
                destinationCity: destinationCity));
      }
    }

    if (resp.statusCode != 200) return false;
    return true;
  }
}
