import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/repositories/chat_repository.dart';
import '../data/services/chat_api_service.dart';

final dioProvider = Provider<Dio>((ref) => createApiClient());

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  if (AppConfig.useBackend) {
    return ApiChatRepository(ChatApiService(ref.watch(dioProvider)));
  }
  return LocalDemoChatRepository();
});
