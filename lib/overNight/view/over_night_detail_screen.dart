import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/component_layout.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/overNight/components/over_night_type.dart';
import 'package:cbhs/overNight/model/over_night_detail_model.dart';
import 'package:cbhs/overNight/provider/over_night_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class OverNightDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'overNightDetail';

  const OverNightDetailScreen({super.key});

  @override
  ConsumerState<OverNightDetailScreen> createState() =>
      _OverNightDetailScreenState();
}

class _OverNightDetailScreenState extends ConsumerState<OverNightDetailScreen> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    ref.read(overNightProvider.notifier).getOverNightDetailList();
  }

  Color _getMarkerColor(Event event) {
    switch (event.type) {
      case '01': // 일반 외박
        return mainColor;
      case '02': // 귀가
        return Colors.purple;
      case '04': // 무단외박
        return Colors.red;
      case '05': // 귀사시간 이후 전화외박 => 일반 외박과 동일하게 처리
        return Colors.blue;
      case 'C': // 귀향
        return const Color(0xFFC8B158);
      default: // 기타
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(overNightProvider);
    return DefaultLayout(
      appbar: AppBar(
        title: const Text('외박 및 귀향 캘린더'),
        titleTextStyle: AppTextStyles.naviTitle(),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    OverNightType(color: mainColor, typeName: '일반외박'),
                    OverNightType(color: Colors.blue, typeName: '귀사시간 이후 전화외박'),
                    OverNightType(color: Colors.purple, typeName: '귀가'),
                    OverNightType(color: Color(0xFFC8B158), typeName: '귀향'),
                    OverNightType(color: Colors.red, typeName: '무단외박'),
                    OverNightType(color: Colors.black, typeName: '기타'),
                  ],
                ),
              ),
              state is OverNightDetailModelLoading
                  ? const CircularProgressIndicator(
                      color: mainColor,
                    )
                  : state is OverNightDetailModelError
                      ? Text(state.message)
                      : state is OverNightDetailEvent
                          ? ComponentLayout(
                              child: TableCalendar(
                                locale: 'ko_KR',
                                focusedDay: now,
                                firstDay: DateTime(now.year, now.month, 1),
                                lastDay: DateTime(now.year, now.month + 1, 1)
                                    .subtract(const Duration(days: 1)),
                                eventLoader: (day) {
                                  List<Event> events =
                                      _getEventsForDay(day, state.events);

                                  events.sort((a, b) =>
                                      a.startDate.compareTo(b.startDate));
                                  return events;
                                },
                                headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonVisible: false,
                                  leftChevronVisible: false,
                                  rightChevronVisible: false,
                                  titleTextStyle: AppTextStyles.buttonText(),
                                  headerPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                ),
                                calendarStyle: const CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (_, __, events) {
                                    if (events.isEmpty) return const SizedBox();

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: events.map((event) {
                                        final typeEvent = event as Event;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 1.5),
                                          width: 8.0,
                                          height: 8.0,
                                          decoration: BoxDecoration(
                                            color: _getMarkerColor(typeEvent),
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(
      DateTime day, Map<DateTime, List<Event>> events) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }
}
