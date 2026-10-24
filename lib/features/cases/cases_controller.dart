import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/case_workspace.dart';

class CasesController extends Notifier<List<CaseWorkspace>> {
  @override
  List<CaseWorkspace> build() {
    return [
      CaseWorkspace(
        id: 'case-demo-1',
        title: 'Residential Tenancy Deposit Dispute - Bengaluru',
        summary:
            'Landlord withheld Rs. 1,20,000 security deposit after handover citing repainting charges contrary to the 11-month lease agreement.',
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CaseWorkspace(
        id: 'case-demo-2',
        title: 'Consumer Complaint: Defective Inverter Battery',
        summary:
            'Seller and manufacturer refused warranty replacement within the 24-month warranty period for a commercial inverter unit.',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  CaseWorkspace create({required String title, String summary = ''}) {
    final item = CaseWorkspace(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      summary: summary.trim(),
      updatedAt: DateTime.now(),
    );
    state = [item, ...state];
    return item;
  }

  void edit({
    required String id,
    required String title,
    String summary = '',
  }) {
    state = [
      for (final c in state)
        if (c.id == id)
          c.copyWith(
            title: title.trim(),
            summary: summary.trim(),
            updatedAt: DateTime.now(),
          )
        else
          c,
    ];
  }

  void delete(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final casesProvider =
    NotifierProvider<CasesController, List<CaseWorkspace>>(CasesController.new);
