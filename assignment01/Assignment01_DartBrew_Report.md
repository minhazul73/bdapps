# Assignment 01 — DartBrew Coffee CLI (OOP & Collections)

**Date:** May 21, 2026  
**Dart SDK:** 3.11.0 (stable) (windows_x64)

---

## Part A — Conceptual Questions

### 1) Abstract Class (OOP)
- **Role of an Abstract Class:**
  - An abstract class is a “blueprint” type that cannot be instantiated directly. It defines shared properties/behaviors (and often abstract methods) that all child classes must implement.
  - In practice, it’s how we model a concept like “a menu item” without claiming we know the exact details of pricing and display for every possible item.

- **Why it is essential for the Coffee Menu:**
  - We don’t instantiate generic `MenuItem` objects because a generic “menu item” doesn’t have a *complete* concrete behavior—e.g., how it calculates its final price (toppings vs no toppings) or how it prints details.
  - An abstract `MenuItem` enforces a **contract**: every coffee type must implement `calculatePrice()` and `displayDetails()`. This guarantees the `OrderManager` can treat all items uniformly (polymorphism) while still getting correct behavior from `StandardCoffee` and `CustomCoffee`.

### 2) Encapsulation
- **Role of Encapsulation (Bank Vault analogy):**
  - Encapsulation is like storing valuables inside a bank vault: you don’t let anyone directly grab or change what’s inside.
  - Instead, you expose controlled ways to interact (methods/getters), so rules/validation are always applied.

- **Real-life application in DartBrew:**
  - If `_cart` were public, code outside the `OrderManager` could remove items, insert invalid items, or reorder items in a way that breaks receipt logic.
  - If `_totalRevenue` were public, someone could do something like `myOrderManager.totalRevenue = 5000;` from `main()` and “fake” revenue, bypassing checkout calculations. That breaks data integrity, makes totals unreliable, and makes auditing impossible.

### 3) Dart Collections: List vs Set vs Map
- **Comparison (ordering & uniqueness):**

| Collection | Keeps insertion order? | Allows duplicates? | Best for |
|---|---:|---:|---|
| `List<T>` | Yes | Yes | Ordered sequences, carts, histories |
| `Set<T>` | Yes (LinkedHashSet default) | No | Unique items (no repeats) |
| `Map<K,V>` | Yes (LinkedHashMap default) | Keys unique | Lookup / pairing (name → value) |

- **Verdict for Menu Base Prices:**
  - **Use a `Map<String, double>`** because you are pairing a coffee name like `"Latte"` with a price like `4.00`. A map gives fast lookup by name and makes the “name → price” relationship explicit.

- **Verdict for Coffee Toppings:**
  - **Use a `Set<String>`** for a user’s requested extras so duplicates are automatically prevented (so the user can’t accidentally pay for `"Vanilla"` twice).

---

## Part B — Design & Implementation

### 1) Class Architecture (Text Outline)
- **Base Class:** `MenuItem` (Abstract)
  - Declares:
    - `double calculatePrice()`
    - `String displayDetails()`

- **Child Classes:**
  - `StandardCoffee extends MenuItem`
    - **Overrides:** `calculatePrice()`, `displayDetails()`
  - `CustomCoffee extends MenuItem`
    - Has: `Set<String> toppings`, `Map<String,double> toppingPrices`
    - **Overrides:** `calculatePrice()`, `displayDetails()`

- **Manager Class:** `OrderManager`
  - Private state:
    - `_cart` (List of `MenuItem`)
    - `_totalRevenue` (double)
  - Public getters:
    - `cart` (unmodifiable view)
    - `totalRevenue`
    - `cartTotal`
  - Checkout builds receipt and clears cart.

- **CLI / Control Flow:**
  - `main()` provides a `while (true)` menu loop.
  - User input is handled safely with null-aware operators and `int.tryParse()`.

### 2) Dart Implementation Code

File: `assignment.dart`

