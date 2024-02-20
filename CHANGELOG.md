## 0.4.0

- Use slice name as action type prefix

## 0.3.3

- Fix payload function type in `createAction`

## 0.3.2

- Added `Draft.None`
- Added `Draft.nothing`
- Export type `Slice`

## 0.3.1

- Updated Immut to v0.4.0
- Added `Draft.sort`
- Added `Draft.clear`

## 0.3.0

- Documentation created
- `createSlice` now takes a single dictionary argument
- Added new Selector utilities:
  - `createSelector`
  - `createSelectorCreator`
  - `defaultMemoize`
- Reexported `Immut.remove` and `Immut.insert`
- Moved all Immut exports into `Draft`
  - `Draft.original`
  - `Draft.current`
  - `Draft.remove`
  - `Draft.insert`

## 0.2.1

- Reexported `Immut.original` and `Immut.current`

## 0.2.0

- Introduced Immut to RoduxUtils
- `createReducer` and `createSlice` now pass a draft to reducers

## 0.1.0

- Initial release
