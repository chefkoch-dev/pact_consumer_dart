import 'package:dart_dev/dart_dev.dart';

final config = {
  'analyze': AnalyzeTool()..analyzerArgs = [''],
  'format': FormatTool(),
  'test': TestTool(),
};
