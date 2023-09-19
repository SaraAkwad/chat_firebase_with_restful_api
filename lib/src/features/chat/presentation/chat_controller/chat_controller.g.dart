// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatPageHash() => r'd85b67f8ce2a72575d9e65385bf80999a1dc6303';

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
String _$chatControllerHash() => r'ce050525865dcb7084c9ef5a79b6e5e012a6838a';

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
