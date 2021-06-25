import 'package:chat_planner_app/api_in_local/hive_record_api.dart';
import 'package:chat_planner_app/models_hive/plan_model.dart';
import 'package:hive/hive.dart';

class HivePlanApi {
  static Future<void> addPlan(
      {required title,
      required isHabit,
      required aimDaysOfWeek,
      required planEndDateInfo,
      required selectedChatRoomId}) async {
    final box = Hive.box<PlanModel>('plan');
    int id = 0;

    if (box.isNotEmpty) {
      final prevItem = box.getAt(box.length - 1);

      if (prevItem != null) {
        id = prevItem.id + 1;
      }
    }
    print(id);

    String createdTime = DateTime.now().toString();
    await HiveRecordApi.openPlanRecordBox(createdTime);
    box.put(
      id,
      PlanModel(
          id: id,
          title: title,
          isChecked: false,
          createdTime: createdTime,
          isHabit: isHabit,
          aimDaysOfWeek: aimDaysOfWeek,
          planEndDate: planEndDateInfo,
          selectedChatRoomId: selectedChatRoomId),
    );
  }

  static void changeOneFieldValue(Box<PlanModel> box, index, PlanModel item,
      {required String fieldName, required dynamic value}) {
    var insertModel = getOneFieldValueChangedPlanModel(item,
        fieldName: fieldName, value: value);
    box.put(
      index,
      insertModel,
    );
  }

  static PlanModel getOneFieldValueChangedPlanModel(PlanModel item,
      {required String fieldName, required dynamic value}) {
    return PlanModel(
      id: (fieldName == 'id') ? value : item.id,
      title: (fieldName == 'title') ? value : item.title,
      isChecked: (fieldName == 'isChecked') ? value : item.isChecked,
      createdTime: (fieldName == 'timestamp') ? value : item.createdTime,
      isHabit: (fieldName == 'isOneTimeTask') ? value : item.isHabit,
      aimDaysOfWeek:
          (fieldName == 'aimDaysOfWeek') ? value : item.aimDaysOfWeek,
      planEndDate: (fieldName == 'aimDaysOfWeek') ? value : item.planEndDate,
      selectedChatRoomId:
          (fieldName == 'selectedChatRoomId') ? value : item.selectedChatRoomId,
    );
  }

  static void unCheckPlan(Box<PlanModel> box, index, PlanModel item) {
    changeOneFieldValue(box, index, item, fieldName: 'isChecked', value: false);
  }

  static void unCheckEveryPlan(box) {
    box.values.forEach((element) {
      changeOneFieldValue(box, element.id, element,
          fieldName: 'isChecked', value: false);
    });
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
    for (int i = index; i < lastIndex; i++) {
      alterItem = box.get(i + 1);
      changeOneFieldValue(box, i, alterItem!, fieldName: 'id', value: i);
    }
    box.delete(box.length - 1); // 마지막것 삭제
  }

  static void reorderPlanData(Box<PlanModel> box, oldIndex, newIndex) {
    //그냥 그대로 두는 경우(old = new)는 애초에 reorder호출이 안된다.
    //index와 key를 동일하게 유지하기 때문에 getAt을 쓰든, get을 쓰든 노상관
    var item = box.getAt(oldIndex);
    var alterItem;
    var insertModel = getOneFieldValueChangedPlanModel(item!,
        fieldName: 'id', value: newIndex);
    if (newIndex < oldIndex) {
      for (int i = newIndex; i <= oldIndex; i++) {
        alterItem = box.getAt(i);
        box.put(
          i,
          insertModel,
        );
        insertModel = getOneFieldValueChangedPlanModel(alterItem!,
            fieldName: 'id', value: i + 1);
      }
    } else {
      //아! 이것은 실질적인 newIndex가, 앞에서 뒤로 이동하는 경우에는 +1되기 때문 -> newIndex - 1부터 시작
      //final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
      for (int i = newIndex - 1; i >= oldIndex; i--) {
        alterItem = box.getAt(i);
        box.put(
          i,
          insertModel,
        );
        insertModel = getOneFieldValueChangedPlanModel(alterItem!,
            fieldName: 'id', value: i - 1);
      }
    }
    print('$oldIndex $newIndex');
  }
}
