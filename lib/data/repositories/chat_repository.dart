import '../models/case_brief.dart';
import '../models/chat_models.dart';
import '../services/chat_api_service.dart';

abstract class ChatRepository {
  Future<ChatResponse> send(ChatRequest request);
}

/// Calls the FastAPI backend.
class ApiChatRepository implements ChatRepository {
  ApiChatRepository(this._service);

  final ChatApiService _service;

  @override
  Future<ChatResponse> send(ChatRequest request) =>
      _service.sendMessage(request);
}

/// Built-in placeholder responder used when no backend is configured.
/// It performs no AI inference and no legal analysis.
class LocalDemoChatRepository implements ChatRepository {
  @override
  Future<ChatResponse> send(ChatRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final quoted = request.message.trim().replaceAll('\n', '\n> ');
    return ChatResponse(
      conversationId: request.conversationId ?? 'demo-conversation',
      answer: '**Demo response: the AI backend is not connected yet.**\n\n'
          'No AI model or legal research was used to produce this text, and nothing here is a legal position.\n\n'
          '### Your question\n> $quoted\n\n'
          '### What the connected app will provide\n'
          '- A plain-language summary of your situation\n'
          '- Potentially relevant Acts and sections, with verified sources\n'
          '- Exceptions, missing information and possible next steps\n'
          '- Questions to discuss with a qualified advocate',
      sources: const [CaseBrief.demoSource],
      demo: true,
    );
  }
}
