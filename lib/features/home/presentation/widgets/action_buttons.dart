import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'share_experience_modal.dart';
import 'ask_question_modal.dart';
import '../bloc/post_bloc.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              text: 'Share Your Experience',
              icon: Icons.rate_review_outlined,
              onTap: () {
                final postBloc = BlocProvider.of<PostBloc>(context);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: postBloc,
                    child: const ShareExperienceModal(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              text: 'Ask A Question',
              icon: Icons.help_outline,
              onTap: () {
                final postBloc = BlocProvider.of<PostBloc>(context);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: postBloc,
                    child: const AskQuestionModal(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
