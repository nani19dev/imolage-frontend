part of 'property_bloc.dart';

sealed class PropertyState extends Equatable {
  const PropertyState();
  
  @override
  List<Object?> get props => [];
}

final class PropertyInitial extends PropertyState {}
final class PropertyLoading extends PropertyState {}

class PropertiesLoaded extends PropertyState {
  final List<PropertyModel> properties;
  const PropertiesLoaded({required this.properties});

  @override
  List<Object?> get props => [properties];
}

class PropertyLoaded extends PropertyState {
  final PropertyModel property;
  const PropertyLoaded({required this.property});

  @override
  List<Object?> get props => [property];
}

class PropertyOperationSuccess extends PropertyState {
  final String message;
  const PropertyOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class PropertyError extends PropertyState {
  final String error;

  const PropertyError({required this.error});

  @override
  List<Object?> get props => [error];
}
