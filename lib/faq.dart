import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kFaq = {
  'How to use ACC Strategist':
      'Just fill the form, adjust the average lap time and fuel usage if needed, and click Go!\n'
          'The app will then show you a screen with all the information needed for your race.',
  'How does it work?': 'The app first calculates a base strategy, without any fuel saving.\n'
      'Then, if the race has more than 1 pit stop, it will compute a strategy with 1 pit stop less, which means with fuel saving.\n'
      'If this strategy is valid according to the rules and the fuel saving is under 20%, it will be shown in a separate tab.\n'
      'Average lap time and cut-offs are adjusted too, to compensate the time gained by avoiding a pit stop.\n'
      'Then, the app tries to reduce again the number of pit stops, until it\'s not valid anymore. There can be up to 6 strategies for 24h races.',
  'Does the app takes any margin?':
      'No, the app doesn\'t take any margin, but it shows you for each stint the average fuel consumption.\n'
          'If you keep your average under this value, you will be fine, as long as the average lap time was not set too slow.\n'
          'If you want to take some margin, you can always add a few more liters or increase the fuel consumption.',
  'What are lower and higher cut-off times?':
      'Lower cut-off is the average lap time limit where the race would be 1 lap longer, and higher cut-off the limit where the race would be 1 lap shorter.\n'
          'If the average lap time is close to the lower cut-off, you might want to take a few extra liters just to be sure.',
  'Which engine map should I use?':
      'Use the fastest engine map in practice and enter the fuel usage in the app.\n'
          'If the race is long enough to justify a fuel saving strategy, test different maps to see how you can reach the fuel usage wanted without loosing too much time.',
  'How to save fuel during a race?': 'There are 3 different ways to save fuel, '
      'short shifting (don\'t rev all the way to the rev limiter, switch gear earlier), '
      'engine maps (see above) and '
      'lift\'n\'coast (lift the throttle earlier than the normal braking point, coast a bit, then brake later than the normal braking point).\n'
      'It seams that the last one is not very effective in ACC, but short shifting and engine maps can save you a lot of fuel with minimal time lost, but it will change a lot for each track-car combo so you\'ll need to do some tests..\n',
  'Should I go for the fuel saving strategy?':
      'You can see that the average lap time is different for each strategy. If, for example, the average lap time is 2:00 for the normal strategy and 2:01 for the fuel saving one, '
          'then if you can reach the fuel usage needed without loosing more than 1s per lap, go for the fuel saving strategy, otherwise the normal one..',
  'What about wet races?':
      'You can adjust the average lap time and fuel usage to match the weather conditions.\n'
          'Just take a bit of margin in case the weather is getting better and lap times are getting faster again.',
  'Can I see a lap-by-lap breakdown?':
      'Yes, just click on a stint to open a detailed view.',
  'I have another question, can I contact you?':
  'Sure, you can send me an e-mail at sylvain.villet@gmail.com.',
};

class Faq extends StatelessWidget {
  final _margin = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView.builder(
        itemCount: kFaq.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            child: Card(
              elevation: 3,
              child: ExpansionTile(
                title: Text(kFaq.keys.elementAt(index)),
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _margin,
                      0,
                      _margin,
                      _margin,
                    ),
                    child: Text(kFaq.values.elementAt(index)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
