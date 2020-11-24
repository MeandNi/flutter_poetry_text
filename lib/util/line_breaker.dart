class LineBreaker {

  String _text;
  List<int> _breaks;

  set text(String text) {
    if (text == _text) {
      return;
    }
    _text = text;
    _breaks = null;
  }

  // returns the number of breaks
  int computeBreaks() {
    if (_breaks != null) {
      return _breaks.length;
    }
    _breaks = [];

    for (int i = 1; i < _text.length; i++) {
      if (isBreakChar(_text[i - 1]) && !isBreakChar(_text[i])) {
        _breaks.add(i);
      }
    }

    return _breaks.length;
  }

  List<int> get breaks => _breaks;

  static const space = '，';
  bool isBreakChar(String codeUnit) {
    return codeUnit == space;
  }
}
