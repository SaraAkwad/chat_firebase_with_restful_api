import 'dart:async';
import 'package:chat_test/src/common_models/response/app_response.dart';
import 'package:chat_test/src/common_models/response/pagination.dart';
import 'package:chat_test/src/features/chat/data/chat_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_controller.g.dart';

@Riverpod(keepAlive: true)
class OldChats extends _$OldChats {
  @override
  AppResponse<List<String>>? build() {
    return null;
  }

  void changeState(AppResponse<List<String>> appResponse) {
    state = appResponse;
  }
}

const int limit = 10;

@riverpod
class ChatController extends _$ChatController {
  @override
  Stream<AppResponse<List<String>>> build() {
    return _getRecentChatStream();
  }

  DatabaseReference get _databaseRef => FirebaseDatabase.instance.ref().child('chats');

  Stream<AppResponse<List<String>>> _getRecentChatStream() async* {
    yield* _databaseRef.onValue.asyncMap(_processDatabaseEvent);
  }

  Future<AppResponse<List<String>>> _processDatabaseEvent(DatabaseEvent event) async {
    final List<String> chats = _convertToChatList(event.snapshot.value);
    
    if (chats.length < limit && _oldChatsStateIsNull()) {
      return await _getOldChatAndMerge(chats);
    }
    return _createAppResponse(chats);
  }

  List<String> _convertToChatList(dynamic rawList) {
    return [...(rawList as List<dynamic>).map((e) => e.toString()).toList()];
  }

  bool _oldChatsStateIsNull() {
    return ref.read(oldChatsProvider) == null;
  }

  Future<AppResponse<List<String>>> _getOldChatAndMerge(List<String> chats) async {
    try {
      final response = await _fetchOldChats(1);
      return _mergeAndSetState(response, chats);
    } catch (e, st) {
      return _handleFetchError(e, st);
    }
  }

  Future<AppResponse<List<String>>> _fetchOldChats(int page) {
    return ref.watch(chatRepositoryProvider).getOldChat(page, limit);
  }

  AppResponse<List<String>> _mergeAndSetState(AppResponse<List<String>> response, List<String> chats) {
    chats.addAll(response.data);
    final appResponse = response.copyWith(data: chats);
    ref.read(oldChatsProvider.notifier).changeState(response);
    state = AsyncData(appResponse);
    return appResponse;
  }

  AppResponse<List<String>> _handleFetchError(dynamic error, StackTrace stackTrace) {
    state = AsyncError(error, stackTrace);
    return AppResponse(
      data: [],
      statusCode: 200,
      error: 1,
      message: error.toString(),
      pagination: null
    );
  }

  AppResponse<List<String>> _createAppResponse(List<String> chats) {
    final oldChats = ref.read(oldChatsProvider);
    return oldChats != null ? oldChats.copyWith(data: [...chats, ...oldChats.data]) : _createDefaultAppResponse(chats);
  }

  AppResponse<List<String>> _createDefaultAppResponse(List<String> chats) {
    return AppResponse(
      data: chats,
      error: 0,
      message: '',
      statusCode: 200,
      pagination: null
    );
  }

  Future<bool> onLoading() async {
    return _isPaginationEndReached(state.asData?.value.pagination) ? false : await _getData();
  }

  bool _isPaginationEndReached(Pagination? pagination) {
    return pagination != null && pagination.currentPage + 1 > pagination.totalPages;
  }

  Future<bool> _getData() async {
    try {
      final currentPage = state.asData?.value.pagination?.currentPage ?? 0;
      final response = await _fetchOldChats(currentPage + 1);
      return _mergeDataAndUpdateState(response, currentPage);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  bool _mergeDataAndUpdateState(AppResponse<List<String>> response, int currentPage) {
    final mergedData = [...state.asData!.value.data, ...response.data];
    final appResponse = state.asData!.value.copyWith(pagination: response.pagination, data: mergedData);
    ref.read(oldChatsProvider.notifier).changeState(response);
    state = AsyncData(appResponse);
    return true;
  }
}
