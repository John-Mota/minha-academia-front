import 'package:minha_academia_front/utils/exceptions/exceptions.dart';

class RepositoryException extends AppException {
  const RepositoryException(super.message, [super.stackTrace]);
}

class LocalStorageException extends AppException {
  const LocalStorageException(super.message, [super.stackTrace]);
}

class EmptyLocalStorageException extends AppException {
  const EmptyLocalStorageException(super.message, [super.stackTrace]);
}

class FileServiceException extends AppException {
  const FileServiceException(super.message, [super.stackTrace]);
}
