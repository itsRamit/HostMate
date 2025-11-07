import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:host_mate/screens/experience_screen.dart';
import 'package:host_mate/screens/onboarding_question.dart';
import 'package:host_mate/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotspot Host Onboarding',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      routes: {
      '/': (context) => const ExperienceSelectionScreen(),
      '/questions': (context) => const OnboardingQuestionScreen(),
      },
    );
  }
}

