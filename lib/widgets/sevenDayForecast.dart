import 'package:flutter/material.dart';
import 'package:flutter_weather/helper/extensions.dart';
import 'package:flutter_weather/models/dailyWeather.dart';
import 'package:flutter_weather/provider/weatherProvider.dart';
import 'package:flutter_weather/screens/sevenDayForecastDetailScreen.dart';
import 'package:flutter_weather/theme/colors.dart';
import 'package:flutter_weather/theme/textStyle.dart';
import 'package:flutter_weather/widgets/customShimmer.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

import '../helper/utils.dart';

class SevenDayForecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProv, _) {
        List<DailyWeather> dailyWeather = weatherProv.dailyWeather;

        // Calculate 7-day average temperature
        double sevenDayAverageTemperature = 0.0;
        if (dailyWeather.length > 0) {
          double sum = 0.0;
          for (int i = 0; i < dailyWeather.length; i++) {
            sum += dailyWeather[i].tempMax;
          }
          sevenDayAverageTemperature = sum / dailyWeather.length;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  PhosphorIcon(PhosphorIconsRegular.calendar),
                  const SizedBox(width: 4.0),
                  Text(
                    '7-Day Forecast',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      textStyle: mediumText.copyWith(fontSize: 14.0),
                      foregroundColor: primaryBlue,
                    ),
                    child: Text('more details ▶'),
                    onPressed: weatherProv.isLoading
                        ? null
                        : () {
                      Navigator.of(context)
                          .pushNamed(SevenDayForecastDetail.routeName);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              child: weatherProv.isLoading
                  ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 7,
                itemBuilder: (context, index) => CustomShimmer(
                  height: 82.0,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dailyWeather.length,
                itemBuilder: (context, index) {
                  final DailyWeather weather = dailyWeather[index];
                  return Material(
                    borderRadius: BorderRadius.circular(12.0),
                    color: index.isEven ? backgroundWhite : Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          SevenDayForecastDetail.routeName,
                          arguments: index,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  index == 0
                                      ? 'Today'
                                      : DateFormat('EEEE').format(weather.date),
                                  style: semiboldText,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 36.0,
                                  width: 36.0,
                                  child: Image.asset(
                                    getWeatherImage(weather.weatherCategory),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  weather.weatherCategory,
                                  style: lightText,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  weatherProv.isCelsius
                                      ? '${weather.tempMax.toStringAsFixed(0)}°/${weather.tempMin.toStringAsFixed(0)}°'
                                      : '${weather.tempMax.toFahrenheit().toStringAsFixed(0)}°/${weather.tempMin.toFahrenheit().toStringAsFixed(0)}°',
                                  style: semiboldText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Display the 7-day average temperature here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '7-Day Average Temperature: ${sevenDayAverageTemperature.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
