import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/data.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/secure_storage/secure_storage.dart';
import 'package:cbhs/overNight/components/picked_date.dart';
import 'package:cbhs/overNight/data/reason.dart';
import 'package:cbhs/overNight/model/over_night_request_model.dart';
import 'package:cbhs/overNight/view/over_night_done_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class RecentOverNightInfo extends StatefulWidget {
  const RecentOverNightInfo({super.key});

  @override
  State<RecentOverNightInfo> createState() => _RecentOverNightInfoState();
}

class _RecentOverNightInfoState extends State<RecentOverNightInfo> {
  String? _period;
  String? _reasonType;
  String? _reasonDetail;
  String? _destinationState;
  String? _destinationCity;
  bool isVaild = false;

  Future<void> _fetchValues() async {
    _period = await storage.read(key: PERIOD_KEY);
    _reasonType = await storage.read(key: REASONTYPE_KEY);
    _reasonDetail = await storage.read(key: REASONDETAIL_KEY);
    _destinationState = await storage.read(key: DESTINATIONSTATE_KEY);
    _destinationCity = await storage.read(key: DESTINATIONCITY_KEY);

    setState(() {
      isVaild = _validate();
    });
  }

  bool _validate() {
    return _period != null &&
        _reasonType != null &&
        _reasonDetail != null &&
        _destinationState != null &&
        _destinationCity != null;
  }

  String? findMainLabel(
      {required String mainValue, required List<OverNightRequest> arr}) {
    for (var i in arr) {
      if (i.value == mainValue) return i.label;
    }
    return null; // If not found
  }

  String? findDetailLabel(
      {required String mainValue,
      required String detailValue,
      required List<OverNightRequest> arr}) {
    for (var i in arr) {
      if (i.value == mainValue) {
        for (var j in i.detailList!) {
          if (j.value == detailValue) {
            return j.label;
          }
        }
      }
    }
    return null; // If not found
  }

