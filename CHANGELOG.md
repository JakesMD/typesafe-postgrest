# Changelog

## 0.3.0 - 16.08.25
- ✨ Construct models from values directly (used in testing)
- ✏️ Rename `PgJoinToOne.fakeValuesFromModel` to `fromModel`, `PgJoinToMany.fakeValuesFromModels` to `fromModels`
- 🔥 Remove `buildFakePgModel`, `PgJoinToOne.fakeValues`, `PgJoinToMany.fakeValues`

## 0.2.6 - 14.08.25
- ✨ Add `PgMissingDataException`

## 0.2.5 - 14.08.25
- ✨ Add `fakeValuesFromModel` and `fakeValuesFromModels` methods

## 0.2.4 - 14.08.25
- ✨ Add `buildFakePgModel` function

## 0.2.3 - 13.08.25
- ✨ Expose `toJson` on `PgUpsert`

## 0.2.2 - 13.08.25
- 🐛 Fix `PgStringFilterColumnX` not exported

## 0.2.1 - 20.07.25
- ✨ Add `bool` and `double` columns

## 0.2.0 - 25.06.25
- ✨ Generate value getters for `PgUpsert`
- 🔥 Remove `value` method from `PgUpsert`
- 🐛 Fix generator not working for `PgMaybeJoinToOne`

## 0.1.2 - 25.06.25
- ✨ Add `value` method to `PgUpsert`

## 0.1.1 - 24.06.25
- 🐛 Fix generator not working for custom columns

## 0.1.0 - 24.06.25
- ✨ Add `fetchValues`, `fetchValue` and `maybeFetchValue`

## 0.0.2 - 24.06.25
- 📦 Fix flutter_test relies on lower version of meta

## 0.0.1 - 24.06.25
- 🎉 Initial release
