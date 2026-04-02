import React from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { Text, ProgressBar, IconButton, Surface } from 'react-native-paper';
import { useFocusEffect } from '@react-navigation/native';
import dayjs from 'dayjs';
import { PrayerCard } from '../components/PrayerCard.tsx';
import { StatusSelector } from '../components/StatusSelector.tsx';
import { COLORS, PRAYERS } from '../utils/constants.ts';
import { getPrayersForDate, savePrayerStatus } from '../database/db.ts';

export const TrackerScreen = () => {
  const [selectedDate, setSelectedDate] = React.useState(dayjs());
  const [prayersData, setPrayersData] = React.useState<Record<string, string>>({});
  const [menuVisible, setMenuVisible] = React.useState(false);
  const [activePrayer, setActivePrayer] = React.useState<string | null>(null);
  const [isLoading, setIsLoading] = React.useState(true);

  const loadData = async (targetDate?: dayjs.Dayjs) => {
    const dateToLoad = targetDate || selectedDate;
    const dateStr = dateToLoad.format('YYYY-MM-DD');
    
    // Only show loading if we are changing dates (not background refreshes)
    if (!targetDate) setIsLoading(true);
    
    const records = await getPrayersForDate(dateStr);
    
    // Check if the date hasn't changed since the request started
    if (dateStr === selectedDate.format('YYYY-MM-DD')) {
      const data: Record<string, string> = {};
      records.forEach((r) => {
        data[r.prayer_name] = r.status;
      });
      setPrayersData(data);
      setIsLoading(false);
    }
  };

  // Main effect to load data when date changes
  React.useEffect(() => {
    setPrayersData({}); // Clear stale data
    setIsLoading(true);
    loadData(selectedDate);
    setMenuVisible(false); // Close menu on date change
  }, [selectedDate]);

  // Refresh data when screen focuses
  useFocusEffect(
    React.useCallback(() => {
      loadData(selectedDate);
    }, [selectedDate])
  );

  const handleUpdateStatus = async (status: string) => {
    if (!activePrayer) return;

    // Optimistic Update
    setPrayersData(prev => ({ ...prev, [activePrayer]: status }));

    const dateStr = selectedDate.format('YYYY-MM-DD');
    try {
      await savePrayerStatus({
        date: dateStr,
        prayer_name: activePrayer,
        status: status
      });
      console.log(`Saved ${activePrayer} as ${status} for ${dateStr}`);
    } catch (error) {
      console.error('Failed to save prayer status:', error);
    }
  };

  const openMenu = (prayerId: string) => {
    setActivePrayer(prayerId);
    setMenuVisible(true);
  };

  const changeDate = (days: number) => {
    setSelectedDate(prev => prev.add(days, 'day'));
  };

  const loggedCount = Object.values(prayersData).filter(s => s === 'on_time' || s === 'qaza').length;
  const progress = loggedCount / 5;

  return (
    <View style={styles.container}>
      <Surface style={styles.header} elevation={1}>
        <View style={styles.dateSelector}>
          <IconButton icon="chevron-left" onPress={() => changeDate(-1)} />
          <View style={styles.dateInfo}>
            <Text variant="titleLarge" style={styles.dateText}>
              {selectedDate.isSame(dayjs(), 'day') ? 'Today' : selectedDate.format('DD MMM YYYY')}
            </Text>
            <Text variant="bodySmall" style={styles.dayText}>{selectedDate.format('dddd')}</Text>
          </View>
          <IconButton 
            icon="chevron-right" 
            onPress={() => changeDate(1)} 
            disabled={selectedDate.isSame(dayjs(), 'day')} 
          />
        </View>

        <View style={styles.progressContainer}>
          <View style={styles.progressTextRow}>
            <Text variant="labelLarge">Daily Completion</Text>
            <Text variant="labelLarge" style={styles.percentageText}>{Math.round(progress * 100)}%</Text>
          </View>
          <ProgressBar progress={progress} color={COLORS.status.on_time} style={styles.progressBar} />
        </View>
      </Surface>

      <ScrollView 
        contentContainerStyle={styles.scrollContent}
        style={isLoading ? { opacity: 0.6 } : null}
      >
        {PRAYERS.map((prayer) => (
          <PrayerCard
            key={prayer.id}
            name={prayer.name}
            status={prayersData[prayer.id] || ''}
            onPress={() => openMenu(prayer.id)}
          />
        ))}
      </ScrollView>

      <StatusSelector
        visible={menuVisible}
        onDismiss={() => setMenuVisible(false)}
        onSelect={handleUpdateStatus}
        prayerName={PRAYERS.find(p => p.id === activePrayer)?.name || ''}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  header: {
    padding: 16,
    backgroundColor: COLORS.surface,
    borderBottomLeftRadius: 24,
    borderBottomRightRadius: 24,
    borderBottomWidth: 1,
    borderBottomColor: '#333333',
  },
  dateSelector: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  dateInfo: {
    alignItems: 'center',
  },
  dateText: {
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  dayText: {
    color: COLORS.grey,
  },
  progressContainer: {
    marginTop: 8,
  },
  progressTextRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  percentageText: {
    color: COLORS.primaryLight,
    fontWeight: 'bold',
  },
  progressBar: {
    height: 8,
    borderRadius: 4,
  },
  scrollContent: {
    padding: 16,
    paddingBottom: 32,
  },
});
