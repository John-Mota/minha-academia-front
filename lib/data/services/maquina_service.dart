import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:minha_academia_front/presentation/features/maquinas/cadastro_maquina_screen.dart';
import 'package:minha_academia_front/presentation/features/maquinas/maquinas_screen.dart';

class MaquinaService {
  Future<List<MachineCardData>> getMaquinas() async {
    try {
      final String jsonString = await rootBundle.loadString('mock.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> maquinasJson = data['maquinas'];
      final List<MachineCardData> maquinas = maquinasJson
          .map((item) => MachineCardData.fromJson(item))
          .toList();

      return maquinas;
    } catch (e) {
      print("Erro ao carregar dados das máquinas: $e");
      return [];
    }
  }
}
