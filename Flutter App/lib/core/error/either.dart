/// Either type for functional error handling
/// Returns either a Left (failure) or Right (success) value

abstract class Either<L, R> {
  const Either();
  
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight);

  R getOrElse(R Function(L l) f) {
    return fold(f, (r) => r);
  }

  Either<L, B> map<B>(B Function(R r) f) {
    return fold(
      (l) => Left(l),
      (r) => Right(f(r)),
    );
  }

  Either<L, B> flatMap<B>(Either<L, B> Function(R r) f) {
    return fold(
      (l) => Left(l),
      (r) => f(r),
    );
  }

  Either<B, R> mapLeft<B>(B Function(L l) f) {
    return fold(
      (l) => Left(f(l)),
      (r) => Right(r),
    );
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) {
    return ifLeft(value);
  }

  @override
  String toString() => 'Left($value)';
}

class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  B fold<B>(B Function(L l) ifLeft, B Function(R r) ifRight) {
    return ifRight(value);
  }

  @override
  String toString() => 'Right($value)';
}
