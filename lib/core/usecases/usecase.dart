/// Abstract use-case base class.
/// [Result] is the return type, [Params] is the input parameter type.
abstract class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Use [NoParams] when a use-case takes no parameters.
class NoParams {
  const NoParams();
}
