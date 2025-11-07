import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host_mate/provider/onboarding_provider.dart';
import 'package:host_mate/widgets/stamp_card.dart';
import 'package:host_mate/widgets/stepper_bar.dart';
import '../services/api_service.dart';
import '../models/experience.dart';
import '../theme.dart';

class GradientNextButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  const GradientNextButton({super.key, required this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final gradient = enabled
        ? const LinearGradient(
            colors: [
              Color(0x07070707),
              Color.fromARGB(54, 255, 255, 255),
              Color(0x07070707),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0x07070707), Color(0x15FFFFFF), Color(0x07070707)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onPressed : null,
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surfaceBlack1,
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border3, width: 1),
          ),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Next', style: AppTextStyles.bodyMBold),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.text1,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExperienceSelectionScreen extends ConsumerStatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  ConsumerState<ExperienceSelectionScreen> createState() =>
      _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState
    extends ConsumerState<ExperienceSelectionScreen> {
  final ApiService _api = ApiService();
  late Future<List<Experience>> _future;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = _api.fetchExperiences();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.base2,
      appBar: AppBar(
        backgroundColor: AppColors.base2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const StepperBar(progress: 0.33),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Experience>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error: ${snap.error}',
                style: AppTextStyles.bodyMRegular,
              ),
            );
          }

          final items = snap.data ?? [];

          final enabled =
              state.selectedExperienceIds.isNotEmpty ||
              _controller.text.trim().isNotEmpty;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16 + bottomInset,
                  top: 0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('01', style: AppTextStyles.bodySRegular),
                        const SizedBox(height: 8),

                        const Text(
                          'What kind of experiences do you want to host?',
                          style: AppTextStyles.h2Bold,
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          height: w * 0.33,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final e = items[i];
                              final selected = state.selectedExperienceIds
                                  .contains(e.id);
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: StampCard(
                                  data: e,
                                  selected: selected,
                                  index: i,
                                  onTap: () => notifier.toggleExperience(e.id),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // textfield
                        TextField(
                          controller: _controller,
                          onChanged: (_) => setState(() {}),
                          maxLines: 10,
                          maxLength: 250,
                          style: AppTextStyles.bodyMRegular,
                          decoration: const InputDecoration(
                            hintText: '/ Describe your perfect hotspot',
                          ),
                        ),

                        const SizedBox(height: 12),

                        // next button
                        GradientNextButton(
                          enabled: enabled,
                          onPressed: () {
                            final s = ref.read(onboardingProvider);
                            debugPrint(
                              'Selected IDs: ${s.selectedExperienceIds}',
                            );
                            debugPrint('Experience text: ${_controller.text}');
                            notifier.setExperienceText(_controller.text);
                            Navigator.pushNamed(context, '/questions');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
