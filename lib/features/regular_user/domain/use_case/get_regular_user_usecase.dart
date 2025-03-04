import 'package:dartz/dartz.dart';
import 'package:linkora_app/app/usecase/usecase.dart';
import 'package:linkora_app/core/error/failure.dart';
import 'package:linkora_app/features/regular_user/domain/entity/regular_user_entity.dart';
import 'package:linkora_app/features/regular_user/domain/respository/regular_user_repository.dart';

class GetRegularUserUseCase
    implements UsecaseWithParams<RegularUserEntity, String> {
  final IRegularUserRepository repository;

  GetRegularUserUseCase(this.repository);

  @override
  Future<Either<Failure, RegularUserEntity>> call(String userId) async {
    return await repository.getRegularUser(userId);
  }
}
