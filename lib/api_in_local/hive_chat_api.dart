import 'package:chat_planner_app/models_hive/chat_room_model.dart';
import 'package:chat_planner_app/models_singleton/user.dart';
import 'package:hive/hive.dart';

class HiveChatApi {
  //  static final _box = Hive.box<ChatRoomModel>('chatRoom' + User().userId);
  static final _box = Hive.box<ChatRoomModel>('chatRoom');

  static void addUserSelfChat(userId) {
    DateTime now = DateTime.now();
    addChatRoom(
        chatRoomId: userId,
        title: '나와의 채팅',
        category: '나',
        lastSentTime: now,
        lastMessage: '채팅방 생성',
        totalMessageCount: 0,
        todayDoneCount: 0,
        today: now);
  }

  static Future<void> addChatRoom({
    required chatRoomId,
    required title,
    required category,
    required lastSentTime,
    required lastMessage,
    required totalMessageCount,
    required todayDoneCount,
    required today,
  }) async {
    int id = 0;

    if (_box.isNotEmpty) {
      final prevItem = _box.get(_box.length - 1);

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
        lastSentTime: lastSentTime,
        lastMessage: lastMessage,
        totalMessageCount: totalMessageCount,
        readMessageCount: totalMessageCount,
        todayDoneCount: todayDoneCount,
        today: today,
        createUser: User().userId,
        currentMemberNum: 1));
  }

  static void exitChatRoom(chatRoomId) {
    int index = 0;
    _box.values.forEach((ChatRoomModel element) {
      if (element.chatRoomId == chatRoomId) {
        _box.delete(index);
        //기본원리 : 중간에 지워진 key를 매운다.
        //삭제시, index와 key가 동일하게 유지되지 않기 때문에 get으로 통일하여 로직작성
        if (index == _box.length) {
          return;
        }
        int lastIndex = _box.length;
        // 중간에 원소가 삭제되어도 key는 변화x -> i는 lastIndex까지의 key값을 갖는다.
        // box.get(i + 1);로 lastIndex까지를 가져오게 된다.
        var alterItem;
        for (int i = index; i < lastIndex; i++) {
          alterItem = _box.get(i + 1);
          changeOneFieldValue(_box, i, alterItem!, fieldName: 'id', value: i);
        }
        _box.delete(_box.length - 1); // 마지막것 삭제
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
        lastSentTime: (fieldName == 'lastDoneTime') ? value : item.lastSentTime,
        lastMessage:
            (fieldName == 'lastDoneMessage') ? value : item.lastMessage,
        totalMessageCount: item.totalMessageCount,
        readMessageCount: item.readMessageCount,
        todayDoneCount: item.todayDoneCount,
        today: item.today,
        createUser: item.createUser,
        currentMemberNum: item.currentMemberNum);
  }
}
