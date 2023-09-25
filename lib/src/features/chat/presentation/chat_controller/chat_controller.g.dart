// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$oldChatsHash() => r'bb6550a80bbf5bfa49d9a4be98fa3ad183e87836';

/// See also [OldChats].
@ProviderFor(OldChats)
final oldChatsProvider =
    NotifierProvider<OldChats, AppResponse<List<String>>?>.internal(
  OldChats.new,
  name: r'oldChatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$oldChatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OldChats = Notifier<AppResponse<List<String>>?>;
String _$chatPageHash() => r'6efec36fb06a696d9204559ac2461a19e992a8be';

/// See also [ChatPage].
@ProviderFor(ChatPage)
final chatPageProvider = AutoDisposeNotifierProvider<ChatPage, int>.internal(
  ChatPage.new,
  name: r'chatPageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatPageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatPage = AutoDisposeNotifier<int>;
String _$chatControllerHash() => r'627fa661ebefbb8a4ddc146e4963d8e367cd782c';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider = AutoDisposeStreamNotifierProvider<ChatController,
    AppResponse<List<String>>>.internal(
  ChatController.new,
  name: r'chatControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatController = AutoDisposeStreamNotifier<AppResponse<List<String>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
