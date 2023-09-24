import 'dart:async';
import 'package:chat_test/src/common_models/response/app_response.dart';
import 'package:chat_test/src/features/chat/data/chat_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatPage extends _$ChatPage {
  @override
  int build() {
    return 1;
  }

  void chagePage(int value) {
    state = value;
  }
}

@riverpod
class ChatController extends _$ChatController {
  @override
  Stream<AppResponse<List<String>>> build() {
    return _getRecentChatStream(ref.watch(chatPageProvider));
  }

  DatabaseReference get _dataBaseRef =>
      FirebaseDatabase.instance.ref().child('chats');

  int get _limit => 10;

  Stream<AppResponse<List<String>>> _getRecentChatStream(int page) async* {
    final databaseRef = _dataBaseRef.limitToFirst(page * _limit);
    yield* databaseRef.onValue.asyncMap((DatabaseEvent event) async {
      final List<dynamic> rawList = event.snapshot.value as List<dynamic>;
      final List<String> chats = rawList.map((e) => e.toString()).toList();
      if (chats.length < page * _limit) {
        try {
          final response =
              await ref.watch(chatRepositoryProvider).getOldChat(1, _limit);
          chats.addAll(response.data);
          state = AsyncData(response.copyWith(data: chats));
          return response.copyWith(data: chats);
        } catch (e, st) {
          state = AsyncError(e, st);
        }
      } else {
        state = AsyncData(AppResponse(
          data: chats,
          error: 0,
          message: '',
          statusCode: 200,
          pagination: null,
        ));
      }
      return AppResponse(
        data: chats,
        error: 0,
        message: '',
        statusCode: 200,
        pagination: null,
      );
    });
  }

  Future<bool> onLoading(int page) async {
    if (state.asData?.value.pagination != null &&
        state.asData!.value.pagination!.currentPage + 1 >
            state.asData!.value.pagination!.totalPages) {
      return false;
    } else {
      if (state.asData?.value.pagination != null) {
        return await _getData();
      } else if (state.asData!.value.data.length < (page - 1) * _limit) {
        return await _getData();
      } else {
        ref.read(chatPageProvider.notifier).chagePage(page);
        return true;
      }
    }
  }

  Future<bool> _getData() async {
    try {
      final response = await ref.watch(chatRepositoryProvider).getOldChat(
          (state.asData?.value.pagination?.currentPage ?? 0) + 1, _limit);
      state = AsyncData(state.asData!.value.copyWith(
          pagination: response.pagination,
          data: [...response.data, ...state.asData!.value.data]));
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}
