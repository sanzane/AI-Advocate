import '../../core/config/app_config.dart';
import 'source_ref.dart';

class ChatRequest {
  const ChatRequest({required this.message, this.conversationId});

  final String message;
  final String? conversationId;

  Map<String, dynamic> toJson() => {
        'message': message,
        'conversation_id': conversationId,
      };
}

class ChatResponse {
  const ChatResponse({
    required this.conversationId,
    required this.answer,
    this.sources = const [],
    this.disclaimer = AppConfig.disclaimer,
    this.demo = false,
  });

  final String conversationId;
  final String answer;
  final List<SourceRef> sources;
  final String disclaimer;
  final bool demo;

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final rawSources = (json['sources'] as List?) ?? const [];
    return ChatResponse(
      conversationId: (json['conversation_id'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
      sources: rawSources
          .whereType<Map<String, dynamic>>()
          .map(SourceRef.fromJson)
          .toList(),
      disclaimer: (json['disclaimer'] as String?) ?? AppConfig.disclaimer,
      demo: json['demo'] == true,
    );
  }
}

enum ChatRole { user, assistant }

class ChatMessage {
  ChatMessage({
    required this.role,
    required this.text,
    this.sources = const [],
    this.demo = false,
    this.disclaimer,
    this.isError = false,
    this.retryText,
  })  : id = DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt = DateTime.now();

  final String id;
  final ChatRole role;
  final String text;
  final List<SourceRef> sources;
  final bool demo;
  final String? disclaimer;
  final bool isError;

  /// For error messages: the user text to resend on retry.
  final String? retryText;
  final DateTime createdAt;

  factory ChatMessage.user(String text) =>
      ChatMessage(role: ChatRole.user, text: text);

  factory ChatMessage.assistant(ChatResponse r) => ChatMessage(
        role: ChatRole.assistant,
        text: r.answer,
        sources: r.sources,
        demo: r.demo,
        disclaimer: r.disclaimer,
      );

  factory ChatMessage.error(String message, String retryText) => ChatMessage(
        role: ChatRole.assistant,
        text: message,
        isError: true,
        retryText: retryText,
      );
}
