import 'package:lucid_validation/lucid_validation.dart';
import 'package:minha_academia_front/data/model/request/validar_recuperacao_request_dto.dart';

class ValidarSenhaValidation
    extends LucidValidator<ValidarRecuperacaoRequestDto> {
  ValidarSenhaValidation() {
    ruleFor((validar) => validar.novaSenha, key: 'senha')
        .notEmpty(message: 'Senha obrigatória!')
        .minLength(6, message: 'Senha deve ter no mínimo 6 caracteres!')
        .mustHaveLowercase(
          message: 'Senha deve ter pelo menos 1 letra minúscula!',
        )
        .mustHaveUppercase(
          message: 'Senha deve ter pelo menos 1 letra maiúscula!',
        )
        .mustHaveNumber(message: 'Senha deve ter pelo menos 1 número!')
        .mustHaveSpecialCharacter(
          message: 'Senha deve ter pelo menos 1 caractere especial!',
        );

    ruleFor((validar) => validar.pinCode, key: "pinCode")
        .notEmpty(message: 'PIN obrigatório!')
        .matchesPattern(r'^\d{6}$', message: 'PIN deve ter 6 dígitos!');
  }
}
