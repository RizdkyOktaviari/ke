class DrinkLog {
  final String drinkName;
  final int amount;

  DrinkLog({
    required this.drinkName,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'drink_name': drinkName,
    'amount': amount,
  };
}
