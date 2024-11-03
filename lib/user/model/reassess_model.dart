import 'package:xml/xml.dart';

abstract class ReassessModelBase {}

class ReassessModelError extends ReassessModelBase {
  final String message;

  ReassessModelError({
    required this.message,
  });
}

class ReassessModelLoading extends ReassessModelBase {}

class ReassessModel extends ReassessModelBase {
  final List<ReassessElementModel> reassessList;
  final List<ReassessDetailModel> detailList;

  ReassessModel({required this.reassessList, required this.detailList});

  factory ReassessModel.fromXmlElement(
      {required Iterable<XmlElement> reassessCountElements,
      required Iterable<XmlElement> reassessDetailElements}) {
    // 특강
    final spelecTot = int.parse(reassessCountElements
        .firstWhere((element) => element.getAttribute('id') == 'SPELEC_TOT')
        .innerText);
    // 행사
    final eventTot = int.parse(reassessCountElements
        .firstWhere((element) => element.getAttribute('id') == 'EVENT_TOT')
        .innerText);
    // 안전교육
    final safeTot = int.parse(reassessCountElements
        .firstWhere((element) => element.getAttribute('id') == 'SAFE_TOT')
        .innerText);
    // 봉사활동
    final serviceTot = int.parse(reassessCountElements
        .firstWhere((element) => element.getAttribute('id') == 'SERVICE_TOT')
        .innerText);
    final reassessList = [
      ReassessElementModel(
        name: '행사 및 특강',
        count: spelecTot + eventTot,
        satisfiedCount: 2,
      ),
      ReassessElementModel(
        name: '안전교육',
        count: safeTot,
        satisfiedCount: 1,
      ),
      ReassessElementModel(
        name: '봉사',
        count: serviceTot,
        satisfiedCount: 1,
      ),
    ];

    if (reassessDetailElements.isEmpty) {
      return ReassessModel(reassessList: reassessList, detailList: []);
    }

    return ReassessModel(
        reassessList: reassessList,
        detailList: reassessDetailElements
            .map((element) => ReassessDetailModel.fromXmlElement(element))
            .toList());
  }
}

class ReassessDetailModel {
  final String title;
  final String reassessType;
  final String createdAt;

  ReassessDetailModel(
      {required this.title,
      required this.reassessType,
      required this.createdAt});

  factory ReassessDetailModel.fromXmlElement(XmlElement reassessDetailElement) {
    final cols = reassessDetailElement.findAllElements('Col');

    final title = cols
        .firstWhere((col) => col.getAttribute('id') == 'LCTRE_NM')
        .innerText;
    final reassessType = cols
        .firstWhere((col) => col.getAttribute('id') == 'LCTRE_SE_NM')
        .innerText;
    final createdAt =
        cols.firstWhere((col) => col.getAttribute('id') == 'EDC_DT').innerText;

    return ReassessDetailModel(
        title: title, reassessType: reassessType, createdAt: createdAt);
  }
}

class ReassessElementModel {
  final String name;
  final int count;
  final int satisfiedCount;

  ReassessElementModel({
    required this.name,
    required this.count,
    required this.satisfiedCount,
  });

  factory ReassessElementModel.fromXmlElement(
      {required String name, required int count, required int satisfiedCount}) {
    return ReassessElementModel(
        name: name, count: count, satisfiedCount: satisfiedCount);
  }
}
