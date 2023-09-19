import 'package:chat_test/src/common_models/response/app_response.dart';
import 'package:chat_test/src/network/network_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(ref.watch(networkServiceProvider()));
}

class ChatRepository {
  final NetworkService _networkService;

  ChatRepository(this._networkService);

  Future<AppResponse<List<String>>> getOldChat(int page) async {
    final response = await _networkService.get(
        '/happening.chat.chat_room?receiver=anbatoul@gmail.com&page_no=$page&limit=20');
    return AppResponse<List<String>>.fromJson(response.data,
        (data) => (data['chat_messages'] as List).map((e) => e['content']).toList() as List<String>);
  }
}
