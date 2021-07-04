import 'package:chat_planner_app/models_hive/chat_room_model.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:hive/hive.dart';

class HiveChatApi {
  //  static final _box = Hive.box<ChatRoomModel>('chatRoom' + User().userId);
  static final _box = Hive.box<ChatRoomModel>('chatRoom');
  static Future<void> addChatRoom({
    required chatRoomId,
    required title,
    required category,
    required lastDoneTime,
    required lastDoneMessage,
  }) async {
    int id = 0;

    if (_box.isNotEmpty) {
      final prevItem = _box.getAt(_box.length - 1);

      if (prevItem != null) {
        id = prevItem.id + 1;
      }
    }
    print(id);

    _box.add(ChatRoomModel(
        id: id,
        chatRoomId: chatRoomId,
        title: title,
        category: category,
        lastDoneTime: lastDoneTime,
        lastDoneMessage: lastDoneMessage));
  }

  static void exitChatRoom(chatRoomId) {
    bool controller = true;
    int index = 0;
    _box.values.forEach((ChatRoomModel element) {
      if (element.chatRoomId == chatRoomId && controller) {
        _box.deleteAt(index);
        controller = false;
      }
      index++;
    });
  }

  static void setChatRoomAtLatestListOrder(chatRoomId) {
    _box.values.forEach((ChatRoomModel element) {
      if (element.chatRoomId == chatRoomId) {
        int newIndex = _box.length;
        int oldIndex = element.id;

        if (newIndex != oldIndex) {
          //거꾸로 나열해주기 때문에 헷갈려서 getAt대신에 get을 썼다
          var item = _box.get(element.id);
          var alterItem;
          var insertModel = getOneFieldValueChangedChatModel(item!,
              fieldName: 'id', value: newIndex);

          //아! 이것은 실질적인 newIndex가, 앞에서 뒤로 이동하는 경우에는 +1되기 때문 -> newIndex - 1부터 시작
          //final index = newIndex > oldIndex ? newIndex - 1 : newIndex;
          for (int i = newIndex - 1; i >= oldIndex; i--) {
            alterItem = _box.get(i);
            _box.put(
              i,
              insertModel,
            );
            insertModel = getOneFieldValueChangedChatModel(alterItem!,
                fieldName: 'id', value: i - 1);
          }
        }
      }
    });
  }

  static void changeOneFieldValue(
      Box<ChatRoomModel> box, index, ChatRoomModel item,
      {required String fieldName, required dynamic value}) {
    var insertModel = getOneFieldValueChangedChatModel(item,
        fieldName: fieldName, value: value);
    box.putAt(
      index,
      insertModel,
    );
  }

  static ChatRoomModel getOneFieldValueChangedChatModel(ChatRoomModel item,
      {required String fieldName, required dynamic value}) {
    return ChatRoomModel(
        id: (fieldName == 'id') ? value : item.id,
        chatRoomId: (fieldName == 'chatRoomId') ? value : item.chatRoomId,
        title: (fieldName == 'title') ? value : item.title,
        category: (fieldName == 'category') ? value : item.category,
        lastDoneTime: (fieldName == 'lastDoneTime') ? value : item.lastDoneTime,
        lastDoneMessage:
            (fieldName == 'lastDoneMessage') ? value : item.lastDoneMessage);
  }
}
