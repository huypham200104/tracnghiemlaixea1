import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/main.dart';
import 'package:app/core/storage/local_storage_service.dart';
import 'package:app/features/study/data/question_repository.dart';

void main() {
  testWidgets('A1QuizApp smoke test renders navigation and header', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.create();
    final repository = QuestionRepository();

    await tester.pumpWidget(
      A1QuizApp(
        storageService: storage,
        questionRepository: repository,
      ),
    );

    await tester.pump();

    // Kiểm tra render Header ứng dụng
    expect(find.text('GPLX A1 - 200 Câu'), findsOneWidget);
    expect(find.text('100% OFFLINE'), findsOneWidget);

    // Kiểm tra 4 Navigation Tab
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Ôn tập'), findsOneWidget);
    expect(find.text('Biển báo'), findsOneWidget);
    expect(find.text('Của tôi'), findsOneWidget);
  });
}
