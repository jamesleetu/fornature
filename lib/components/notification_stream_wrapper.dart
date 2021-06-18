import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fornature/widgets/indicators.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  DocumentSnapshot doc,
);

class ActivityStreamWrapper extends StatelessWidget {
  final Stream<dynamic> stream;
  final ItemBuilder<DocumentSnapshot> itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  final EdgeInsets padding;

  const ActivityStreamWrapper({
    Key key,
    @required this.stream,
    @required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics = const ClampingScrollPhysics(),
    this.padding = const EdgeInsets.only(bottom: 2.0, left: 2.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data.docs.toList();
          return list.length == 0
              ? Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 250.0),
                      child: Text('최근 활동 없음'),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: padding,
                  scrollDirection: scrollDirection,
                  itemCount: list.length,
                  shrinkWrap: shrinkWrap,
                  physics: physics,
                  itemBuilder: (BuildContext context, int index) {
                    return itemBuilder(context, list[index]);
                  },
                );
        } else {
          return circularProgress(context);
        }
      },
    );
  }
}