```dart
import 'dart:io';

abstract class MenuItem {
	final String name;
	final double basePrice;

	const MenuItem({required this.name, required this.basePrice});

	double calculatePrice();
	String displayDetails();
}

class StandardCoffee extends MenuItem {
	const StandardCoffee({required super.name, required super.basePrice});

	@override
	double calculatePrice() => basePrice;

	@override
	String displayDetails() {
		return '$name (Standard) - \$${calculatePrice().toStringAsFixed(2)}';
	}
}

class CustomCoffee extends MenuItem {
	final Set<String> toppings;
	final Map<String, double> toppingPrices;

	CustomCoffee({
		required super.name,
		required super.basePrice,
		Set<String>? toppings,
		Map<String, double>? toppingPrices,
	})  : toppings = toppings ?? <String>{},
			toppingPrices = toppingPrices ?? <String, double>{};

	bool addTopping(String topping) {
		return toppings.add(topping);
	}

	@override
	double calculatePrice() {
		final extrasTotal = toppings.fold<double>(
			0,
			(sum, topping) => sum + (toppingPrices[topping] ?? 0),
		);
		return basePrice + extrasTotal;
	}

	@override
	String displayDetails() {
		final toppingList = toppings.isEmpty ? 'No toppings' : toppings.join(', ');
		return '$name (Custom) + [$toppingList] - \$${calculatePrice().toStringAsFixed(2)}';
	}
}

class OrderManager {
	final List<MenuItem> _cart = <MenuItem>[];
	double _totalRevenue = 0;

	List<MenuItem> get cart => List.unmodifiable(_cart);
	double get totalRevenue => _totalRevenue;

	void addItem(MenuItem item) {
		_cart.add(item);
	}

	double get cartTotal => _cart.fold<double>(0, (sum, item) => sum + item.calculatePrice());

	String checkoutAndBuildReceipt() {
		final total = cartTotal;
		_totalRevenue += total;

		final receiptLines = <String>[
			'===== DartBrew Receipt =====',
			for (final item in _cart) '- ${item.displayDetails()}',
			if (_cart.isEmpty) '(Cart was empty)',
			'----------------------------',
			'Total: \$${total.toStringAsFixed(2)}',
			'Thank you for visiting DartBrew!'
		];

		final receipt = '''
${receiptLines.join('\n')}
''';

		_cart.clear();
		return receipt;
	}
}

int _readInt(String prompt) {
	while (true) {
		stdout.write(prompt);
		final input = (stdin.readLineSync() ?? '').trim();
		final value = int.tryParse(input);
		if (value != null) return value;
		print('Invalid input. Please enter a number.');
	}
}

void _pressEnterToContinue() {
	stdout.write('Press Enter to continue...');
	stdin.readLineSync();
}

void main() {
	final menuBasePrices = <String, double>{
		'Espresso': 3.00,
		'Latte': 4.00,
		'Cappuccino': 4.50,
	};

	final toppingPrices = <String, double>{
		'Vanilla': 0.50,
		'Caramel': 0.75,
		'Whipped Cream': 1.00,
	};

	final orderManager = OrderManager();

	while (true) {
		print('\n=== DartBrew Coffee CLI ===');
		print('1) Add standard coffee');
		print('2) Add custom coffee');
		print('3) View cart');
		print('4) Checkout');
		print('0) Exit');

		final choice = _readInt('Select an option: ');

		switch (choice) {
			case 1:
				{
					print('\n--- Standard Coffee Menu ---');
					final items = menuBasePrices.entries.toList();
					for (var i = 0; i < items.length; i++) {
						final entry = items[i];
						print('${i + 1}) ${entry.key} - \$${entry.value.toStringAsFixed(2)}');
					}

					final pick = _readInt('Choose a coffee: ');
					if (pick < 1 || pick > items.length) {
						print('Invalid selection.');
						_pressEnterToContinue();
						break;
					}

					final selected = items[pick - 1];
					final coffee = StandardCoffee(name: selected.key, basePrice: selected.value);
					orderManager.addItem(coffee);
					print('Added to cart: ${coffee.displayDetails()}');
					_pressEnterToContinue();
					break;
				}

			case 2:
				{
					print('\n--- Custom Coffee Builder ---');
					final items = menuBasePrices.entries.toList();
					for (var i = 0; i < items.length; i++) {
						final entry = items[i];
						print('${i + 1}) ${entry.key} - \$${entry.value.toStringAsFixed(2)}');
					}

					final pick = _readInt('Choose a base coffee: ');
					if (pick < 1 || pick > items.length) {
						print('Invalid selection.');
						_pressEnterToContinue();
						break;
					}

					final selected = items[pick - 1];
					final custom = CustomCoffee(
						name: selected.key,
						basePrice: selected.value,
						toppingPrices: toppingPrices,
					);

					print('\nAdd toppings (duplicates are prevented by Set).');
					final toppingList = toppingPrices.entries.toList();
					for (var i = 0; i < toppingList.length; i++) {
						final entry = toppingList[i];
						print('${i + 1}) ${entry.key} - \$${entry.value.toStringAsFixed(2)}');
					}
					print('0) Done');

					while (true) {
						final toppingChoice = _readInt('Select topping number (0 to finish): ');
						if (toppingChoice == 0) break;
						if (toppingChoice < 1 || toppingChoice > toppingList.length) {
							print('Invalid topping selection.');
							continue;
						}

						final toppingName = toppingList[toppingChoice - 1].key;
						final added = custom.addTopping(toppingName);
						if (added) {
							print('Added topping: $toppingName');
						} else {
							print('Topping already added: $toppingName');
						}
					}

					orderManager.addItem(custom);
					print('Added to cart: ${custom.displayDetails()}');
					_pressEnterToContinue();
					break;
				}

			case 3:
				{
					print('\n--- Your Cart ---');
					if (orderManager.cart.isEmpty) {
						print('(empty)');
					} else {
						for (var i = 0; i < orderManager.cart.length; i++) {
							final item = orderManager.cart[i];
							print('${i + 1}) ${item.displayDetails()}');
						}
						print('Cart total: \$${orderManager.cartTotal.toStringAsFixed(2)}');
					}
					_pressEnterToContinue();
					break;
				}

			case 4:
				{
					final receipt = orderManager.checkoutAndBuildReceipt();
					print(receipt);
					_pressEnterToContinue();
					break;
				}

			case 0:
				print('Goodbye!');
				return;

			default:
				print('Invalid menu option. Try again.');
				_pressEnterToContinue();
		}
	}
}
```

