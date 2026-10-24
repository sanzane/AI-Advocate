import 'package:ai_advocate/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test loads Welcome screen and guest explore',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AiAdvocateApp()));
    await tester.pumpAndSettle();

    // Verify Welcome onboarding screen
    expect(find.text('Legal clarity, when you need it.'), findsOneWidget);
    expect(find.text('Continue with phone number'), findsOneWidget);
    expect(find.text('Explore as Guest'), findsOneWidget);

    // Tap Explore as Guest
    await tester.tap(find.text('Explore as Guest'));
    await tester.pumpAndSettle();

    // Verify Home screen is loaded
    expect(find.text('AI Advocate'), findsWidgets);
    expect(find.textContaining('How can I help you'), findsOneWidget);
  });
}
