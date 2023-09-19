// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'341d594dc65181c0066befc3956a4bf625ea6ef4';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = Provider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DioRef = ProviderRef<Dio>;
String _$networkServiceHash() => r'e1ca8978ca1cc66d7bc164dcf02bf5dc4ef2c90f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [networkService].
@ProviderFor(networkService)
const networkServiceProvider = NetworkServiceFamily();

/// See also [networkService].
class NetworkServiceFamily extends Family<NetworkService<dynamic>> {
  /// See also [networkService].
  const NetworkServiceFamily();

  /// See also [networkService].
  NetworkServiceProvider call([
    Dio? dio,
  ]) {
    return NetworkServiceProvider(
      dio,
    );
  }

  @override
  NetworkServiceProvider getProviderOverride(
    covariant NetworkServiceProvider provider,
  ) {
    return call(
      provider.dio,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'networkServiceProvider';
}

/// See also [networkService].
class NetworkServiceProvider extends Provider<NetworkService<dynamic>> {
  /// See also [networkService].
  NetworkServiceProvider([
    Dio? dio,
  ]) : this._internal(
          (ref) => networkService(
            ref as NetworkServiceRef,
            dio,
          ),
          from: networkServiceProvider,
          name: r'networkServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$networkServiceHash,
          dependencies: NetworkServiceFamily._dependencies,
          allTransitiveDependencies:
              NetworkServiceFamily._allTransitiveDependencies,
          dio: dio,
        );

  NetworkServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dio,
  }) : super.internal();

  final Dio? dio;

  @override
  Override overrideWith(
    NetworkService<dynamic> Function(NetworkServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NetworkServiceProvider._internal(
        (ref) => create(ref as NetworkServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dio: dio,
      ),
    );
  }

  @override
  ProviderElement<NetworkService<dynamic>> createElement() {
    return _NetworkServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NetworkServiceProvider && other.dio == dio;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dio.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NetworkServiceRef on ProviderRef<NetworkService<dynamic>> {
  /// The parameter `dio` of this provider.
  Dio? get dio;
}

class _NetworkServiceProviderElement
    extends ProviderElement<NetworkService<dynamic>> with NetworkServiceRef {
  _NetworkServiceProviderElement(super.provider);

  @override
  Dio? get dio => (origin as NetworkServiceProvider).dio;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
