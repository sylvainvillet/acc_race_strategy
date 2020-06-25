class Car {
  const Car(this.className, this.ksName, this.displayName, this.tank);

  final String className;
  final String ksName;
  final String displayName;
  final int tank;
}

Car getCar(String ksName)
{
  Car returnValue = carsList[0];
  for (Car car in carsList)
      if (car.ksName == ksName)
        returnValue = car;

  return returnValue;
}

const List<Car> carsList = [
  Car("GT3", "amr_v12_vantage_gt3", "AMR V8 Vantage GT3", 120),
  Car("GT3", "audi_r8_lms_evo", "Audi R8 LMS Evo", 120),
  Car("GT3", "todo_bentley", "Bentley Continental GT3", 132),
  Car("GT3", "bmw_m6_gt3", "BMW M6 GT3", 125),
  Car("GT3", "ferrari_488_gt3", "Ferrari 488 GT3", 110),
  Car("GT3", "todo_nsx", "Honda NSX GT3 Evo", 120),
  Car("GT3", "todo_huracan_gt3", "Lamborghini Huracan GT3", 120), // TODO tank
  Car("GT3", "todo_huracan_gt3_evo", "Lamborghini Huracan GT3 Evo", 120),
  Car("GT3", "lexus_rc_f_gt3", "Lexus RC-F GT3", 120),
  Car("GT3", "todo_720s_gt3", "McLaren 720S GT3", 125),
  Car("GT3", "todo_amg_gt3", "Mercedes-AMG GT3", 120),
  Car("GT3", "todo_gtr", "Nissan GT-R Nismo GT3", 132),
  Car("GT3", "todo_gt3_cup", "Porsche 911 II GT3 Cup", 120), // TODO tank
  Car("GT3", "porsche_991ii_gt3_r", "Porsche 911 II GT3 R", 120),
];