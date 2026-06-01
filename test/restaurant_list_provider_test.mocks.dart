// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:restaurant_app/data/api/api_service.dart' as _i2;
import 'package:restaurant_app/data/models/customer_review.dart' as _i7;
import 'package:restaurant_app/data/models/restaurant.dart' as _i6;
import 'package:restaurant_app/data/models/restaurant_detail.dart' as _i3;
import 'package:restaurant_app/data/repositories/restaurant_repository.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class
// ignore_for_file: invalid_use_of_internal_member

class _FakeApiService_0 extends _i1.SmartFake implements _i2.ApiService {
  _FakeApiService_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeRestaurantDetail_1 extends _i1.SmartFake
    implements _i3.RestaurantDetail {
  _FakeRestaurantDetail_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class MockRestaurantRepository extends _i1.Mock
    implements _i4.RestaurantRepository {
  MockRestaurantRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ApiService get apiService =>
      (super.noSuchMethod(
            Invocation.getter(#apiService),
            returnValue: _FakeApiService_0(
              this,
              Invocation.getter(#apiService),
            ),
          )
          as _i2.ApiService);

  @override
  _i5.Future<List<_i6.Restaurant>> getRestaurantList() =>
      (super.noSuchMethod(
            Invocation.method(#getRestaurantList, []),
            returnValue: _i5.Future<List<_i6.Restaurant>>.value(
              <_i6.Restaurant>[],
            ),
          )
          as _i5.Future<List<_i6.Restaurant>>);

  @override
  _i5.Future<_i3.RestaurantDetail> getRestaurantDetail(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#getRestaurantDetail, [id]),
            returnValue: _i5.Future<_i3.RestaurantDetail>.value(
              _FakeRestaurantDetail_1(
                this,
                Invocation.method(#getRestaurantDetail, [id]),
              ),
            ),
          )
          as _i5.Future<_i3.RestaurantDetail>);

  @override
  _i5.Future<List<_i6.Restaurant>> searchRestaurants(String? query) =>
      (super.noSuchMethod(
            Invocation.method(#searchRestaurants, [query]),
            returnValue: _i5.Future<List<_i6.Restaurant>>.value(
              <_i6.Restaurant>[],
            ),
          )
          as _i5.Future<List<_i6.Restaurant>>);

  @override
  _i5.Future<List<_i7.CustomerReview>> addReview({
    required String? id,
    required String? name,
    required String? review,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#addReview, [], {
              #id: id,
              #name: name,
              #review: review,
            }),
            returnValue: _i5.Future<List<_i7.CustomerReview>>.value(
              <_i7.CustomerReview>[],
            ),
          )
          as _i5.Future<List<_i7.CustomerReview>>);
}
