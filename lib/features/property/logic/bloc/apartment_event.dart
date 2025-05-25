part of 'apartment_bloc.dart';

sealed class ApartmentEvent extends Equatable {
  const ApartmentEvent();

  @override
  List<Object?> get props => [];
}

class ApartmentsLoadEvent extends ApartmentEvent {
  final String propertyId;
  const ApartmentsLoadEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}

class ApartmentCreateEvent extends ApartmentEvent {
  final ApartmentModel apartment;
  const ApartmentCreateEvent(this.apartment);

  @override
  List<Object?> get props => [apartment];
}

class ApartmentLoadEvent extends ApartmentEvent {
  final String apartmentId;
  const ApartmentLoadEvent(this.apartmentId);
  
  @override
  List<Object?> get props => [apartmentId];
}

class ApartmentUpdateEvent extends ApartmentEvent {
  final ApartmentModel apartment;
  const ApartmentUpdateEvent(this.apartment);

  @override
  List<Object?> get props => [apartment];
}

class ApartmentDeleteEvent extends ApartmentEvent {
  final ApartmentModel apartment;
  const ApartmentDeleteEvent(this.apartment);

  @override
  List<Object?> get props => [apartment];
}