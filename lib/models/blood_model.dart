class BloodPressure {
  final int systolicPressure;
  final int diastolicPressure;

  BloodPressure({
    required this.systolicPressure,
    required this.diastolicPressure,
  });

  Map<String, dynamic> toJson() => {
    'systolic_pressure': systolicPressure,
    'diastolic_pressure': diastolicPressure,
  };
}