import React from 'react';
import { View, StyleSheet, ScrollView, Dimensions } from 'react-native';
import { Text, Surface, Card } from 'react-native-paper';
import { useFocusEffect } from '@react-navigation/native';
import { BarChart, PieChart } from 'react-native-chart-kit';
import dayjs from 'dayjs';
import { getAllPrayers } from '../database/db.ts';
import { COLORS } from '../utils/constants.ts';

const screenWidth = Dimensions.get('window').width;

export const StatsScreen = () => {
  const [stats, setStats] = React.useState<{
    completionData: number[];
    labels: string[];
    statusDist: { name: string; population: number; color: string; legendFontColor: string }[];
    streak: number;
  }>({
    completionData: [0, 0, 0, 0, 0, 0, 0],
    labels: ['', '', '', '', '', '', ''],
    statusDist: [],
    streak: 0
  });

  const loadStats = async () => {
    const allRecords = await getAllPrayers();
    
    // Calculate Streak (all 5 prayers must be on_time or qaza)
    let streak = 0;
    let checkDate: dayjs.Dayjs | null = dayjs();
    const todayStr = dayjs().format('YYYY-MM-DD');
    
    // Check Today first
    const todayRecords = allRecords.filter(r => r.date === todayStr);
    const todayPerfCount = todayRecords.filter(r => r.status === 'on_time' || r.status === 'qaza').length;
    const todayMissed = todayRecords.some(r => r.status === 'missed');

    if (todayPerfCount === 5) {
      streak = 1;
      checkDate = dayjs().subtract(1, 'day');
    } else if (todayMissed) {
      // Streak broken today
      streak = 0;
      checkDate = null; // Don't check further
    } else {
      // Today is in progress, check from yesterday
      checkDate = dayjs().subtract(1, 'day');
    }

    // Check backwards from checkDate
    if (checkDate) {
      while (true) {
        const dateStr = checkDate.format('YYYY-MM-DD');
        const dayRecords = allRecords.filter(r => r.date === dateStr);
        const dayPerfCount = dayRecords.filter(r => r.status === 'on_time' || r.status === 'qaza').length;
        const dayMissed = dayRecords.some(r => r.status === 'missed');

        // A day is perfect only if all 5 are logged as on_time or qaza
        if (dayPerfCount === 5 && !dayMissed) {
          streak++;
          checkDate = checkDate.subtract(1, 'day');
        } else {
          // If the day is not perfect, the streak ends here
          break;
        }
      }
    }

    // Pie Chart Data
    const distribution = {
      on_time: allRecords.filter(r => r.status === 'on_time').length,
      qaza: allRecords.filter(r => r.status === 'qaza').length,
      missed: allRecords.filter(r => r.status === 'missed').length,
    };

    const pieData = [
      { name: 'On Time', population: distribution.on_time, color: COLORS.status.on_time, legendFontColor: '#FFFFFF' },
      { name: 'Qaza', population: distribution.qaza, color: COLORS.status.qaza, legendFontColor: '#FFFFFF' },
      { name: 'Missed', population: distribution.missed, color: COLORS.status.missed, legendFontColor: '#FFFFFF' },
    ];

    // Last 7 days chart
    const last7Days = Array.from({ length: 7 }, (_, i) => dayjs().subtract(6 - i, 'day'));
    const labels = last7Days.map(d => d.format('DD/MM'));
    const completionData = last7Days.map(d => {
      const dStr = d.format('YYYY-MM-DD');
      const count = allRecords.filter(r => r.date === dStr && (r.status === 'on_time' || r.status === 'qaza')).length;
      return (count / 5) * 100;
    });

    setStats({
      completionData,
      labels,
      statusDist: pieData.filter(d => d.population > 0),
      streak
    });
  };

  useFocusEffect(
    React.useCallback(() => {
      loadStats();
    }, [])
  );

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.scrollContent}>
      <View style={styles.streakContainer}>
        <Surface style={styles.streakCard} elevation={2}>
          <Text variant="displaySmall" style={styles.streakNumber}>{stats.streak}</Text>
          <Text variant="titleMedium" style={styles.streakLabel}>Day Streak 🔥</Text>
        </Surface>
      </View>

      <Text variant="titleMedium" style={styles.sectionTitle}>Status Distribution</Text>
      <Card style={styles.chartCard}>
        {stats.statusDist.length > 0 ? (
          <PieChart
            data={stats.statusDist}
            width={screenWidth - 64}
            height={200}
            chartConfig={chartConfig}
            accessor="population"
            backgroundColor="transparent"
            paddingLeft="15"
          />
        ) : (
          <Text style={styles.noData}>No data logged yet</Text>
        )}
      </Card>

      <Text variant="titleLarge" style={styles.sectionTitle}>Weekly Prayer Activity (%)</Text>
      <Card style={styles.chartCard}>
        <BarChart
          data={{
            labels: stats.labels,
            datasets: [{ data: stats.completionData }]
          }}
          width={screenWidth - 64}
          height={240}
          yAxisLabel=""
          yAxisSuffix="%"
          chartConfig={{
            ...chartConfig,
            barPercentage: 0.6,
            propsForLabels: {
              fontSize: 10,
              fontWeight: '600',
            },
            formatYLabel: (y) => Math.round(Number(y)).toString(),
          }}
          fromZero
          style={styles.barChart}
          showValuesOnTopOfBars
        />
      </Card>
      
      <View style={styles.spacer} />
    </ScrollView>
  );
};

const chartConfig = {
  backgroundColor: COLORS.surface,
  backgroundGradientFrom: COLORS.surface,
  backgroundGradientTo: COLORS.surface,
  decimalPlaces: 0,
  color: (opacity = 1) => `rgba(46, 125, 107, ${opacity})`,
  labelColor: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
  style: {
    borderRadius: 16,
  },
  propsForBackgroundLines: {
    strokeDasharray: "", // solid background lines
    stroke: "rgba(255, 255, 255, 0.1)",
  },
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  scrollContent: {
    padding: 16,
  },
  streakContainer: {
    alignItems: 'center',
    marginBottom: 24,
  },
  streakCard: {
    padding: 24,
    borderRadius: 100,
    width: 180,
    height: 180,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: COLORS.surface,
    borderWidth: 2,
    borderColor: '#FF9800',
  },
  streakNumber: {
    fontWeight: '900',
    color: '#FF9800',
  },
  streakLabel: {
    color: '#FFFFFF',
    fontWeight: '700',
  },
  sectionTitle: {
    marginBottom: 12,
    color: '#FFFFFF',
    fontWeight: 'bold',
  },
  chartCard: {
    padding: 16,
    marginBottom: 20,
    backgroundColor: COLORS.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#333333',
  },
  barChart: {
    marginVertical: 8,
    borderRadius: 16,
  },
  spacer: {
    height: 40,
  },
  noData: {
    textAlign: 'center',
    padding: 20,
    color: COLORS.grey,
  }
});
