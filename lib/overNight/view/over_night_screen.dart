import 'package:cbhs/common/layout/padding_layout.dart';
import 'package:cbhs/overNight/components/picked_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:cbhs/common/const/colors.dart';
import 'package:cbhs/common/const/font_styles.dart';
import 'package:cbhs/common/layout/default_layout.dart';
import 'package:cbhs/overNight/data/reason.dart';
import 'package:cbhs/overNight/model/over_night_request_model.dart';
import 'package:cbhs/overNight/view/over_night_done_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class OverNightScreen extends ConsumerStatefulWidget {
  static String get routeName => 'overNight';

  const OverNightScreen({super.key});

  @override
  ConsumerState<OverNightScreen> createState() => _OverNightScreenState();
}

class _OverNightScreenState extends ConsumerState<OverNightScreen> {
  String selectedOverNightType = 'overNight';
  String seletedButton = 'direct';

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('외박 신청하기'),
                onTap: () {
                  setState(() {
                    selectedOverNightType = 'overNight';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('귀향 신청하기'),
                onTap: () {
                  setState(() {
                    selectedOverNightType = 'returnHome';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message:
                            "외박 신청 가능 시간 05:00 부터 익일 01:00까지\n\n귀향: 다음 각 호의 사유로 매월 1일과 16일 기준 연속으로 15일 이상 재사하지 않는 것\n\t1. 방학 기간(1-2월, 7-8월)\n\t2. 전공과 관련한 실습\n\t3. 질병치료 목적으로 입원 또는 귀향\n\n기간 설정시 마지막날은 복귀(귀사)일임을 참고해주세요.",
                        child: Icon(
                          Icons.info_outline,
                          color: greyMiddleColor,
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Row(
                            children: [
                              Text(
                                selectedOverNightType == 'overNight'
                                    ? '외박 신청하기'
                                    : '귀향 신청하기',
                                style: AppTextStyles.subHeading(),
                              ),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         color: greyStrongColor,
                      //         borderRadius: BorderRadius.circular(15)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 14, vertical: 5),
                      //       child: Row(
                      //         children: [
                      //           const Icon(Icons.settings,
                      //               size: 15, color: backgroundColor),
                      //           const SizedBox(width: 5),
                      //           Text(
                      //             '커스텀 관리',
                      //             style: AppTextStyles.detailedInfoText(
                      //                     color: backgroundColor)
                      //                 .copyWith(fontWeight: FontWeight.w600),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            // 커스텀 선택 부분
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         setState(() {
            //           seletedButton = 'custom';
            //         });
            //       },
            //       child: Container(
            //         width: MediaQuery.of(context).size.width / 2,
            //         padding: const EdgeInsets.symmetric(vertical: 13),
            //         decoration: seletedButton == 'custom'
            //             ? const BoxDecoration(
            //                 border:
            //                     Border(bottom: BorderSide(color: Colors.black)))
            //             : const BoxDecoration(
            //                 border: Border(
            //                     bottom: BorderSide(color: backgroundColor))),
            //         child: Text(
            //           '커스텀 선택',
            //           style: AppTextStyles.buttonText(),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: () {
            //         setState(() {
            //           seletedButton = 'direct';
            //         });
            //       },
            //       child: Container(
            //         width: MediaQuery.of(context).size.width / 2,
            //         padding: const EdgeInsets.symmetric(vertical: 13),
            //         decoration: seletedButton == 'direct'
            //             ? const BoxDecoration(
            //                 border:
            //                     Border(bottom: BorderSide(color: Colors.black)))
            //             : const BoxDecoration(
            //                 border: Border(
            //                     bottom: BorderSide(color: backgroundColor))),
            //         child: Text(
            //           '직접 입력',
            //           style: AppTextStyles.buttonText(),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // 본체 부분
            DirectOverNight(selectedOverNightType: selectedOverNightType),
          ],
        ),
      ),
    );
  }
}

class DirectOverNight extends ConsumerStatefulWidget {
  final String selectedOverNightType;

  const DirectOverNight({required this.selectedOverNightType, super.key});

  @override
  ConsumerState<DirectOverNight> createState() => _DirectOverNightState();
}

class _DirectOverNightState extends ConsumerState<DirectOverNight> {
  int selectedDays = 1;
  OverNightRequest? reasonType;
  OverNightRequest? reasonDetail;
  OverNightRequest? destinationState;
  OverNightRequest? destinationCity;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() {
    DateTime now = DateTime.now();
    if (now.hour < 1) {
      startDate = DateTime(now.year, now.month, now.day - 1);
    } else {
      startDate = DateTime(now.year, now.month, now.day);
    }
    endDate = startDate.add(const Duration(days: 1));
  }

  bool _validate() {
    if (widget.selectedOverNightType == 'overNight') {
      return reasonType != null &&
          reasonDetail != null &&
          destinationState != null &&
          destinationCity != null;
    }
    return selectedDays >= 14 &&
        destinationState != null &&
        destinationCity != null;
  }

  void _updateEndDate() {
    setState(() {
      endDate = startDate.add(Duration(days: selectedDays));
    });
  }

  void _updateSelectedDays() {
    setState(() {
      selectedDays = endDate.difference(startDate).inDays;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime tempEndDate = endDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, bottom: 40, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child: PickedDate(
                              title: '시작',
                              date: startDate,
                              color: greyMiddleColor)),
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
                    lastDay: startDate.add(const Duration(days: 90)),
                    rangeStartDay: startDate,
                    rangeEndDay: tempEndDate,
                    selectedDayPredicate: (day) {
                      return day.isAfter(startDate) &&
                          isSameDay(tempEndDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (selectedDay.isAfter(startDate) &&
                          !isSameDay(selectedDay, startDate)) {
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
                      selectedDecoration: const BoxDecoration(
                        color: mainColor,
                        shape: BoxShape.circle,
                      ),

                      // rangeStartDay 글자 조정
                      rangeStartTextStyle: const TextStyle(
                        color: semiBlackColor,
                        fontSize: 16.0,
                      ),
                      // rangeStartDay 모양 조정
                      rangeStartDecoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: mainColor),
                      ),
                      // range 색상 조정
                      rangeHighlightColor: const Color(0x8000AEBB),
                    ),
                  ),
                  // CalendarDatePicker(
                  //   initialDate: tempEndDate,
                  //   firstDate: startDate.add(const Duration(days: 1)),
                  //   lastDate: startDate.add(const Duration(days: 90)),
                  //   onDateChanged: (DateTime date) {
                  //     setState(() {
                  //       tempEndDate = date;
                  //     });
                  //   },
                  //   currentDate: startDate,
                  //   selectableDayPredicate: (DateTime date) {
                  //     return date.isAfter(startDate);
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: greyStrongColor,
                              side: const BorderSide(color: backgroundColor),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13)),
                          child: Text(
                            '취소하기',
                            style: AppTextStyles.buttonText(
                                color: backgroundColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              endDate = tempEndDate;
                              _updateSelectedDays();
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: mainColor,
                              side: const BorderSide(color: backgroundColor),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 13)),
                          child: Text(
                            '확인하기',
                            style: AppTextStyles.buttonText(
                                color: backgroundColor),
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
  }

  void _showReasonTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: reasons
                .map(
                  (reason) => ListTile(
                    title: Text(reason.label),
                    onTap: () {
                      setState(() {
                        reasonType = reason;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _showReasonDetailBottomSheet(BuildContext context) {
    int idx =
        reasons.indexWhere((element) => element.value == reasonType!.value);
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: reasons[idx]
                .detailList!
                .map(
                  (reason) => ListTile(
                    title: Text(reason.label),
                    onTap: () {
                      setState(() {
                        reasonDetail = reason;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _showDestinationStateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: destinations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(destinations[index].label),
                      onTap: () {
                        setState(() {
                          destinationState = destinations[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showDestinationCityBottomSheet(BuildContext context) {
    int idx = destinations
        .indexWhere((element) => element.value == destinationState!.value);
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: ListView.builder(
                itemCount: destinations[idx].detailList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(destinations[idx].detailList![index].label),
                    onTap: () {
                      setState(() {
                        destinationCity = destinations[idx].detailList![index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Expanded(
      child: Container(
        color: greyLightColor,
        child: PaddingLayout(
          top: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.selectedOverNightType != 'overNight')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                            '귀향은 14박 15일부터 신청할 수 있습니다.\n해당하지 않을 경우 외박으로 신청하시길 바랍니다.',
                            style:
                                AppTextStyles.regularText(color: Colors.red)),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: greyMiddleColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '기간',
                              style: AppTextStyles.regularText()
                                  .copyWith(color: greyNavigationColor),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$selectedDays박 ${selectedDays + 1}일',
                                    style: AppTextStyles.basicText(),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if ((widget.selectedOverNightType ==
                                                'overNight' &&
                                            selectedDays > 1) ||
                                        (widget.selectedOverNightType !=
                                                'overNight' &&
                                            selectedDays > 14)) {
                                      selectedDays--;
                                      _updateEndDate();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  '해당 기간 이하로 신청할 수 없습니다.')));
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      'assets/svg/overNight/application_minus.svg'),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    selectedDays++;
                                    _updateEndDate();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/svg/overNight/application_plus.svg',
                                    colorFilter: const ColorFilter.mode(
                                        greyMiddleColor, BlendMode.dstIn),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${dateFormat.format(startDate)} ~ ${dateFormat.format(endDate)}',
                                      style: AppTextStyles.basicText(),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                      'assets/svg/overNight/application_calender.svg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.selectedOverNightType == 'overNight')
                      const SizedBox(height: 15),
                    if (widget.selectedOverNightType == 'overNight')
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: greyMiddleColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '신청사유',
                                style: AppTextStyles.regularText()
                                    .copyWith(color: greyNavigationColor),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () =>
                                    _showReasonTypeBottomSheet(context),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          reasonType != null
                                              ? reasonType!.label
                                              : '사유 유형',
                                          style: AppTextStyles.basicText()),
                                    ),
                                    SvgPicture.asset(
                                        'assets/svg/overNight/application_dropdown_mid grey.svg'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  if (reasonType != null) {
                                    _showReasonDetailBottomSheet(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('사유 유형을 먼저 지정해주세요.')));
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          reasonDetail != null
                                              ? reasonDetail!.label
                                              : '세부 사유',
                                          style: AppTextStyles.basicText()),
                                    ),
                                    SvgPicture.asset(
                                        'assets/svg/overNight/application_dropdown_mid grey.svg'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: greyMiddleColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '목적지',
                              style: AppTextStyles.regularText()
                                  .copyWith(color: greyNavigationColor),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () =>
                                  _showDestinationStateBottomSheet(context),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        destinationState != null
                                            ? destinationState!.label
                                            : '도',
                                        style: AppTextStyles.basicText()),
                                  ),
                                  SvgPicture.asset(
                                      'assets/svg/overNight/application_dropdown_mid grey.svg'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                if (destinationState != null) {
                                  _showDestinationCityBottomSheet(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('목적지 도를 먼저 입력해주세요.')));
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        destinationCity != null
                                            ? destinationCity!.label
                                            : '시/군/읍',
                                        style: AppTextStyles.basicText()),
                                  ),
                                  SvgPicture.asset(
                                      'assets/svg/overNight/application_dropdown_mid grey.svg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: _validate()
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OverNightDoneScreen(
                                period: selectedDays,
                                type: widget.selectedOverNightType,
                                startDate: startDate,
                                endDate: endDate,
                                reasonType: reasonType!.value,
                                reasonDetail: reasonDetail!.value,
                                destinationState: destinationState!.value,
                                destinationCity: destinationCity!.value)));
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: _validate() ? mainColor : greyStrongColor,
                  foregroundColor: backgroundColor,
                  side: BorderSide(
                      color: _validate() ? mainColor : greyStrongColor),
                ),
                child: Text(
                  _validate() ? '신청하기' : '입력완료 후 신청하기',
                  style: AppTextStyles.buttonText(color: backgroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
