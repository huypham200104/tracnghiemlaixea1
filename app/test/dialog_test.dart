import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/exam/presentation/dialogs/exam_start_dialog.dart';
import 'package:app/features/exam/presentation/dialogs/exam_exit_dialog.dart';
import 'package:app/features/exam/presentation/dialogs/exam_submit_dialog.dart';
import 'package:app/features/profile/presentation/dialogs/reset_data_confirm_dialog.dart';
import 'package:app/features/profile/presentation/dialogs/app_settings_dialog.dart';
import 'package:app/features/profile/presentation/dialogs/government_source_dialog.dart';
import 'package:app/features/traffic_signs/presentation/dialogs/traffic_sign_detail_dialog.dart';
import 'package:app/features/traffic_signs/domain/traffic_sign_model.dart';
import 'package:app/features/home/presentation/dialogs/tips_dialog.dart';

void main() {
  Widget buildTestApp(Widget dialog, {Size size = const Size(360, 640)}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: Scaffold(
          body: dialog,
        ),
      ),
    );
  }

  testWidgets('ExamStartDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(ExamStartDialog(onConfirm: () {})),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ExamExitDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(ExamExitDialog(onConfirmExit: () {})),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ExamSubmitDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(ExamSubmitDialog(unansweredCount: 3, onConfirmSubmit: () {})),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('ResetDataConfirmDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(ResetDataConfirmDialog(onConfirmReset: () {})),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('AppSettingsDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(
        AppSettingsDialog(
          fontSize: 'medium',
          soundEnabled: true,
          onFontSizeChanged: (_) {},
          onSoundEnabledChanged: (_) {},
          onRequestResetData: () {},
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('GovernmentSourceDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const GovernmentSourceDialog()),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('TrafficSignDetailDialog renders without overflow', (tester) async {
    const sign = TrafficSign(
      code: 'W.201a',
      name: 'Chỗ ngoặt nguy hiểm vòng bên trái',
      group: 'nguyhiem',
      description: 'Báo trước sắp đến một chỗ ngoặt nguy hiểm vòng về phía bên trái.',
      isInExam: true,
      tips: 'Gặp biển này phải giảm tốc độ.',
    );
    await tester.pumpWidget(
      buildTestApp(const TrafficSignDetailDialog(sign: sign)),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('TipsDialog renders without overflow', (tester) async {
    await tester.pumpWidget(
      buildTestApp(const TipsDialog()),
    );
    expect(tester.takeException(), isNull);
  });
}
