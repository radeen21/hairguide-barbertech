import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hairguide_barberpedia/core/dio_client.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/data/capster_history_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/data/capster_history_repository_impl.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/domain/capster_history_repository.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/domain/get_capster_history_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/data/finish_service_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/data/finish_service_repository_impl.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/domain/finish_service_repository.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/domain/finish_service_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/domain/upload_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/finishService/presentation/finish_service_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/customerRecord/presentation/capster_history_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/data/start_service_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/data/start_service_repository.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/data/start_service_repository_impl.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/domain/start_service_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/starService/presentation/start_service_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/data/add_on_photo_api.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/data/add_on_repository_impl.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/domain/add_on_photo_repository.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/domain/take_and_generate_add_on_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/add-on/presentation/take_add_on_picture_controller.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/data/photo_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/data/photo_repository_impl.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/photo_repository.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:hairguide_barberpedia/features/capsters/takePicture/presentation/take_photo_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_local_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/auth_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/register/register_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/register/register_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/auth/data/session/auth_session_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/auth_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/login_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/logout_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/logout/usecase/logout_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/register/register_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/register/register_usecase.dart';
import 'package:hairguide_barberpedia/features/user/auth/domain/session/auth_session_repository.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/login_controller.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/register/register_controller.dart';
import 'package:hairguide_barberpedia/features/user/history/domain/get_history_usecase.dart';
import 'package:hairguide_barberpedia/features/user/history/domain/history_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/data/capster_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/capster_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/domain/get_capster_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/capster_list/presentation/capster_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/point_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/voucher/voucher_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/data/voucher/voucher_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/get_point_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/get_voucher_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/redeem_voucher_usecase.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/domain/voucher/voucher_repository.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/get_point_controller.dart';
import 'package:hairguide_barberpedia/features/user/history/data/history_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/history/data/history_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/history/presentation/history_controller.dart';
import 'package:hairguide_barberpedia/features/user/homepage/points/presentation/voucher/voucher_controller.dart';
import 'package:hairguide_barberpedia/features/user/review/data/review_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/review/data/review_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/review/domain/review_repository.dart';
import 'package:hairguide_barberpedia/features/user/review/domain/submit_review_usecase.dart';
import 'package:hairguide_barberpedia/features/user/review/presentation/review_controller.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/data/qr_remote_data_source.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/data/qr_repository_impl.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/qr_repository.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/domain/scan_qr_usecase.dart';
import 'package:hairguide_barberpedia/features/user/scanbarcode/presentation/scan_controller.dart';

final locator = GetIt.instance;

