import 'package:excel/excel.dart' as excel;
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_battle/organizer/create_battle.dart';

/// Builds an in-memory workbook whose first row is a header, mirroring the
/// sample file organizers are told to copy.
List<int> buildWorkbook(List<List<String?>> dataRows) {
  final book = excel.Excel.createExcel();
  final sheet = book[book.getDefaultSheet()!];

  sheet.appendRow([
    excel.TextCellValue('Question'),
    excel.TextCellValue('Option A'),
    excel.TextCellValue('Option B'),
    excel.TextCellValue('Option C'),
    excel.TextCellValue('Option D'),
    excel.TextCellValue('Answer'),
  ]);

  for (final row in dataRows) {
    sheet.appendRow([
      for (final cell in row)
        if (cell == null)
          excel.TextCellValue('')
        else
          excel.TextCellValue(cell),
    ]);
  }

  return book.encode()!;
}

void main() {
  group('parseQuestionRows', () {
    test('reads a well-formed sheet', () {
      final bytes = buildWorkbook([
        ['2 + 2?', '3', '4', '5', '6', 'B'],
        ['Capital of France?', 'Rome', 'Madrid', 'Paris', 'Berlin', 'C'],
      ]);

      final rows = parseQuestionRows(bytes);

      expect(rows, hasLength(2));
      expect(rows.first['question'], '2 + 2?');
      expect(rows.first['optionB'], '4');
      expect(rows.first['correctAnswer'], 'B');
      expect(rows.last['optionC'], 'Paris');
    });

    test('does not throw on rows shorter than the header', () {
      // A row missing its trailing cells used to blow up with a RangeError
      // and abort the whole battle creation.
      final bytes = buildWorkbook([
        ['Incomplete question', 'only one option'],
      ]);

      final rows = parseQuestionRows(bytes);

      expect(rows, hasLength(1));
      expect(rows.first['question'], 'Incomplete question');
      expect(rows.first['optionA'], 'only one option');
      expect(rows.first['optionD'], '');
      expect(rows.first['correctAnswer'], '');
    });

    test('skips blank padding rows', () {
      final bytes = buildWorkbook([
        ['Real question', 'a', 'b', 'c', 'd', 'A'],
        ['', '', '', '', '', ''],
      ]);

      expect(parseQuestionRows(bytes), hasLength(1));
    });

    test('returns an empty list for a header-only sheet', () {
      expect(parseQuestionRows(buildWorkbook([])), isEmpty);
    });
  });
}
