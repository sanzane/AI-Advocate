import 'package:ai_advocate/data/models/source_ref.dart';
import 'package:ai_advocate/features/cases/cases_controller.dart';
import 'package:ai_advocate/features/research/research_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CasesController', () {
    test('initializes with sample cases', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final cases = container.read(casesProvider);
      expect(cases.length, greaterThanOrEqualTo(2));
      expect(cases.first.title, contains('Tenancy'));
    });

    test('creates a new case', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(casesProvider.notifier);
      final initialCount = container.read(casesProvider).length;

      final created = controller.create(
        title: 'New Contract Review',
        summary: 'Freelance software agreement review.',
      );

      final updated = container.read(casesProvider);
      expect(updated.length, initialCount + 1);
      expect(updated.first.id, created.id);
      expect(updated.first.title, 'New Contract Review');
    });

    test('edits an existing case', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(casesProvider.notifier);
      final created =
          controller.create(title: 'Original Title', summary: 'Orig');

      controller.edit(
        id: created.id,
        title: 'Updated Title',
        summary: 'Updated Summary',
      );

      final target =
          container.read(casesProvider).firstWhere((c) => c.id == created.id);
      expect(target.title, 'Updated Title');
      expect(target.summary, 'Updated Summary');
    });

    test('deletes a case', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(casesProvider.notifier);
      final created = controller.create(title: 'To Be Deleted');
      expect(
          container.read(casesProvider).any((c) => c.id == created.id), isTrue);

      controller.delete(created.id);
      expect(container.read(casesProvider).any((c) => c.id == created.id),
          isFalse);
    });
  });

  group('SavedController', () {
    test('initializes with sample saved items', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final saved = container.read(savedProvider);
      expect(saved, isNotEmpty);
    });

    test('toggles and removes items', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(savedProvider.notifier);
      const testSource = SourceRef(
        id: 'test-src-123',
        title: 'Arbitration Act 1996',
        isSample: true,
      );

      controller.toggleSource(testSource);
      expect(controller.isSaved('s:test-src-123'), isTrue);

      controller.remove('s:test-src-123');
      expect(controller.isSaved('s:test-src-123'), isFalse);
    });
  });
}