void setupLocator() {

  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() => DioClient.create());
  }

  if (!locator.isRegistered<AuthSessionRepositoryImpl>()) {
    locator.registerLazySingleton<AuthSessionRepositoryImpl>(
      () => AuthSessionRepositoryImpl(),
    );
  }

  if (!locator.isRegistered<AuthSessionRepository>()) {
    locator.registerLazySingleton<AuthSessionRepository>(
      () => locator<AuthSessionRepositoryImpl>(),
    );
  }

  if (!locator.isRegistered<AuthRemoteDataSource>()) {
    locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(locator()),
    );
  }

  if (!locator.isRegistered<AuthLocalDataSource>()) {
    locator.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );
  }

  if (!locator.isRegistered<AuthRepository>()) {
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        locator<AuthRemoteDataSource>(),
        locator<AuthLocalDataSource>(),
      ),
    );
  }

  if (!locator.isRegistered<LoginUseCase>()) {
    locator.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(
        authRepository: locator<AuthRepository>(),
        sessionRepository: locator<AuthSessionRepository>(),
      ),
    );
  }

  locator.registerFactory<LoginController>(
    () => LoginController(locator<LoginUseCase>()),
  );

  if (!locator.isRegistered<LogoutUseCase>()) {
    locator.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(locator<AuthRepository>()),
    );
  }

  locator.registerFactory<LogoutController>(
    () => LogoutController(locator<LogoutUseCase>()),
  );

  if (!locator.isRegistered<PhotoRemoteDataSource>()) {
    locator.registerLazySingleton<PhotoRemoteDataSource>(
      () => PhotoRemoteDataSource(locator()),
    );
  }

  if (!locator.isRegistered<PhotoRepository>()) {
    locator.registerLazySingleton<PhotoRepository>(
      () => PhotoRepositoryImpl(locator()),
    );
  }

  if (!locator.isRegistered<TakeAndAnalyzePhotoUseCase>()) {
    locator.registerLazySingleton<TakeAndAnalyzePhotoUseCase>(
      () => TakeAndAnalyzePhotoUseCase(locator()),
    );
  }

  locator.registerFactory<TakePhotoController>(
    () => TakePhotoController(useCase: locator(), sessionRepository: locator()),
  );

  if (!locator.isRegistered<RegisterRemoteDataSource>()) {
    locator.registerLazySingleton<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSource(),
    );
  }

  if (!locator.isRegistered<RegisterRepository>()) {
    locator.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryImpl(locator()),
    );
  }

  if (!locator.isRegistered<RegisterUseCase>()) {
    locator.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(locator()),
    );
  }

  locator.registerFactory<RegisterController>(
    () => RegisterController(registerUseCase: locator()),
  );

  if (!locator.isRegistered<PointsRemoteDataSource>()) {
    locator.registerLazySingleton<PointsRemoteDataSource>(
      () => PointsRemoteDataSource(locator()),
    );
  }

  if (!locator.isRegistered<PointsRepository>()) {
    locator.registerLazySingleton<PointsRepository>(
      () => PointsRepositoryImpl(locator()),
    );
  }

  if (!locator.isRegistered<GetPointsUseCase>()) {
    locator.registerLazySingleton<GetPointsUseCase>(
      () => GetPointsUseCase(locator()),
    );
  }

  locator.registerFactory<PointsController>(() => PointsController(locator()));

  locator.registerLazySingleton<CapsterRemoteDataSource>(
    () => CapsterRemoteDataSource(locator()),
  );

  locator.registerLazySingleton<CapsterRepository>(
    () => CapsterRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<GetCapstersUseCase>(
    () => GetCapstersUseCase(locator()),
  );

  locator.registerFactory<CapsterController>(
    () => CapsterController(locator()),
  );

  locator.registerFactory(() => TakeAddOnPictureController(locator()));

  locator.registerLazySingleton(() => TakeAndGenerateAddOnUseCase(locator()));

  locator.registerLazySingleton<AddOnPhotoRepository>(
    () => AddOnPhotoRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => AddOnPhotoApi(locator<Dio>()));

  if (!locator.isRegistered<HistoryRemoteDataSource>()) {
    locator.registerLazySingleton<HistoryRemoteDataSource>(
      () => HistoryRemoteDataSource(locator<Dio>()),
    );
  }

  if (!locator.isRegistered<HistoryRepository>()) {
    locator.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(locator<HistoryRemoteDataSource>()),
    );
  }

  if (!locator.isRegistered<GetHistoriesUseCase>()) {
    locator.registerLazySingleton<GetHistoriesUseCase>(
      () => GetHistoriesUseCase(locator<HistoryRepository>()),
    );
  }

  locator.registerFactory<HistoryController>(
    () => HistoryController(locator<GetHistoriesUseCase>()),
  );

  locator.registerLazySingleton(
    () => CapsterHistoryRemoteDataSource(locator()),
  );

  locator.registerLazySingleton<CapsterHistoryRepository>(
    () => CapsterHistoryRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => GetCapsterHistoriesUseCase(locator()));

  locator.registerFactory(() => CapsterHistoryController(locator()));

  locator.registerLazySingleton(
    () => StartServiceRemoteDataSourceImpl(locator<Dio>()),
  );

  locator.registerLazySingleton<StartServiceRepository>(
    () =>
        StartServiceRepositoryImpl(locator<StartServiceRemoteDataSourceImpl>()),
  );

  locator.registerLazySingleton(
    () => StartServiceUseCase(locator<StartServiceRepository>()),
  );

  locator.registerFactory(
    () => StartServiceController(locator<StartServiceUseCase>()),
  );

  // VOUCHER
  locator.registerLazySingleton<VoucherRemoteDataSource>(
    () => VoucherRemoteDataSourceImpl(locator<Dio>()),
  );

  locator.registerLazySingleton<VoucherRepository>(
    () => VoucherRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => GetVouchersUseCase(locator()));

  locator.registerFactory(() => VoucherController(locator()));

  locator.registerLazySingleton<RedeemVoucherUseCase>(
    () => RedeemVoucherUseCaseImpl(locator()),
  );

  locator.registerLazySingleton(() => QrRemoteDataSource(locator<Dio>()));
  locator.registerLazySingleton<QrRepository>(
    () => QrRepositoryImpl(locator()),
  );
  locator.registerLazySingleton(() => ScanQrUseCase(locator()));
  locator.registerFactory(() => ScanController(locator()));

  // REVIEW FEATURE
  locator.registerLazySingleton(() => ReviewRemoteDataSource(locator<Dio>()));

  locator.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(locator()),
  );

  locator.registerLazySingleton(() => SubmitReviewUseCase(locator()));

  locator.registerFactory(() => ReviewController(locator()));

// remote
locator.registerLazySingleton<FinishServiceRemoteDataSource>(
  () => FinishServiceRemoteDataSource(locator<Dio>()),
);

// repository
locator.registerLazySingleton<FinishServiceRepository>(
  () => FinishServiceRepositoryImpl(
    locator<FinishServiceRemoteDataSource>(),
  ),
);

// usecase
locator.registerLazySingleton<FinishServiceUseCase>(
  () => FinishServiceUseCase(
    locator<FinishServiceRepository>(),
  ),
);

locator.registerFactory<FinishServiceController>(
  () => FinishServiceController(
    locator<FinishServiceUseCase>(),
  ),
);

locator.registerLazySingleton<UploadPhotoUseCase>(
  () => UploadPhotoUseCase(
    locator<PhotoRepository>(),
  ),
);


  
}
