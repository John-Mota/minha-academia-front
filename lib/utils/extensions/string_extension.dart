extension StringExtension on String {
  String maskCPF() {
    if (length != 11) return this;
    return '${substring(0, 3)}.${substring(3, 6)}'
        '.${substring(6, 9)}-${substring(9, 11)}';
  }

  String keepOnlyNumbers() {
    return replaceAll(RegExp('[^0-9]'), '');
  }

  String maskPhoneNumber() {
    if (length != 11) return this;
    return '(${substring(0, 2)}) ${substring(2, 7)}-${substring(7, 11)}';
  }
}
