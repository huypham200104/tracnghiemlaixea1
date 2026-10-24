import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/storage/local_storage_service.dart';
import 'features/study/data/question_repository.dart';
import 'features/profile/state/user_data_provider.dart';
import 'features/study/state/study_provider.dart';
import 'features/traffic_signs/state/traffic_signs_provider.dart';
import 'features/exam/state/exam_provider.dart';
import 'navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = await LocalStorageService.create();
  final questionRepository = QuestionRepository();

  runApp(
    A1QuizApp(
      storageService: storageService,
      questionRepository: questionRepository,
    ),
  );
}

/// Ứng dụng GPLX A1 - 200 Câu - 100% Offline
class A1QuizApp extends StatelessWidget {
  final LocalStorageService storageService;
  final QuestionRepository questionRepository;

  const A1QuizApp({
    super.key,
    required this.storageService,
    required this.questionRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => StudyProvider(questionRepository, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => TrafficSignsProvider(questionRepository),
        ),
        ChangeNotifierProxyProvider<UserDataProvider, ExamProvider>(
          create: (context) => ExamProvider(context.read<UserDataProvider>()),
          update: (_, userData, previous) => previous ?? ExamProvider(userData),
        ),
      ],
      child: MaterialApp(
        title: 'GPLX A1 - 200 Câu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
