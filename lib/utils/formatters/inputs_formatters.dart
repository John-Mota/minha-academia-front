import 'package:flutter/services.dart';

class InputFormatters {
  // Formatação de CPF (000.000.000-00)
  static TextInputFormatter cpfFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.length > 11) return oldValue;

      var formatted = text;
      if (text.length > 9) {
        formatted =
            '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}';
      } else if (text.length > 6) {
        formatted =
            '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6)}';
      } else if (text.length > 3) {
        formatted = '${text.substring(0, 3)}.${text.substring(3)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  // Desformatação de CPF (00000000000)
  static String cpfDesformatter(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Formatação de data (DD/MM/AAAA)
  static TextInputFormatter dateFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.length > 8) return oldValue;

      var formatted = text;
      if (text.length > 4) {
        formatted =
            '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4)}';
      } else if (text.length > 2) {
        formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  // Desformatação de data (AAAA-MM-DD)
  static String dateDesformatter(String formattedDate) {
    if (formattedDate.isEmpty) return '';

    // Remove todos os caracteres não numéricos
    final digitsOnly = formattedDate.replaceAll(RegExp(r'[^0-9]'), '');

    // Garante que temos pelo menos 8 dígitos (DDMMAAAA)
    if (digitsOnly.length != 8) return formattedDate;

    // Extrai dia, mês e ano
    final day = digitsOnly.substring(0, 2);
    final month = digitsOnly.substring(2, 4);
    final year = digitsOnly.substring(4);

    // Formata para AAAA-MM-DD
    return '$year-$month-$day';
  }

  // Formatação de telefone ((00) 00000-0000)
  static TextInputFormatter phoneFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.length > 11) return oldValue;

      var formatted = text;
      if (text.length > 6) {
        formatted =
            '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}';
      } else if (text.length > 2) {
        formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  static String phoneFormatterWithMask(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length < 2) return digitsOnly;

    final areaCode = digitsOnly.substring(0, 2);
    final mainNumber = digitsOnly.substring(2);

    if (mainNumber.length <= 5) {
      return '($areaCode) $mainNumber';
    } else {
      final firstPart = mainNumber.substring(0, 5);
      final secondPart = mainNumber.substring(5);
      return '($areaCode) $firstPart-$secondPart';
    }
  }

  // Desformatação de telefone (00000000000)
  static String phoneDesformatter(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Formatação de Titulo de Eleitor (0000 0000 0000)
  static TextInputFormatter tituloEleitorFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.length > 12) return oldValue;

      var formatted = text;
      if (text.length > 8) {
        formatted =
            '${text.substring(0, 4)} ${text.substring(4, 8)} ${text.substring(8)}';
      } else if (text.length > 4) {
        formatted = '${text.substring(0, 4)} ${text.substring(4)}';
      }
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  // Desformatação de Titulo de Eleitor (00000000000)
  static String tituloEleitorDesformatter(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Formatação de CEP (00000-000)
  static TextInputFormatter cepFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

      if (text.length > 8) return oldValue;

      var formatted = text;
      if (text.length > 5) {
        formatted = '${text.substring(0, 5)}-${text.substring(5)}';
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }

  // Desformatação de CEP (apenas números)
  static String cepDesformatter(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Formatação de CREF (000000-G/SP)
  static TextInputFormatter crefFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Remove caracteres que não são letras ou números e converte para maiúsculo
      var text = newValue.text.toUpperCase().replaceAll(
        RegExp(r'[^A-Z0-9]'),
        '',
      );

      // Limita o tamanho do texto base (6 números + 1 letra + 2 letras)
      if (text.length > 9) {
        text = text.substring(0, 9);
      }

      var formatted = '';
      if (text.length > 7) {
        // 000000-G/SP
        formatted =
            '${text.substring(0, 6)}-${text.substring(6, 7)}/${text.substring(7)}';
      } else if (text.length > 6) {
        // 000000-G
        formatted = '${text.substring(0, 6)}-${text.substring(6)}';
      } else {
        formatted = text;
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }
}
