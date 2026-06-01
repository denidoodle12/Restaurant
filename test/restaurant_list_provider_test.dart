import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/repositories/restaurant_repository.dart';
import 'package:restaurant_app/providers/restaurant_list_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

import 'restaurant_list_provider_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
  });

  group('RestaurantListProvider', () {
    final mockRestaurants = [
      Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'A test restaurant',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      ),
      Restaurant(
        id: '2',
        name: 'Second Restaurant',
        description: 'Another test',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.0,
      ),
    ];

    test('initial state should be ResultLoading', () {
      when(mockRepository.getRestaurantList())
          .thenAnswer((_) async => mockRestaurants);
      final provider = RestaurantListProvider(repository: mockRepository);
      expect(provider.state, isA<ResultLoading<List<Restaurant>>>());
    });

    test(
      'should return list of restaurants when API call is successful',
      () async {
        when(mockRepository.getRestaurantList())
            .thenAnswer((_) async => mockRestaurants);

        final provider = RestaurantListProvider(repository: mockRepository);
        await provider.fetchRestaurantList();

        expect(provider.state, isA<ResultSuccess<List<Restaurant>>>());
        final state = provider.state as ResultSuccess<List<Restaurant>>;
        expect(state.data.length, 2);
        expect(state.data.first.name, 'Test Restaurant');
      },
    );

    test('should return ResultError when API call fails', () async {
      when(mockRepository.getRestaurantList())
          .thenThrow(Exception('Network error'));

      final provider = RestaurantListProvider(repository: mockRepository);
      await provider.fetchRestaurantList();

      expect(provider.state, isA<ResultError<List<Restaurant>>>());
      final state = provider.state as ResultError<List<Restaurant>>;
      expect(state.message, isNotEmpty);
    });

    test('should return ResultEmpty when API returns empty list', () async {
      when(mockRepository.getRestaurantList()).thenAnswer((_) async => []);

      final provider = RestaurantListProvider(repository: mockRepository);
      await provider.fetchRestaurantList();

      expect(provider.state, isA<ResultEmpty<List<Restaurant>>>());
    });
  });
}
