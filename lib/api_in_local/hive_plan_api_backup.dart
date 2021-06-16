import 'package:chat_planner_app/models/plan_model.dart';
import 'package:hive/hive.dart';

class HivePlanApi {
  static void changeOneFieldValue(Box<PlanModel> box, index, PlanModel item,
      {required String fieldName, required dynamic value}) {
    var insertModel = PlanModel(
      id: (fieldName == 'id') ? value : item.id,
      title: (fieldName == 'title') ? value : item.title,
      isChecked: (fieldName == 'isChecked') ? value : item.isChecked,
      timestamp: (fieldName == 'timestamp') ? value : item.timestamp,
    );
    box.put(
      index,
      insertModel,
    );
  }

  static void unCheckPlan(Box<PlanModel> box, index, PlanModel item) {
    changeOneFieldValue(box, index, item, fieldName: 'isChecked', value: false);
  }

  static void checkPlanDone(Box<PlanModel> box, index, PlanModel item) {
    changeOneFieldValue(box, index, item, fieldName: 'isChecked', value: true);
  }

  static void deletePlanData(Box<PlanModel> box, index) {
    box.deleteAt(index);
    //기본원리 : 중간에 지워진 key를 매운다.
    //삭제시, index와 key가 동일하게 유지되지 않기 때문에 get으로 통일하여 로직작성
    if (index == box.length) {
      return;
    }
    int lastIndex = box.length;
    // 중간에 원소가 삭제되어도 key는 변화x -> i는 lastIndex까지의 key값을 갖는다.
    // box.get(i + 1);로 lastIndex까지를 가져오게 된다.
    var alterItem;
    var insertModel;
    for (int i = index; i < lastIndex; i++) {
      alterItem = box.get(i + 1);
      //changeOneFieldValue(box, i, alterItem!, fieldName: 'id', value: i);
      insertModel = PlanModel(
        id: i,
        title: alterItem!.title,
        isChecked: alterItem.isChecked,
        timestamp: alterItem.timestamp,
      );
      box.put(
        i,
        insertModel,
      );
    }
    box.delete(box.length - 1); // 마지막것 삭제
  }

  static void reorderPlanData(Box<PlanModel> box, oldIndex, newIndex) {
    //그냥 그대로 두는 경우(old = new)는 애초에 reorder호출이 안된다.
    //index와 key를 동일하게 유지하기 때문에 getAt을 쓰든, get을 쓰든 노상관
    var item = box.getAt(oldIndex);
    var alterItem;
    var insertModel = PlanModel(
      id: newIndex,
      title: item!.title,
      isChecked: item.isChecked,
      timestamp: item.timestamp,
    );
    if (newIndex < oldIndex) {
      for (int i = newIndex; i <= oldIndex; i++) {
        alterItem = box.getAt(i);
        box.put(
          i,
          insertModel,
        );
        insertModel = PlanModel(
          id: i + 1,
          title: alterItem!.title,
          isChecked: alterItem.isChecked,
          timestamp: alterItem.timestamp,
        );
      }
    } else {
      //아! 이것은 실질적인 newIndex가, 앞에서 뒤로 이동하는 경우에는 +1되기 때문
      //final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
      for (int i = newIndex - 1; i >= oldIndex; i--) {
        alterItem = box.getAt(i);
        box.put(
          i,
          insertModel,
        );
        insertModel = PlanModel(
          id: i - 1,
          title: alterItem!.title,
          isChecked: alterItem.isChecked,
          timestamp: alterItem.timestamp,
        );
      }
    }
    print('$oldIndex $newIndex');
  }
}
