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
  List<String> build() {
    return [];
  }

  void addToList(List<String> chats) {
    state = [...state, ...chats];
  }
}

// Constant for limiting the number of chat items fetched.
const int limit = 10;

@riverpod
// Represents the ChatPage view logic
class ChatPage extends _$ChatPage {
  @override
  // Dummy build function
  int build() {
    return 1;
  }

  // Changes the current state with a new value.
  void changePage(int value) {
    state = value;
  }
}

@riverpod
// Controller responsible for handling chat data and events.
class ChatController extends _$ChatController {
  @override
  // Builds a stream of AppResponse for the chat messages.
  Stream<AppResponse<List<String>>> build() {
    return _getRecentChatStream(ref.watch(chatPageProvider));
  }

  // Gets the Firebase Database reference for 'chats'
  DatabaseReference get _databaseRef =>
      FirebaseDatabase.instance.ref().child('chats');

  // Fetches a stream of chat messages for a given page.
  Stream<AppResponse<List<String>>> _getRecentChatStream(int page) async* {
    final dbRef = _databaseRef.limitToFirst(page * limit);
    yield* dbRef.onValue
        .asyncMap((event) => _processDatabaseEvent(event, page));
  }

  // Processes the chat data received from the Firebase Database.
  Future<AppResponse<List<String>>> _processDatabaseEvent(
      DatabaseEvent event, int page) async {
    final List<dynamic> rawList = event.snapshot.value as List<dynamic>;
    final List<String> chats = [...rawList.map((e) => e.toString()).toList(), ...ref.read(oldChatsProvider)];

    if (chats.length < limit * page && state.asData?.value.pagination == null) {
      return await _getOldChatAndMerge(chats);
    }
    return _createAppResponse(chats);
  }

  // Fetches and merges old chat data when the length is less than a set limit.
  Future<AppResponse<List<String>>> _getOldChatAndMerge(
      List<String> chats) async {
    try {
      final response =
          await ref.watch(chatRepositoryProvider).getOldChat(1, limit);
      ref.read(oldChatsProvider.notifier).addToList(response.data);
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

  // Constructs an AppResponse object.
  AppResponse<List<String>> _createAppResponse(List<String> chats) {
    return AppResponse(
      data: chats,
      error: 0,
      message: '',
      statusCode: 200,
      pagination: null,
    );
  }

  // Handles chat data loading and pagination.
  Future<bool> onLoading(int page) async {
    final pagination = state.asData?.value.pagination;

    if (_isPaginationEndReached(pagination)) return false;
    if (pagination != null || _isChatDataLimited(page)) {
      return await _getData();
    }

    ref.read(chatPageProvider.notifier).changePage(page);
    return true;
  }

  // Checks if the end of the pagination is reached.
  bool _isPaginationEndReached(Pagination? pagination) {
    return pagination != null &&
        pagination.currentPage + 1 > pagination.totalPages;
  }

  // Checks if the chat data is limited for a given page.
  bool _isChatDataLimited(int page) {
    return state.asData!.value.data.length < (page - 1) * limit;
  }

  // Fetches additional data for chat messages.
  Future<bool> _getData() async {
    try {
      final currentPage = state.asData?.value.pagination?.currentPage ?? 0;
      final response = await ref
          .watch(chatRepositoryProvider)
          .getOldChat(currentPage + 1, limit);
      ref.read(oldChatsProvider.notifier).addToList(response.data);
      final mergedData = [...state.asData!.value.data, ...response.data];
      state = AsyncData(state.asData!.value
          .copyWith(pagination: response.pagination, data: mergedData));

      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }
}
