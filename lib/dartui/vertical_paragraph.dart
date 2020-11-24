import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_poetry_text/model/line_info.dart';
import 'package:flutter_poetry_text/model/text_word.dart';
import 'package:flutter_poetry_text/model/vertical_paragraph_constraints.dart';

class VerticalParagraph {
  VerticalParagraph(this._paragraphStyle, this._textStyle, this._text);

  ui.ParagraphStyle _paragraphStyle;
  ui.TextStyle _textStyle;
  String _text;

  double _width;
  double _height;
  double _minIntrinsicHeight;
  double _maxIntrinsicHeight;

  double get width => _width;

  double get height => _height;

  double get minIntrinsicHeight => _minIntrinsicHeight;

  double get maxIntrinsicHeight => _maxIntrinsicHeight;

  List<Word> _words = [];

  void layout(VerticalParagraphConstraints constraints) =>
      _layout(constraints.height);

  void _layout(double height) {
    if (height == _height) {
      return;
    }
    int count = _text.length;
    for (int i=0; i<count; i++) {
      _addWord(i);									// 保存文本中的每个字
    }
    _calculateLineBreaks(height);		// 计算换行
    _calculateWidth();							// 计算宽度
    _height = height;
    _calculateIntrinsicHeight();		// 计算高度
    print("There are ${_words.length} zis.");
    print("There are ${_lines.length} lines.");
    print("width=$width height=$height");
    print("min=$minIntrinsicHeight max=$maxIntrinsicHeight");
  }

  void _addWord(int index) {
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(_textStyle)
      ..addText(_text.substring(index, index + 1));
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: double.infinity));
    // 将每个字都保存在一个 paragraph 中，封装在 Word 中并放入 _words 列表
    final run = Word(index, paragraph);
    _words.add(run);
  }

  List<LineInfo> _lines = [];

  void _calculateLineBreaks(double maxLineLength) {
    if (_words.isEmpty) {
      return;
    }
    if (_lines.isNotEmpty) {
      _lines.clear();
    }

    int start = 0;
    int end;
    double lineWidth = 0;
    double lineHeight = 0;
    // 遍历之前保存的每一个 Word 对象
    for (int i=0; i<_words.length; i++) {
      end = i;
      final word = _words[i];
      final wordWidth = word.paragraph.maxIntrinsicWidth;
      final wordHeight = word.paragraph.height;
      // 遇到 “，”、“。” 换行，保存每行的宽度和高度，调用 _addLine 放入 _lines 列表中
      if (_text.substring(i, i + 1) == "，" || _text.substring(i, i + 1) == "。") {
        lineWidth += math.max(lineWidth, wordWidth);
        _addLine(start, end+1, lineWidth, lineHeight);
        start = end + 1;
        lineWidth = 0;
        lineHeight = 0;
      } else {
        // 一行未结束，以竖直方向计算，该行的整体高度应该加上一个文字的高度
        lineHeight += wordHeight;
      }
    }
    end = _words.length;
    if (start < end) {
      _addLine(start, end, lineWidth, lineHeight);
    }
  }

  void _addLine(int start, int end, double width, double height) {
    final bounds = Rect.fromLTRB(0, 0, width, height);
    final LineInfo lineInfo = LineInfo(start, end, bounds);
    _lines.add(lineInfo);
  }

  // 宽度为每行 “诗” 宽度的总和
  void _calculateWidth() {
    double sum = 0;
    for (LineInfo line in _lines) {
      sum += line.bounds.width;
    }
    _width = sum;
  }

  // 高度取诗中最长的一行（以竖直方向为高）
  void _calculateIntrinsicHeight() {
    double sum = 0;
    double maxRunHeight = 0;
    for (LineInfo line in _lines) {
      sum += line.bounds.width;
      maxRunHeight = math.max(line.bounds.height, maxRunHeight);
    }
    _minIntrinsicHeight = maxRunHeight;
    _maxIntrinsicHeight = maxRunHeight;
  }

  // 计算完每个文字和每行诗后，既可以在这里绘制文本了
  void draw(Canvas canvas, Offset offset) {
    canvas.save();
    // 移至开始位置
    canvas.translate(offset.dx, offset.dy);
    // 绘制每一行
    for (LineInfo line in _lines) {
      // 移到绘制该行的开始处
      canvas.translate(line.bounds.width + 20, 0);
      // 绘制每一个 word
      double dy = 0;
      for (int i = line.textRunStart; i < line.textRunEnd; i++) {
        // 绘制每行诗中的文字，偏移量为该字位于所在行的位置
        canvas.drawParagraph(_words[i].paragraph, Offset(0, dy));
        dy += _words[i].paragraph.height;
      }
    }

    canvas.restore();
  }
}
