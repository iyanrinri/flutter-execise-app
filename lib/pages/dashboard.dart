import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:testing/layouts/main.dart';
import 'package:testing/widgets/double_back_to_exit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExitWrapper(
      child: MainLayout(
        title: 'Dashboard',
        titleIcon: Icon(Icons.dashboard),
        child: PageView(children: const [DashboardContent()])
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;

  const TabButton({super.key, required this.title, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 30),
        LineChartWidget(),
        const SizedBox(height: 30),
        const RingChartWidget(),
        const SizedBox(height: 30),
        Divider(),
        const SizedBox(height: 30),
        Center(child: const Text("Select Time")),
        const SliderWidget(),
      ],
    );
  }
}

class CircularStatusIndicator extends StatelessWidget {
  const CircularStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 40.0,
      lineWidth: 8.0,
      percent: 0.455,
      center: const Text("4.55"),
      progressColor: Colors.blue,
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 2),
                FlSpot(3, 5),
                FlSpot(4, 3.5),
                FlSpot(5, 4),
                FlSpot(6, 4.5),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class RingChartWidget extends StatelessWidget {
  const RingChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 15.0,
          percent: 0.8,
          animation: true,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.redAccent,
          backgroundColor: Colors.orange,
        ),
        const Text(
          "SEVERE",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: 16.0,
      min: 0.0,
      max: 24.0,
      divisions: 24,
      label: "4:00 PM",
      onChanged: (value) {},
    );
  }
}
