// lib/config/dependencies.dart

import 'dart:io';

import 'package:minha_academia_front/data/local_storage.dart';
import 'package:minha_academia_front/main.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> get providers {
  return [
    ..._sharedServices,
    ..._sharedRepositories,
    ..._sharedUseCases,
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ];
}

List<SingleChildWidget> _sharedServices = [
  Provider(create: (ctx) => LocalStorage()),
  Provider(create: (ctx) => HttpClient()),
];

List<SingleChildWidget> _sharedRepositories = [
  // Adicione seus novos repositórios aqui
  // Ex:
  // Provider(create: (ctx) => AlunoRepository(ctx.read())),
];

List<SingleChildWidget> _sharedUseCases = [
  // Adicione seus novos use cases aqui
  // Ex:
  // Provider(create: (ctx) => LoginUseCase(ctx.read())),
];
