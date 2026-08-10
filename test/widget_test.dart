import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_local_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/logout_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/login_controller.dart';
import 'package:hairguide_barberpedia/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // 1. Init Dio
    final dio = DioClient.create();

    // 2. Init Data Sources
    final remote = AuthRemoteDataSourceImpl(dio);
    final local = AuthLocalDataSourceImpl();

    // 3. Init Repo
    final repo = AuthRepositoryImpl(remote, local);

    // 4. Init UseCase
    final usecase = LoginUseCase(repo);

    // 5. Init Controller
    final controller = LoginController(usecase);

    final logoutUseCase = LogoutUseCase(repo);

    final logoutController = LogoutController(logoutUseCase);

    // 6. Pump App
    await tester.pumpWidget(MyApp(loginController: controller, loginUseCase: usecase, logoutUseCase: logoutUseCase, logoutController: logoutController,));

    // 7. Expect
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
