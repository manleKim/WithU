import 'package:cbhs/user/model/reassess_model.dart';
import 'package:xml/xml.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

class UserModelLoading extends UserModelBase {}

class UserModel extends UserModelBase {
  final String id;
  final String dormitoryNumber;
  final String name;
  final String roomNum;
  final bool isIn;
  final String rewordScore;
  final List<ReassessElementModel> reassessList;

  UserModel({
    required this.id,
    required this.dormitoryNumber,
    required this.name,
    required this.roomNum,
    required this.isIn,
    required this.rewordScore,
    required this.reassessList,
  });

  factory UserModel.fromXmlElement(
      {required Iterable<XmlElement> userAndRewordElements,
      required Iterable<XmlElement> isInElements,
      required Iterable<XmlElement> reassessElements}) {
    final id = userAndRewordElements
        .firstWhere((element) => element.getAttribute('id') == 'IDX')
        .innerText;
    final dormitoryNumber = userAndRewordElements
        .firstWhere((element) => element.getAttribute('id') == 'SCHAFS_NO')
        .innerText;
    final name = userAndRewordElements
        .firstWhere((element) => element.getAttribute('id') == 'RESCHR_NM')
        .innerText;
    final roomNum = userAndRewordElements
        .firstWhere((element) => element.getAttribute('id') == 'ROOM_NO')
        .innerText;
    final isIn = isInElements
            .firstWhere(
                (element) => element.getAttribute('id') == 'NOW_STTS_CD')
            .innerText ==
        "입실";
    final rewordScore = userAndRewordElements
        .firstWhere(
            (element) => element.getAttribute('id') == 'RWRPNS_SCORE_TOT')
        .innerText;

    // 특강
    final spelecTot = int.parse(reassessElements
        .firstWhere((element) => element.getAttribute('id') == 'SPELEC_TOT')
        .innerText);
    // 행사
    final eventTot = int.parse(reassessElements
        .firstWhere((element) => element.getAttribute('id') == 'EVENT_TOT')
        .innerText);
    // 안전교육
    final safeTot = int.parse(reassessElements
        .firstWhere((element) => element.getAttribute('id') == 'SAFE_TOT')
        .innerText);
    // 봉사활동
    final serviceTot = int.parse(reassessElements
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

    return UserModel(
      id: id,
      dormitoryNumber: dormitoryNumber,
      name: name,
      roomNum: roomNum,
      isIn: isIn,
      rewordScore: rewordScore,
      reassessList: reassessList,
    );
  }
}
