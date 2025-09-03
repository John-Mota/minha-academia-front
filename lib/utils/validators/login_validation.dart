import 'package:lucid_validation/lucid_validation.dart';
import 'package:minha_academia_front/data/model/request/login_request_dto.dart';

class LoginValidator extends LucidValidator<LoginRequestDto> {
  LoginValidator() {
    ruleFor((login) => login.email, key: 'email')
        .notEmpty(message: 'E-mail obrigatório!')
        .validEmail(message: 'E-mail inválido!');

    ruleFor((login) => login.senha, key: 'senha')
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
  }
}
