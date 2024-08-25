import 'package:xml/xml.dart';

abstract class ScoreModelBase {}

class ScoreModelError extends ScoreModelBase {
  final String message;

  ScoreModelError({
    required this.message,
  });
}

class ScoreModelLoading extends ScoreModelBase {}

class ScoreModel extends ScoreModelBase {
  final int totalScore;
  final List<ScoreDetail> detailList;

  ScoreModel({required this.totalScore, required this.detailList});

  factory ScoreModel.fromXmlElement(
      {required String score, required Iterable<XmlElement> scoreDetails}) {
    if (scoreDetails.isEmpty) {
      return ScoreModel(totalScore: int.parse(score), detailList: []);
    }

    return ScoreModel(
        totalScore: int.parse(score),
        detailList: scoreDetails
            .map((scoreDeatil) => ScoreDetail.fromXmlElement(scoreDeatil))
            .toList());
  }
}

class ScoreDetail {
  final String reason;
  final int score;
  final String createdAt;

  ScoreDetail(
      {required this.reason, required this.score, required this.createdAt});

  factory ScoreDetail.fromXmlElement(XmlElement scoreDetail) {
    final cols = scoreDetail.findAllElements('Col');

    final reason =
        cols.firstWhere((col) => col.getAttribute('id') == 'CN').innerText;
    final score = cols
        .firstWhere((col) => col.getAttribute('id') == 'RWRPNS_SCORE')
        .innerText;
    final createdAt = cols
        .firstWhere((col) => col.getAttribute('id') == 'RWRPNS_DT')
        .innerText;

    return ScoreDetail(
        reason: reason, score: int.parse(score), createdAt: createdAt);
  }
}
