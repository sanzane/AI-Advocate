import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Small pill marking demo / sample content.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key, this.label = 'DEMO'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.noticeTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.noticeText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// Persistent "general information, not advice" notice.
class DisclaimerNote extends StatelessWidget {
  const DisclaimerNote({super.key, this.text = AppConfig.disclaimer});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.info_outline,
              size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.cobaltTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.cobalt, size: 26),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(
                message,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[const SizedBox(height: 20), action!],
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerTint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2C4C1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.danger, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try again'),
            ),
          ],
        ],
      ),
    );
  }
}

/// White surface with hairline border and soft shadow.
class AppCard extends StatelessWidget {
  const AppCard(
      {super.key,
      required this.child,
      this.onTap,
      this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Text input with a send button, used on Home and in chat.
class Composer extends StatelessWidget {
  const Composer({
    super.key,
    required this.controller,
    required this.onSend,
    this.focusNode,
    this.hint = 'Describe your legal question…',
    this.minLines = 1,
    this.enabled = true,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final FocusNode? focusNode;
  final String hint;
  final int minLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 4, 6, 6),
      decoration: cardDecoration(radius: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              minLines: minLines,
              maxLines: 6,
              maxLength: AppConfig.maxMessageLength,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
                isDense: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: IconButton.filled(
              tooltip: 'Send',
              onPressed: enabled ? onSend : null,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                minimumSize: const Size(48, 48),
              ),
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
