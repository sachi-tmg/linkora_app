import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';

class UpdateRegularUserUseCase
    implements UsecaseWithParams<void, RegularUserEntity> {
  final IRegularUserRepository repository;

  UpdateRegularUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegularUserEntity regularUser) async {
    return await repository.updateRegularUser(regularUser);
  }
}
