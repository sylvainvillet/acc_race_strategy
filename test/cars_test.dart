// Import the test package and Counter class
import 'package:test/test.dart';
import 'package:accracestrategy/cars.dart';

void main() {
  group('Test cars class', () {
    test('Get first car of each class', () {
      final firstGt3 = getFirstCar('GT3');
      final firstGt4 = getFirstCar('GT4');
      final firstCup = getFirstCar('CUP');
      final firstSt = getFirstCar('ST');

      expect(firstGt3.ksName, "amr_v12_vantage_gt3");
      expect(firstGt4.ksName, "todo_alpine_a110_gt4");
      expect(firstCup.ksName, "porsche_991ii_gt3_cup");
      expect(firstSt.ksName, "lamborghini_huracan_st");
    });

    test('Get car method', () {
      final amgGt3 = getCar('GT3', "mercedes_amg_gt3");
      final unknownGt3 = getCar('GT3', "tata_mobile_gt3");

      expect(amgGt3.displayName, "Mercedes-AMG GT3");
      expect(unknownGt3.ksName, "amr_v12_vantage_gt3");
    });
  });
}
