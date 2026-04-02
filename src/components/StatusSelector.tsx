import React from 'react';
import { StyleSheet, View, TouchableOpacity } from 'react-native';
import { Modal, Portal, Text, Surface } from 'react-native-paper';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { STATUSES, COLORS } from '../utils/constants.ts';

interface StatusSelectorProps {
  onSelect: (status: string) => void;
  visible: boolean;
  onDismiss: () => void;
  prayerName: string;
}

export const StatusSelector = ({ onSelect, visible, onDismiss, prayerName }: StatusSelectorProps) => {
  return (
    <Portal>
      <Modal
        visible={visible}
        onDismiss={onDismiss}
        contentContainerStyle={styles.container}
      >
        <Surface style={styles.content} elevation={4}>
          <Text variant="headlineSmall" style={styles.title}>Update {prayerName}</Text>
          <Text variant="bodyMedium" style={styles.subtitle}>Select the status for this prayer</Text>
          
          <View style={styles.list}>
            {STATUSES.map((status) => (
              <TouchableOpacity
                key={status.id}
                style={styles.item}
                onPress={() => {
                  onSelect(status.id);
                  onDismiss();
                }}
                activeOpacity={0.7}
              >
                <View style={[styles.iconContainer, { backgroundColor: (COLORS.status as Record<string, string>)[status.id] + '20' }]}>
                  <MaterialCommunityIcons 
                    name={status.icon as keyof typeof MaterialCommunityIcons.glyphMap} 
                    size={32} 
                    color={(COLORS.status as Record<string, string>)[status.id]} 
                  />
                </View>
                <Text variant="labelLarge" style={styles.label}>{status.label}</Text>
              </TouchableOpacity>
            ))}
          </View>
        </Surface>
      </Modal>
    </Portal>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    backgroundColor: COLORS.surfaceElevated,
    padding: 24,
    borderRadius: 24,
    width: '100%',
    maxWidth: 340,
    alignItems: 'center',
  },
  title: {
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 4,
    textAlign: 'center',
  },
  subtitle: {
    color: COLORS.grey,
    marginBottom: 24,
    textAlign: 'center',
  },
  list: {
    width: '100%',
    alignItems: 'center',
  },
  item: {
    width: '100%',
    backgroundColor: COLORS.surface,
    padding: 16,
    borderRadius: 16,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#333333',
  },
  iconContainer: {
    width: 48,
    height: 48,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  label: {
    color: '#FFFFFF',
    fontWeight: '600',
    fontSize: 16,
    flex: 1,
  },
});
