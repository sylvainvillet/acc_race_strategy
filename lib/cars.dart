class Car {
  const Car(this.className, this.ksName, this.displayName, this.tank);

  final String className;
  final String ksName;
  final String displayName;
  final int tank;
}

Car getFirstCar(String className)
{
  for (Car car in carsList)
    if (car.className == className)
      return car;

  return carsList[0];
}

Car getCar(String className, String ksName)
{
  Car returnValue = getFirstCar(className);
  for (Car car in carsList)
      if (car.ksName == ksName)
        returnValue = car;

  return returnValue;
}

const List<Car> carsList = [
  Car("GT3", "amr_v12_vantage_gt3", "AMR V12 Vantage GT3", 132),
  Car("GT3", "amr_v8_vantage_gt3", "AMR V8 Vantage GT3", 120),
  Car("GT3", "audi_r8_lms", "Audi R8 LMS", 120),
  Car("GT3", "audi_r8_lms_evo", "Audi R8 LMS Evo", 120),
  Car("GT3", "bentley_continental_gt3_2016", "Bentley Continental GT3 2015", 132),
  Car("GT3", "bentley_continental_gt3_2018", "Bentley Continental GT3 2018", 120),
  Car("GT3", "bmw_m6_gt3", "BMW M6 GT3", 125),
  Car("GT3", "jaguar_g3", "Emil Frey Jaguar G3", 119),
  Car("GT3", "ferrari_488_gt3", "Ferrari 488 GT3", 110),
  Car("GT3", "ferrari_488_gt3_evo", "Ferrari 488 GT3 Evo", 110),
  Car("GT3", "honda_nsx_gt3", "Honda NSX GT3", 120),
  Car("GT3", "honda_nsx_gt3_evo", "Honda NSX GT3 Evo", 120),
  Car("GT3", "lamborghini_huracan_gt3", "Lamborghini Huracan GT3", 120),
  Car("GT3", "lamborghini_huracan_gt3_evo", "Lamborghini Huracan GT3 Evo", 120),
  Car("GT3", "lexus_rc_f_gt3", "Lexus RC-F GT3", 120),
  Car("GT3", "mclaren_650s_gt3", "McLaren 650S GT3", 125),
  Car("GT3", "mclaren_720s_gt3", "McLaren 720S GT3", 125),
  Car("GT3", "mercedes_amg_gt3", "Mercedes-AMG GT3", 120),
  Car("GT3", "mercedes_amg_gt3_evo", "Mercedes-AMG GT3 Evo", 120),
  Car("GT3", "nissan_gt_r_gt3_2015", "Nissan GT-R Nismo GT3 2015", 132),
  Car("GT3", "nissan_gt_r_gt3_2018", "Nissan GT-R Nismo GT3 2018", 132),
  Car("GT3", "porsche_991_gt3_r", "Porsche 911 GT3 R", 120),
  Car("GT3", "porsche_991ii_gt3_r", "Porsche 911 II GT3 R", 120),

  Car("GT4", "alpine_a110_gt4", "Alpine A110 GT4", 95),
  Car("GT4", "amr_v8_vantage_gt4", "Aston Martin V8 Vantage GT4", 120),
  Car("GT4", "audi_r8_gt4", "Audi R8 LMS GT4", 120),
  Car("GT4", "bmw_m4_gt4", "BMW M4 GT4", 127),
  Car("GT4", "chevrolet_camaro_gt4r", "Chevrolet Camaro GT4.R", 120),
  Car("GT4", "ginetta_g55_gt4", "Ginetta G55 GT4", 107),
  Car("GT4", "ktm_xbow_gt4", "KTM X-BOW GT4", 120),
  Car("GT4", "maserati_mc_gt4", "Maserati Granturismo MC GT4", 110),
  Car("GT4", "mclaren_570s_gt4", "McLaren 570S GT4", 110),
  Car("GT4", "mercedes_amg_gt4", "Mercedes AMG GT4", 120),
  Car("GT4", "porsche_718_cayman_gt4_mr", "Porsche 718 Cayman GT4", 115),

  Car("CUP", "porsche_991ii_gt3_cup", "Porsche 911 II GT3 Cup", 100),

  Car("ST", "lamborghini_huracan_st", "Lamborghini Huracan ST", 120),
];