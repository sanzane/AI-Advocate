import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/errors/app_exception.dart';
import '../../data/models/chat_models.dart';
import '../../data/models/research_item.dart';
import '../../shared/providers.dart';
import '../research/research_controller.dart';

class ChatState {
  const ChatState(
      {this.messages = const [], this.isLoading = false, this.conversationId});

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? conversationId;

  ChatState copyWith(
      {List<ChatMessage>? messages, bool? isLoading, String? conversationId}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

class ChatController extends Notifier<ChatState> {
  int _epoch = 0; // bumped on reset so late responses are discarded

  @override
  ChatState build() => const ChatState();

  Future<void> send(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || state.isLoading) return;
    final clipped = text.length > AppConfig.maxMessageLength
        ? text.substring(0, AppConfig.maxMessageLength)
        : text;
    state = state
        .copyWith(messages: [...state.messages, ChatMessage.user(clipped)]);
    await _request(clipped);
  }

  /// Resends the last failed question without duplicating the user bubble.
  Future<void> retry() async {
    if (state.isLoading ||
        state.messages.isEmpty ||
        !state.messages.last.isError) {
      return;
    }
    final messages = [...state.messages];
    final failed = messages.removeLast();
    state = state.copyWith(messages: messages);
    final text = failed.retryText;
    if (text != null) await _request(text);
  }

  void reset() {
    _epoch++;
    state = const ChatState();
  }

  Future<void> _request(String text) async {
    final epoch = _epoch;
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref.read(chatRepositoryProvider).send(
          ChatRequest(message: text, conversationId: state.conversationId));
      if (epoch != _epoch) return;
      final message = ChatMessage.assistant(response);
      state = state.copyWith(
        messages: [...state.messages, message],
        isLoading: false,
        conversationId:
            response.conversationId.isEmpty ? null : response.conversationId,
      );
      ref.read(researchHistoryProvider.notifier).add(
            ResearchItem(
              id: message.id,
              title: text,
              answer: response.answer,
              sources: response.sources,
              createdAt: message.createdAt,
              demo: response.demo,
              disclaimer: response.disclaimer,
            ),
          );
    } on AppException catch (e) {
      _fail(epoch, e.message, text);
    } catch (_) {
      _fail(epoch, 'Something unexpected went wrong. Please try again.', text);
    }
  }

  void _fail(int epoch, String message, String text) {
    if (epoch != _epoch) return;
    state = state.copyWith(
      messages: [...state.messages, ChatMessage.error(message, text)],
      isLoading: false,
    );
  }
}

final chatControllerProvider =
    NotifierProvider<ChatController, ChatState>(ChatController.new);
