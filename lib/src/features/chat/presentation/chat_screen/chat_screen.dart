import 'package:chat_test/src/common_widgets/app_pagination_widget.dart';
import 'package:chat_test/src/features/chat/presentation/chat_controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatAsyncValue = ref.watch(chatControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Screen')),
      body: chatAsyncValue.when(
          skipLoadingOnReload: true,
          data: (data) {
            final chats = data.data;
            return AppPaginationWidget(
              onLoading: ref.read(chatControllerProvider.notifier).onLoading,
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(chats[index]),
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              )),
    );
  }
}
