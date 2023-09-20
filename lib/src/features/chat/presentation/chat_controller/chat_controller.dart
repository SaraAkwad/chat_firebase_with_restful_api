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

  Stream<AppResponse<List<String>>> _getRecentChatStream(int page) async* {
    final databaseRef = _dataBaseRef.limitToFirst(page * 6);

    yield* databaseRef.onValue.map((DatabaseEvent event) {
      final List<dynamic> rawList = event.snapshot.value as List<dynamic>;
      final List<String> chats = rawList.map((e) => e.toString()).toList();
      state = AsyncData(AppResponse(
          data: chats,
          error: 0,
          message: '',
          statusCode: 200,
          pagination: null));
      return AppResponse(
          data: chats,
          error: 0,
          message: '',
          statusCode: 200,
          pagination: null);
    });
  }

  Future<bool> onLoading(int page) async {
    if (state.asData!.value.data.length < (page - 1) * 6) {
      if (state.asData?.value.pagination != null &&
          page > state.asData!.value.pagination!.totalPages) {
        return false;
      } else {
        try {
          final response =
              await ref.watch(chatRepositoryProvider).getOldChat((state.asData?.value.pagination?.currentPage ?? 0) + 1);
          state = AsyncData(state.asData!.value.copyWith(
              pagination: response.pagination,
              data: [...response.data, ...state.asData!.value.data]));
          return true;
        } catch (e, stack) {
          state = AsyncError(e, stack);
          return false;
        }
      }
    } else {
      ref.read(chatPageProvider.notifier).chagePage(page);
      return true;
    }
  }
}
