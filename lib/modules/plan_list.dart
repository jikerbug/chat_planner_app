import 'package:chat_planner_app/api_in_local/hive_plan_api.dart';
import 'package:chat_planner_app/functions/custom_dialog_function.dart';
import 'package:chat_planner_app/models/plan_model.dart';
import 'package:chat_planner_app/providers/data.dart';
import 'package:chat_planner_app/widgets/plan_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PlanList extends StatefulWidget {
  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Data>(context, listen: false).userId;
    return ValueListenableBuilder(
        valueListenable: Hive.box<PlanModel>('word').listenable(),
        builder: (context, Box<PlanModel> box, child) {
          if (box.length == 0) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/heart_flower_2.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.fill,
                  color: Colors.black,
                ),
                Text('계획을 추가해주세요'),
              ],
            ));
          }
          return ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              HivePlanApi.reorderPlanData(box, oldIndex, newIndex);
            },
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              print('builder : box.keys');
              print(box.keys);
              final item = box.getAt(index);

              if (item == null) {
                return Container(
                  child: Text('아이템이 존재하지 않습니다.'),
                );
              } else {
                // if (item.title[0] != 'a') {
                //   return Container(
                //     key: ValueKey(item),
                //   );
                // }

                return PlanTile(
                  deleteFunction: () {
                    HivePlanApi.deletePlanData(box, index);
                  },
                  checkFunction: (value) {
                    if (value == true) {
                      HivePlanApi.checkPlanDone(box, index, item);
                    } else {
                      CustomDialogFunction.dialogFunction(
                          context: context,
                          isTwoButton: true,
                          isLeftAlign: false,
                          onPressed: () {
                            HivePlanApi.unCheckPlan(box, index, item);
                          },
                          title: '실천 취소 안내',
                          text: '실천을 취소하려면 하트 10개가 필요합니다.\n실천을 취소하시겠습니까?',
                          size: 'small');
                    }
                  },
                  userId: userId,
                  index: index,
                  key: ValueKey(item),
                  title: item.title,
                  isChecked: item.isChecked,
                  timestamp: item.timestamp,
                );
              }
            },
            itemCount: box.length,
          );
        });
  }
}
