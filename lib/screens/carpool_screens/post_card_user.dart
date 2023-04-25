import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;

  const PostCard({Key? key, required this.snap, required this.hello})
      : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  String getHello() {
    return widget.hello;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
            builder: (context) {
              return _AddPopupCard(
                key: UniqueKey(),
                hello: getHello(),
                start: widget.snap['start'],
                destination: widget.snap['destination'],
                charge: widget.snap['expectedPerHeadCharge'],
                vehicle: widget.snap['vehicle'],
                exstart: widget.snap['exacstart'],
                exdest: widget.snap['exacdest'],
                addnote: widget.snap['addnote'],
                selectdat:
                    (widget.snap['timeOfDeparture'] as Timestamp).toDate(),
              );
            },
            settings: const RouteSettings(name: "add_popup_card")));
      },
      child: Hero(
        tag: widget.hello,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.yMMMd().format(
                                widget.snap['datePublished'].toDate(),
                              ),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 28.0, top: 15),
                            child: Text(
                              '${widget.snap['start']} \u27A4 ${widget.snap['destination']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.snap['vehicle'] ?? ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.snap['expectedPerHeadCharge'] ?? ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(widget.snap['timeOfDeparture'] as Timestamp).toDate().day} ${_getMonth((widget.snap['timeOfDeparture'] as Timestamp).toDate().month)} ${(widget.snap['timeOfDeparture'] as Timestamp).toDate().year}, ${_formatTime((widget.snap['timeOfDeparture'] as Timestamp).toDate())}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? 'am' : 'pm';
  return '$hour:$minute $period';
}

class _AddPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  final String hello;
  final String start, destination, charge, vehicle, exstart, exdest, addnote;
  final DateTime selectdat;

  const _AddPopupCard(
      {Key? key,
      required this.hello,
      required this.start,
      required this.destination,
      required this.charge,
      required this.vehicle,
      required this.exstart,
      required this.exdest,
      required this.addnote,
      required this.selectdat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Hero(
          tag: hello,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: cardcolor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$start \u27A4 $destination',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Exact start address:\n $exstart',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Exact destination address:\n $exdest',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preferred Vehicle: $vehicle \nExpected price per head: $charge',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Text(
                    'Time of departure: ${selectdat.day} ${_getMonth(selectdat.month)} ${selectdat.year}, ${_formatTime(selectdat)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      addnote == ""
                          ? 'No additional notes'
                          : 'Additional notes:\n $addnote',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
