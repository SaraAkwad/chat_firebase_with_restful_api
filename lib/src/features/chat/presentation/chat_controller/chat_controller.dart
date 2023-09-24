import 'dart:async';
import 'package:chat_test/src/common_models/response/app_response.dart';
import 'package:chat_test/src/common_models/response/pagination.dart';
import 'package:chat_test/src/features/chat/data/chat_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

const int limit = 10;

@riverpod
class ChatPage extends _$ChatPage {
  @override
  int build() {
    return 1;
  }

  void changePage(int value) {
    state = value;
  }
}

@riverpod
class ChatController extends _$ChatController {
  @override
  Stream<AppResponse<List<String>>> build() {
    return _getRecentChatStream(ref.watch(chatPageProvider));
  }

  DatabaseReference get _databaseRef =>
      FirebaseDatabase.instance.ref().child('chats');

  Stream<AppResponse<List<String>>> _getRecentChatStream(int page) async* {
    final dbRef = _databaseRef.limitToFirst(page * limit);
    yield* dbRef.onValue
        .asyncMap((event) => _processDatabaseEvent(event, page));
  }

  Future<AppResponse<List<String>>> _processDatabaseEvent(
      DatabaseEvent event, int page) async {
    final List<dynamic> rawList = event.snapshot.value as List<dynamic>;
    final List<String> chats = rawList.map((e) => e.toString()).toList();

    if (chats.length < limit * page) {
      return await _getOldChatAndMerge(chats);
    }
    return _createAppResponse(chats);
  }

  Future<AppResponse<List<String>>> _getOldChatAndMerge(
      List<String> chats) async {
    try {
      final response =
          await ref.watch(chatRepositoryProvider).getOldChat(1, limit);
      chats.addAll(response.data);
      state = AsyncData(response.copyWith(data: chats));
      return response.copyWith(data: chats);
    } catch (e, st) {
      state = AsyncError(e, st);
      return AppResponse(
          data: [],
          statusCode: 200,
          error: 1,
          message: e.toString(),
          pagination: null);
    }
  }

  AppResponse<List<String>> _createAppResponse(List<String> chats) {
    return AppResponse(
      data: chats,
      error: 0,
      message: '',
      statusCode: 200,
      pagination: null,
    );
  }

  Future<bool> onLoading(int page) async {
    final pagination = state.asData?.value.pagination;

    if (_isPaginationEndReached(pagination)) return false;
    if (pagination != null || _isChatDataLimited(page)) {
      return await _getData();
    }

    ref.read(chatPageProvider.notifier).changePage(page);
    return true;
  }

  bool _isPaginationEndReached(Pagination? pagination) {
    return pagination != null &&
        pagination.currentPage + 1 > pagination.totalPages;
  }

  bool _isChatDataLimited(int page) {
    return state.asData!.value.data.length < (page - 1) * limit;
  }

  Future<bool> _getData() async {
    try {
      final currentPage = state.asData?.value.pagination?.currentPage ?? 0;
      final response = await ref
          .watch(chatRepositoryProvider)
          .getOldChat(currentPage + 1, limit);

      final mergedData = [...response.data, ...state.asData!.value.data];
      state = AsyncData(state.asData!.value
          .copyWith(pagination: response.pagination, data: mergedData));

      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}
