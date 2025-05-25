part of 'property_bloc.dart';

sealed class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object?> get props => [];
}

class PropertiesLoadEvent extends PropertyEvent {}

class PropertyCreateEvent extends PropertyEvent {
  final PropertyModel property;
  const PropertyCreateEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyApartmentCreateEvent extends PropertyEvent {
  final PropertyModel property;
  const PropertyApartmentCreateEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyLoadEvent extends PropertyEvent {
  final String propertyId;
  const PropertyLoadEvent(this.propertyId);
  
  @override
  List<Object?> get props => [propertyId];
}

class PropertyUpdateEvent extends PropertyEvent {
  final PropertyModel property;
  const PropertyUpdateEvent(this.property);

  @override
  List<Object?> get props => [property];
}

class PropertyDeleteEvent extends PropertyEvent {
  final String propertyId;
  const PropertyDeleteEvent(this.propertyId);

  @override
  List<Object?> get props => [propertyId];
}
