
---

## 🔀 State Management
- Used **flutter_bloc** exclusively (Bloc not Cubit).
- **ListExpensesBloc** → handles loading, pagination, filtering.
- **AddExpenseBloc** → handles adding new expenses & currency conversion.
- UI reacts via `BlocBuilder` and `BlocListener`.

---

## 🌐 API Integration
- Currency conversion using free APIs:
    - [Exchangerate.host](https://exchangerate.host)
    - [Open ER API](https://open.er-api.com/v6/latest/USD)
- When adding an expense:
    1. Store in original currency.
    2. Fetch conversion rate.
    3. Save converted amount in **USD**.

---

## 📑 Pagination
- Implemented in **ListExpensesBloc**.
- Uses **page size = 10**.
- Events:
    - `LoadFirstPage` resets pagination with optional filters.
    - `LoadNextPage` loads and appends next batch.

---

## 🗄️ Local Storage
- Implemented with **Sqflite** for persistence.
- App supports offline-first behavior.

---

## 🧪 Testing
- Unit tests included with:
    - `flutter_test`
    - `bloc_test`
    - `mocktail`
- Coverage supported.

### Run Tests
```bash
flutter test
