class Car {
  const Car(this.ksName, this.displayName, this.tank);

  final String ksName;
  final String displayName;
  final int tank;
}

const List<Car> carsList = [
  Car("amr_v12_vantage_gt3", "AMR V8 Vantage GT3", 120),
  Car("audi_r8_lms_evo", "Audi R8 LMS Evo", 120),
  Car("todo", "Bentley Continental GT3", 132),
  Car("bmw_m6_gt3", "BMW M6 GT3", 125),
  Car("ferrari_488_gt3", "Ferrari 488 GT3", 110),
  Car("todo", "Honda NSX GT3 Evo", 120),
  Car("todo", "Lamborghini Huracan GT3", 120), // TODO
  Car("todo", "Lamborghini Huracan GT3 Evo", 120),
  Car("lexus_rc_f_gt3", "Lexus RC-F GT3", 120),
  Car("todo", "McLaren 720S GT3", 125),
  Car("todo", "Mercedes-AMG GT3", 120),
  Car("todo", "Nissan GT-R Nismo GT3", 132),
  Car("todo", "Porsche 911 II GT3 Cup", 120), // TODO
  Car("porsche_991ii_gt3_r", "Porsche 911 II GT3 R", 120),
];