import 'source_ref.dart';

/// Structured case brief. Currently populated with clearly labelled demo data.
class CaseBrief {
  const CaseBrief({
    required this.situation,
    required this.facts,
    required this.sources,
    required this.missingFacts,
    required this.nextSteps,
    required this.advocateQuestions,
    this.isDemo = true,
  });

  final String situation;
  final List<String> facts;
  final List<SourceRef> sources;
  final List<String> missingFacts;
  final List<String> nextSteps;
  final List<String> advocateQuestions;
  final bool isDemo;

  static const demoSource = SourceRef(
    id: 'sample-1',
    title: 'Sample provision (placeholder)',
    act: 'Sample Act - not a real citation',
    section: 'Section X',
    excerpt:
        'Placeholder excerpt. In the real app this text will come from a curated, verified legal corpus.',
    isSample: true,
  );

  static const demo = CaseBrief(
    situation:
        'DEMO: A tenant describes a dispute with a landlord over a withheld deposit. '
        'This summary is placeholder text and does not reflect any real matter.',
    facts: [
      'Date of agreement: [to be filled in]',
      'Amount of deposit: [to be filled in]',
      'Date possession was returned: [to be filled in]',
      'Written communication so far: [to be filled in]',
    ],
    sources: [demoSource],
    missingFacts: [
      'Is there a written agreement, and what does it say about the deposit?',
      'Was the landlord given written notice?',
      'Are there photos or receipts supporting the condition of the property?',
    ],
    nextSteps: [
      'Collect the agreement, payment proofs and all messages in one place.',
      'Consider a written, dated request to the other party.',
      'Discuss options and time limits with a qualified advocate.',
    ],
    advocateQuestions: [
      'Which legal provisions actually apply to my situation?',
      'What deadlines or limitation periods could affect me?',
      'What are the realistic options, costs and risks?',
    ],
  );
}