  @override
  void initState() {
    super.initState();
    _fetchValues();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              renderOverNightItem(context,
                  title: '기간', content: _validate() ? '$_period일' : '없음'),
              const VerticalDivider(width: 1, color: greyMiddleColor),
              renderOverNightItem(context,
                  title: '신청사유',
                  content: _validate()
                      ? findDetailLabel(
                          mainValue: _reasonType!,
                          detailValue: _reasonDetail!,
                          arr: reasons)!
                      : '없음'),
              const VerticalDivider(width: 1, color: greyMiddleColor),
              renderOverNightItem(context,
                  title: '목적지',
                  content: _validate()
                      ? findDetailLabel(
                          mainValue: _destinationState!,
                          detailValue: _destinationCity!,
                          arr: destinations)!
                      : '없음'),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_validate())
          OutlinedButton(
            onPressed: () {
              _showRecentOverNight(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              backgroundColor: mainColor,
              foregroundColor: backgroundColor,
              side: const BorderSide(color: mainColor),
            ),
            child: Text(
              'Quick하게 신청하기',
              style: AppTextStyles.buttonText(color: backgroundColor),
            ),
          ),
      ],
    );
  }

  SizedBox renderOverNightItem(BuildContext context,
      {required String title, required String content}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4,
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.regularText(color: greyMiddleColor),
          ),
          const SizedBox(height: 5),
          Text(content, style: AppTextStyles.buttonText()),
        ],
      ),
    );
  }

  void _showRecentOverNight(BuildContext context) {
    DateTime startDate;
    DateTime endDate;
    DateTime now = DateTime.now();
    String period = '1';
    if (now.hour < 1) {
      startDate = DateTime(now.year, now.month, now.day - 1);
    } else {
      startDate = DateTime(now.year, now.month, now.day);
    }
    endDate = startDate.add(Duration(days: int.parse(period)));
    final dateFormat = DateFormat('yyyy.MM.dd');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  "아래의 내용으로\n외박 신청할까요?",
                  style: AppTextStyles.subHeading(color: mainColor),
                ),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('기간',
                              style: AppTextStyles.regularText(
                                  color: greyMiddleColor)),
                          const SizedBox(height: 10),
                          Text('$period박 ${int.parse(period) + 1}일',
                              style: AppTextStyles.buttonText()
                                  .copyWith(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              DateTime tempEndDate = endDate;

                              await showModalBottomSheet(
                                context: context,
                                backgroundColor: backgroundColor,
                                useSafeArea: true,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 40,
                                            left: 20,
                                            right: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: PickedDate(
                                                        title: '시작',
                                                        date: startDate,
                                                        color:
                                                            greyMiddleColor)),
                                                Expanded(
                                                    flex: 1,
                                                    child: PickedDate(
                                                        title: '복귀',
                                                        date: tempEndDate,
                                                        color: mainColor)),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            TableCalendar(
                                              locale: 'ko_KR',
                                              focusedDay: tempEndDate,
                                              firstDay: startDate,
                                              lastDay: startDate.add(
                                                  const Duration(days: 90)),
                                              rangeStartDay: startDate,
                                              rangeEndDay: tempEndDate,
                                              selectedDayPredicate: (day) {
                                                return day.isAfter(startDate) &&
                                                    isSameDay(tempEndDate, day);
                                              },
                                              onDaySelected:
                                                  (selectedDay, focusedDay) {
                                                if (selectedDay
                                                        .isAfter(startDate) &&
                                                    !isSameDay(selectedDay,
                                                        startDate)) {
                                                  setState(() {
                                                    tempEndDate = selectedDay;
                                                  });
                                                }
                                              },
                                              headerStyle: const HeaderStyle(
                                                titleCentered: true,
                                                formatButtonVisible: false,
                                              ),
                                              calendarStyle: CalendarStyle(
                                                isTodayHighlighted: false,
                                                selectedDecoration:
                                                    const BoxDecoration(
                                                  color: mainColor,
                                                  shape: BoxShape.circle,
                                                ),

                                                // rangeStartDay 글자 조정
                                                rangeStartTextStyle:
                                                    const TextStyle(
                                                  color: semiBlackColor,
                                                  fontSize: 16.0,
                                                ),
                                                // rangeStartDay 모양 조정
                                                rangeStartDecoration:
                                                    BoxDecoration(
                                                  color: backgroundColor,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: mainColor),
                                                ),
                                                // range 색상 조정
                                                rangeHighlightColor:
                                                    const Color(0x8000AEBB),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            greyStrongColor,
                                                        side: const BorderSide(
                                                            color:
                                                                backgroundColor),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 13)),
                                                    child: Text(
                                                      '취소하기',
                                                      style: AppTextStyles
                                                          .buttonText(
                                                              color:
                                                                  backgroundColor),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        endDate = tempEndDate;

                                                        period = endDate
                                                            .difference(
                                                                startDate)
                                                            .inDays
                                                            .toString();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                        backgroundColor:
                                                            mainColor,
                                                        side: const BorderSide(
                                                            color:
                                                                backgroundColor),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 13)),
                                                    child: Text(
                                                      '확인하기',
                                                      style: AppTextStyles
                                                          .buttonText(
                                                              color:
                                                                  backgroundColor),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${dateFormat.format(startDate)} ~ ${dateFormat.format(endDate)}',
                                      style: AppTextStyles.buttonText()
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                                SvgPicture.asset(
                                    'assets/svg/overNight/application_calender.svg'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('신청사유',
                              style: AppTextStyles.regularText(
                                  color: greyMiddleColor)),
                          const SizedBox(height: 10),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Text(
                                    '${findMainLabel(mainValue: _reasonType!, arr: reasons)}',
                                    style: AppTextStyles.buttonText()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: VerticalDivider(
                                      width: 1, color: greyMiddleColor),
                                ),
                                Text(
                                    '${findDetailLabel(mainValue: _reasonType!, detailValue: _reasonDetail!, arr: reasons)}',
                                    style: AppTextStyles.buttonText()
                                        .copyWith(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('목적지',
                              style: AppTextStyles.regularText(
                                  color: greyMiddleColor)),
                          const SizedBox(height: 10),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Text(
                                    '${findMainLabel(mainValue: _destinationState!, arr: destinations)}',
                                    style: AppTextStyles.buttonText()
                                        .copyWith(fontWeight: FontWeight.w500)),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: VerticalDivider(
                                      width: 1, color: greyMiddleColor),
                                ),
                                Text(
                                    '${findDetailLabel(mainValue: _destinationState!, detailValue: _destinationCity!, arr: destinations)}',
                                    style: AppTextStyles.buttonText()
                                        .copyWith(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: greyStrongColor,
                      side: const BorderSide(color: backgroundColor),
                    ),
                    child: Text("돌아가기",
                        style:
                            AppTextStyles.buttonText(color: backgroundColor)),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: mainColor,
                      side: const BorderSide(color: backgroundColor),
                    ),
                    child: Text("신청하기",
                        style:
                            AppTextStyles.buttonText(color: backgroundColor)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OverNightDoneScreen(
                              period: int.parse(period),
                              type: 'overNight',
                              startDate: startDate,
                              endDate: endDate,
                              reasonType: _reasonType!,
                              reasonDetail: _reasonDetail!,
                              destinationState: _destinationState!,
                              destinationCity: _destinationCity!)));
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
