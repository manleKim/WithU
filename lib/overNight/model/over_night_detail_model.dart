import 'package:xml/xml.dart';

abstract class OverNightDetailModelBase {}

class OverNightDetailModelError extends OverNightDetailModelBase {
  final String message;

  OverNightDetailModelError({
    required this.message,
  });
}

class OverNightDetailModelLoading extends OverNightDetailModelBase {}

class OverNightDetailEvent extends OverNightDetailModelBase {
  Map<DateTime, List<Event>> events;

  OverNightDetailEvent(this.events);

  factory OverNightDetailEvent.fromXmlElement(
    Iterable<XmlElement> overNightDetailElements,
  ) {
    if (overNightDetailElements.isEmpty) return OverNightDetailEvent({});
    return OverNightDetailEvent(overNightDetailElements
        .fold<Map<DateTime, List<Event>>>({}, (events, row) {
      final inputStatusCd = row
          .findElements('Col')
          .firstWhere((col) => col.getAttribute('id') == 'INPUT_STTUS_CD')
          .innerText;
      final stayOutFromDt = row
          .findElements('Col')
          .firstWhere((col) => col.getAttribute('id') == 'STAYOUT_FR_DT')
          .innerText;
      final stayOutToDt = row
          .findElements('Col')
          .firstWhere((col) => col.getAttribute('id') == 'STAYOUT_TO_DT')
          .innerText;

      // Date 스트링을 DateTime 객체로 변환
      DateTime startDate =
          DateTime.parse(stayOutFromDt.substring(0, 8)).toLocal();

      DateTime endDate = DateTime.parse(stayOutToDt.substring(0, 8)).toLocal();

      final event = Event(inputStatusCd, startDate, endDate);

      // 시작날짜부터 복귀날짜 동안의 date list를 생성
      final dates = List.generate(endDate.difference(startDate).inDays + 1,
          (index) => startDate.add(Duration(days: index)));

      // events 맵 생성
      for (var date in dates) {
        events.update(date, (existingEvents) => existingEvents..add(event),
            ifAbsent: () => [event]);
      }

      return events;
    }));
  }
}

class Event {
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  Event(this.type, this.startDate, this.endDate);

  @override
  String toString() =>
      'Event(type: $type, startDate: $startDate, endDate: $endDate)';
}
