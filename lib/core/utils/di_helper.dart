import 'package:ai_chat/core/networking/api_service.dart';
import 'package:ai_chat/core/networking/dio_clint.dart';
import 'package:ai_chat/featuers/chat/cubit/cubit/chat_cubit.dart';
import 'package:ai_chat/featuers/chat/data/data_source/remote_data_source.dart';
import 'package:ai_chat/featuers/chat/data/repo/chat_repo.dart';
import 'package:get_it/get_it.dart';

class DI {
  DI._();
  static final sl = GetIt.instance;
  static void  setupDependency() {
    sl.registerLazySingleton<DioClient>(() => DioClient());
    sl.registerLazySingleton<ApiServices>(
      () => ApiServices(dioClient: sl<DioClient>()),
    );
    sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSource(apiServices: sl<ApiServices>()),
    );
    sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: sl<RemoteDataSource>()),
    );
    sl.registerFactory<ChatCubit>(
      () => ChatCubit(chatRepository: sl<ChatRepository>()),
    );
  }
}
