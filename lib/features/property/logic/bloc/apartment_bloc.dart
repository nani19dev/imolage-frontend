import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/data/repositories/apartment_repository.dart';

part 'apartment_event.dart';
part 'apartment_state.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartmentRepository _apartmentRepository;
  final TokenRepository _tokenRepository;
  
  ApartmentBloc({required ApartmentRepository apartmentRepository, required TokenRepository tokenRepository}) 
  : _apartmentRepository = apartmentRepository, _tokenRepository = tokenRepository, super(ApartmentInitial()) {

    on<ApartmentsLoadEvent>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final apartments = await _apartmentRepository.getAllApartments(accessToken, event.propertyId);
        emit(ApartmentsLoaded(apartments: apartments));
      } catch (e) {
        emit(ApartmentError(error: e.toString()));
      }
    });

    on<ApartmentCreateEvent>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        await _apartmentRepository.createApartment(accessToken, event.apartment);
        emit(const ApartmentOperationSuccess('Apartment created successfully'));
        add(ApartmentsLoadEvent(event.apartment.propertyId)); // Refresh list
      } catch (e) {
        emit(ApartmentError(error: e.toString()));
      }
    });

    on<ApartmentLoadEvent>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');

        final ApartmentModel apartment = await _apartmentRepository.getApartment(accessToken, event.apartmentId);
        emit(ApartmentLoaded(apartment: apartment));
      } catch (e) {
        emit(ApartmentError(error: e.toString()));
      }
    });

    on<ApartmentUpdateEvent>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        
        await _apartmentRepository.updateApartment(accessToken, event.apartment);
        emit(const ApartmentOperationSuccess('Apartment updated successfully'));
        add(ApartmentsLoadEvent(event.apartment.propertyId)); // Refresh list
      } catch (e) {
        emit(ApartmentError(error: e.toString()));
      }
    });

    on<ApartmentDeleteEvent>((event, emit) async {
      emit(ApartmentLoading());
      try {
        final accessToken = await _tokenRepository.getAccessToken();
        if (accessToken == null) throw Exception('No access token available');
        String propertyId =  event.apartment.propertyId;
        await _apartmentRepository.deleteApartment(accessToken, event.apartment.id!);//fix later
        emit(const ApartmentOperationSuccess('Apartment deleted successfully'));
        add(ApartmentsLoadEvent(propertyId)); // Refresh list
      } catch (e) {
        emit(ApartmentError(error: e.toString()));
      }
    });
  }
}
