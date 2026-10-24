import 'package:ai_advocate/data/models/chat_models.dart';
import 'package:ai_advocate/data/models/source_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChatResponse parses the API contract', () {
    final res = ChatResponse.fromJson({
      'conversation_id': 'demo-conversation',
      'answer': 'Demo response',
      'sources': [],
      'disclaimer': 'General information only.',
      'demo': true,
    });
    expect(res.conversationId, 'demo-conversation');
    expect(res.demo, isTrue);
    expect(res.sources, isEmpty);
  });

  test('ChatRequest serialises null conversation id', () {
    final json = const ChatRequest(message: 'hi').toJson();
    expect(json, {'message': 'hi', 'conversation_id': null});
  });

  test('sample sources never expose an official link', () {
    const s = SourceRef(
        id: '1',
        title: 't',
        officialUrl: 'https://example.org',
        isSample: true);
    expect(s.safeOfficialUri, isNull);
  });

  test('only https official links are accepted', () {
    const http =
        SourceRef(id: '1', title: 't', officialUrl: 'http://example.org');
    const https =
        SourceRef(id: '2', title: 't', officialUrl: 'https://example.org/a');
    expect(http.safeOfficialUri, isNull);
    expect(https.safeOfficialUri, isNotNull);
  });
}
