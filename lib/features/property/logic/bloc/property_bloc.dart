import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:frontend/features/property/data/repositories/apartment_repository.dart';
import 'package:frontend/features/property/data/repositories/property_repository.dart';

part 'property_event.dart';
part 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository _propertyRepository;
  final ApartmentRepository _apartmentRepository;
  final TokenRepository _tokenRepository;

  PropertyBloc({required PropertyRepository propertyRepository, required ApartmentRepository apartmentRepository, required TokenRepository tokenRepository})
  : _propertyRepository = propertyRepository, _apartmentRepository = apartmentRepository, _tokenRepository = tokenRepository, super(PropertyInitial()) {
    
    on<PropertiesLoadEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final properties = await _propertyRepository.getAllProperties(accessToken);
        
        for (PropertyModel property in properties) {
          if (property.type == "apartment") {
            final apartments = await _apartmentRepository.getAllApartments(accessToken, property.id!);
            property.apartmentId = apartments.first.id!;
          }
        }
        emit(PropertiesLoaded(properties: properties));
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });

    on<PropertyCreateEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        await _propertyRepository.createProperty(accessToken, event.property);
        emit(const PropertyOperationSuccess('Property created successfully'));
        add(PropertiesLoadEvent()); // Refresh list
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });

    on<PropertyApartmentCreateEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final PropertyModel property = await _propertyRepository.createProperty(accessToken, event.property);
        ApartmentModel apartment = ApartmentModel(
          name: property.name,
          type: "apartment", 
          propertyId: property.id!,
        );
        await _apartmentRepository.createApartment(accessToken, apartment);
        emit(const PropertyOperationSuccess('Property created successfully'));
        add(PropertiesLoadEvent()); // Refresh list
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });

    on<PropertyLoadEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final PropertyModel property = await _propertyRepository.getProperty(
          accessToken, 
          event.propertyId
        );
        if (property.type == "apartment") {
          final apartments = await _apartmentRepository.getAllApartments(accessToken, property.id!);
          property.apartmentId = apartments.first.id!;
        }
        emit(PropertyLoaded(property: property));
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });

    on<PropertyUpdateEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        
        await _propertyRepository.updateProperty(accessToken, event.property);
        emit(const PropertyOperationSuccess('Property updated successfully'));
        add(PropertiesLoadEvent()); // Refresh list
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });

    on<PropertyDeleteEvent>((event, emit) async {
      emit(PropertyLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        
        await _propertyRepository.deleteProperty(accessToken, event.propertyId);
        emit(const PropertyOperationSuccess('Property deleted successfully'));
        add(PropertiesLoadEvent()); // Refresh list
      } catch (e) {
        emit(PropertyError(error: e.toString()));
      }
    });
  }
}
