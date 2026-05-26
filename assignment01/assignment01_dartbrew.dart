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
