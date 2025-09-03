import 'package:lucid_validation/lucid_validation.dart';
import 'package:minha_academia_front/data/model/request/alterar_senha_dto.dart';

class AlterarSenhaValidation extends LucidValidator<AlterarSenhaDto> {
  AlterarSenhaValidation() {
    ruleFor((senha) => senha.senhaAtual, key: "senhaAtual")
        .notEmpty(message: 'Senha atual é obrigatória!')
        .minLength(6, message: 'Senha atual deve ter pelo menos 6 caracteres!');

    ruleFor((senha) => senha.senhaNova, key: "senhaNova")
        .notEmpty(message: 'Senha nova é obrigatória!')
        .minLength(6, message: 'Senha nova deve ter pelo menos 6 caracteres!');
  }
}
