import React from 'react';
import { StyleSheet, View } from 'react-native';
import { Card, Text, IconButton } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, STATUSES } from '../utils/constants.ts';

interface PrayerCardProps {
  name: string;
  status: string;
  onPress: () => void;
}

export const PrayerCard = ({ name, status, onPress }: PrayerCardProps) => {
  const currentStatus = STATUSES.find(s => s.id === status);
  const statusColor: string = (COLORS.status as Record<string, string>)[status] || COLORS.grey;

  return (
    <Card style={styles.card} onPress={onPress}>
      <Card.Content style={styles.content}>
        <View style={styles.left}>
          <Text variant="titleMedium" style={styles.prayerName}>{name}</Text>
          <View style={[styles.statusBadge, { backgroundColor: statusColor + '20' }]}>
            <Text style={[styles.statusText, { color: statusColor }]}>
              {currentStatus ? currentStatus.label : 'Not Logged'}
            </Text>
          </View>
        </View>
        <IconButton
          icon={currentStatus ? (currentStatus.icon as keyof typeof MaterialCommunityIcons.glyphMap) : 'help-circle-outline'}
          iconColor={statusColor}
          size={28}
        />
      </Card.Content>
    </Card>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: 12,
    backgroundColor: COLORS.surface,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: '#333333',
  },
  content: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
  },
  left: {
    flex: 1,
  },
  prayerName: {
    fontWeight: '700',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  statusBadge: {
    alignSelf: 'flex-start',
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 8,
  },
  statusText: {
    fontSize: 12,
    fontWeight: '600',
  },
});
