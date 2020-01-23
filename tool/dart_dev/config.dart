import 'package:dart_dev/dart_dev.dart';

final config = {
  'analyze': AnalyzeTool()..analyzerArgs = ['--fatal-hints'],
  'format': FormatTool(),
  'test': TestTool(),
};
