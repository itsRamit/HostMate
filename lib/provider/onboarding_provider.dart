import 'package:flutter_riverpod/legacy.dart';


class OnboardingState {
final List<int> selectedExperienceIds;
final String experienceText;
final String questionText;
final String? audioPath;
final String? videoPath;


OnboardingState({this.selectedExperienceIds = const [], this.experienceText = '', this.questionText = '', this.audioPath, this.videoPath});


OnboardingState copyWith({List<int>? selectedExperienceIds, String? experienceText, String? questionText, String? audioPath, String? videoPath}) {
return OnboardingState(
selectedExperienceIds: selectedExperienceIds ?? this.selectedExperienceIds,
experienceText: experienceText ?? this.experienceText,
questionText: questionText ?? this.questionText,
audioPath: audioPath ?? this.audioPath,
videoPath: videoPath ?? this.videoPath,
);
}
}


class OnboardingNotifier extends StateNotifier<OnboardingState> {
OnboardingNotifier(): super(OnboardingState());


void toggleExperience(int id) {
final ids = state.selectedExperienceIds.toList();
if (ids.contains(id)) ids.remove(id);
else ids.insert(0, id);
state = state.copyWith(selectedExperienceIds: ids);
}


void setExperienceText(String t) => state = state.copyWith(experienceText: t);
void setQuestionText(String t) => state = state.copyWith(questionText: t);
void setAudioPath(String? p) => state = state.copyWith(audioPath: p);
void setVideoPath(String? p) => state = state.copyWith(videoPath: p);
}


final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) => OnboardingNotifier());