### 3) Summary of Test Results (Terminal Output)

#### Test 1 — Standard Order (added a standard coffee)

```text

=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: 
--- Standard Coffee Menu ---
1) Espresso - $3.00
2) Latte - $4.00
3) Cappuccino - $4.50
Choose a coffee: Added to cart: Espresso (Standard) - $3.00
Press Enter to continue...
=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: Goodbye!
```

#### Test 2 — Custom Order (Duplicate topping test using `Set`)

```text

=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: 
--- Custom Coffee Builder ---
1) Espresso - $3.00
2) Latte - $4.00
3) Cappuccino - $4.50
Choose a base coffee: 
Add toppings (duplicates are prevented by Set).
1) Vanilla - $0.50
2) Caramel - $0.75
3) Whipped Cream - $1.00
0) Done
Select topping number (0 to finish): Added topping: Vanilla
Select topping number (0 to finish): Topping already added: Vanilla
Select topping number (0 to finish): Added to cart: Latte (Custom) + [Vanilla] - $4.50
Press Enter to continue...
=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: Goodbye!
```

#### Test 3 — Checkout & Receipt (multiline strings + collection `for/if`)

```text

=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: 
--- Standard Coffee Menu ---
1) Espresso - $3.00
2) Latte - $4.00
3) Cappuccino - $4.50
Choose a coffee: Added to cart: Latte (Standard) - $4.00
Press Enter to continue...
=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: 
--- Custom Coffee Builder ---
1) Espresso - $3.00
2) Latte - $4.00
3) Cappuccino - $4.50
Choose a base coffee: 
Add toppings (duplicates are prevented by Set).
1) Vanilla - $0.50
2) Caramel - $0.75
3) Whipped Cream - $1.00
0) Done
Select topping number (0 to finish): Added topping: Caramel
Select topping number (0 to finish): Added to cart: Espresso (Custom) + [Caramel] - $3.75
Press Enter to continue...
=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: ===== DartBrew Receipt =====
- Latte (Standard) - $4.00
- Espresso (Custom) + [Caramel] - $3.75
----------------------------
Total: $7.75
Thank you for visiting DartBrew!

Press Enter to continue...
=== DartBrew Coffee CLI ===
1) Add standard coffee
2) Add custom coffee
3) View cart
4) Checkout
0) Exit
Select an option: Goodbye!
```

---

## Part C — Critical Thinking

### 1) Handling text input (e.g., user types "Two") without crashing
- `stdin.readLineSync()` returns a `String?` (nullable). It captures the entire line typed by the user (or `null` on EOF).
- `int.parse("Two")` throws a `FormatException`, which can crash the app if not caught.
- `int.tryParse("Two")` returns `null` instead of throwing, so you can safely route invalid input.
- Strengthened control flow pattern:
  - Read with null safety: `final input = (stdin.readLineSync() ?? '').trim();`
  - Parse with `tryParse`.
  - If parse fails, show an error message and loop again.
  - In a `switch`, route invalid options to `default:` with an error message.

### 2) Dynamic pricing (Happy Hour) — Getter vs mutating stored data
- **Getter/on-the-fly approach (recommended for integrity):**
  - Example: `double get discountedTotal => _totalRevenue * 0.9;`
  - **Pros:** doesn’t permanently change the underlying data, easy to toggle, safer for auditing.
  - **Cons:** you must apply the discount consistently wherever totals are displayed.

- **Mutating stored prices (changing Map/List values):**
  - Example: modifying all base prices in `menuBasePrices` during happy hour.
  - **Pros:** simple mental model for “prices are currently discounted”.
  - **Cons:** risky: you may forget to restore originals, affect future orders incorrectly, and lose the ability to compare “original vs discounted” totals.

- **Safer approach for data integrity:** compute discounts on-the-fly via a getter or a single calculation at checkout, not by rewriting base data.

### 3) Sorting receipt by most expensive coffees first
- You can sort a `List<MenuItem>` using `.sort()` with a comparator.
- To sort by calculated price descending:

```dart
_cart.sort((a, b) => b.calculatePrice().compareTo(a.calculatePrice()));
```

- If you don’t want to mutate `_cart`, sort a copy:

```dart
final sortedCart = [..._cart]..sort((a, b) => b.calculatePrice().compareTo(a.calculatePrice()));
```
