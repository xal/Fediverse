import 'package:fedi/refactored/async/loading/init/async_init_loading_bloc_impl.dart';
import 'package:fedi/refactored/disposable/disposable.dart';
import 'package:fedi/refactored/provider/provider_context_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart' as provider_lib;

var _logger = Logger("provider_context_bloc_impl.dart");

typedef provider_lib.Provider<T> ProviderBuilder<T extends Disposable>();

class DisposableEntry<T extends Disposable> {
  T disposable;
  ProviderBuilder<T> providerBuilder;

  DisposableEntry(this.disposable, this.providerBuilder);
}

abstract class ProviderContextBloc extends AsyncInitLoadingBloc
    implements IProviderContextBloc {
  final Map<Type, DisposableEntry> _storage = {};

  @override
  Disposable register<T extends Disposable>(T disposable) {
    var type = T;
    if (_storage.containsKey(type)) {
      throw "Can't register $Disposable because {$type} already registred";
    }

    ProviderBuilder<T> providerCreator = () {
//      _logger.d(() => "providerCreator for $type context $context");
      return provider_lib.Provider<T>.value(value: disposable);
    };

    _storage[type] = DisposableEntry<T>(disposable, providerCreator);

    return CustomDisposable(() => unregister<T>(disposable));
  }

  @override
  void unregister<T extends Disposable>(T object) {
    var type = T;
    if (!_storage.containsKey(type)) {
      throw "Can't unregister $object because {$type} not registred";
    }

    var objInStorage = _storage[type];
    if (objInStorage != object) {
      throw "Can't unregister $object because obj {$object} not equal to "
          "registered $objInStorage";
    }

    objInStorage.disposable.dispose();

    _storage.remove(type);
  }

  @override
  Widget provideContextToChild({@required Widget child}) {
    _logger.fine(() => "provideToChildContext ${_storage.length}");

    var providers =
        _storage.values.map((entry) => entry.providerBuilder()).toList();
    return provider_lib.MultiProvider(
      providers: providers,
      child: child,
    );
  }

  @override
  Future<Disposable> asyncInitAndRegister<T extends Disposable>(T obj,
      {Future Function(T obj) additionalAsyncInit}) async {
    if (obj is AsyncInitLoadingBloc) {
      await obj.performAsyncInit();
    }

    if (additionalAsyncInit != null) {
      await additionalAsyncInit(obj);
    }

    return register<T>(obj);
  }

  @override
  T get<T extends Disposable>() => _storage[T].disposable;
}