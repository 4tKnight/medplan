import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medplan/utils/global.dart';

class CustomExpandableWidget extends StatefulWidget {
  CustomExpandableWidget(this.title, this.drop_child);
  String title;
  Widget drop_child;
  @override
  _CustomExpandableWidgetState createState() => _CustomExpandableWidgetState();
}

class _CustomExpandableWidgetState extends State<CustomExpandableWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 5.w, vertical: 0),
      decoration: myWidgets.commonContainerDecoration(),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.grey[200],
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  AnimatedCrossFade(
                    firstChild: Icon(Icons.keyboard_arrow_down_rounded),
                    secondChild: Icon(Icons.keyboard_arrow_up_rounded),
                    crossFadeState:
                        _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 150),
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox(),
            secondChild:
                !_isExpanded
                    ? SizedBox()
                    : Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),

                      // color: Colors.red,
                      child: widget.drop_child,
                      // child: Text(
                      //   widget.child_text,
                      //   style: TextStyle(
                      //     color: _isExpanded ? Colors.black87 : Colors.transparent,
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 14,
                      //   ),
                      //   textAlign: TextAlign.left,
                      // ),
                    ),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
