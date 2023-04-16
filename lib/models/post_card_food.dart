import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';
class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Material(
          color: Colors.white,
          elevation: 2,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10,top: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.snap["username"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        '${(widget.snap['datePublished'] as Timestamp).toDate().day} ${_getMonth((widget.snap['datePublished'] as Timestamp).toDate().month)} ${(widget.snap['datePublished'] as Timestamp).toDate().year}, ${_formatTime((widget.snap['datePublished'] as Timestamp).toDate())}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.snap["offerPlace"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.snap["offerLink"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.snap["offerDesc"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),// Text(
                //   'Time of departure: ${selectdat.day} ${_getMonth(selectdat.month)} ${selectdat.year}, ${_formatTime(selectdat)}',
                //   style: const TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10,),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 30),
                //   child: Text(
                //     addnote == "" ? 'No additional notes' : 'Additional notes:\n $addnote',
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // const SizedBox(height: 30,),
              ],
            ),
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

