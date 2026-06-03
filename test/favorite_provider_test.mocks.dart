// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:restaurant_app/data/db/database_helper.dart' as _i2;
import 'package:restaurant_app/data/models/restaurant.dart' as _i5;
import 'package:restaurant_app/data/repositories/favorite_repository.dart'
    as _i3;

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

class _FakeDatabaseHelper_0 extends _i1.SmartFake
    implements _i2.DatabaseHelper {
  _FakeDatabaseHelper_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class MockFavoriteRepository extends _i1.Mock
    implements _i3.FavoriteRepository {
  MockFavoriteRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DatabaseHelper get databaseHelper =>
      (super.noSuchMethod(
            Invocation.getter(#databaseHelper),
            returnValue: _FakeDatabaseHelper_0(
              this,
              Invocation.getter(#databaseHelper),
            ),
          )
          as _i2.DatabaseHelper);

  @override
  _i4.Future<List<_i5.Restaurant>> getFavorites() =>
      (super.noSuchMethod(
            Invocation.method(#getFavorites, []),
            returnValue: _i4.Future<List<_i5.Restaurant>>.value(
              <_i5.Restaurant>[],
            ),
          )
          as _i4.Future<List<_i5.Restaurant>>);

  @override
  _i4.Future<void> addFavorite(_i5.Restaurant? restaurant) =>
      (super.noSuchMethod(
            Invocation.method(#addFavorite, [restaurant]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<void> removeFavorite(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#removeFavorite, [id]),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);

  @override
  _i4.Future<bool> isFavorite(String? id) =>
      (super.noSuchMethod(
            Invocation.method(#isFavorite, [id]),
            returnValue: _i4.Future<bool>.value(false),
          )
          as _i4.Future<bool>);
}
