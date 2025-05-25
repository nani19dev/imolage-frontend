part of 'apartment_bloc.dart';

sealed class ApartmentState extends Equatable {
  const ApartmentState();
  
  @override
  List<Object?> get props => [];
}

final class ApartmentInitial extends ApartmentState {}
final class ApartmentLoading extends ApartmentState {}

class ApartmentsLoaded extends ApartmentState {
  final List<ApartmentModel> apartments;
  const ApartmentsLoaded({required this.apartments});

  @override
  List<Object?> get props => [apartments];
}

class ApartmentLoaded extends ApartmentState {
  final ApartmentModel apartment;
  const ApartmentLoaded({required this.apartment});

  @override
  List<Object?> get props => [apartment];
}

class ApartmentOperationSuccess extends ApartmentState {
  final String message;
  const ApartmentOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class ApartmentError extends ApartmentState {
  final String error;

  const ApartmentError({required this.error});

  @override
  List<Object?> get props => [error];
}