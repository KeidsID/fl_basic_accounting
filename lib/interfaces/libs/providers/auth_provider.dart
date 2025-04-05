import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:app/domain/entities.dart";

part "auth_provider.g.dart";

const _dummyUser = User(id: "user-dummy", username: "Dummy User");

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() {
    return null;
  }

  Future<void> signIn() async {
    state = AsyncLoading();

    await Future.delayed(Duration(seconds: 1));

    state = AsyncData(_dummyUser);
  }

  void signOut() {
    state = AsyncData(null);
  }
}
