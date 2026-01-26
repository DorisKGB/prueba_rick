import 'dart:async';

///Basis for use cases
///
///[I] input object
///[O] output object

abstract class UseCase<I, O> {  
  Future<O> execute(I param);
}

abstract class UseCaseStream<I, O> {
  Stream<O> execute(I param);
}
