import React from 'react';
import { View, StyleSheet } from 'react-native';
import { List, Switch, Divider, Text } from 'react-native-paper';
import { COLORS } from '../utils/constants.ts';

export const SettingsScreen = () => {
  const [remindersEnabled, setRemindersEnabled] = React.useState(true);

  return (
    <View style={styles.container}>
      <List.Section>
        <List.Subheader>App Preferences</List.Subheader>
        <List.Item
          title="Prayer Reminders"
          description="Get notified when it's time for prayer"
          left={props => <List.Icon {...props} icon="bell-outline" />}
          right={() => (
            <Switch
              value={remindersEnabled}
              onValueChange={setRemindersEnabled}
              color={COLORS.primaryLight}
            />
          )}
        />
        <Divider />
        <List.Item
          title="Theme"
          description="Default (Islamic Green)"
          left={props => <List.Icon {...props} icon="palette-outline" />}
        />
      </List.Section>

      <List.Section>
        <List.Subheader>Data & Privacy</List.Subheader>
        <List.Item
          title="Export Data"
          left={props => <List.Icon {...props} icon="export-variant" />}
          onPress={() => {}}
        />
        <Divider />
        <List.Item
          title="Reset All Progress"
          left={props => <List.Icon {...props} icon="delete-outline" color={COLORS.status.missed} />}
          titleStyle={{ color: COLORS.status.missed }}
          onPress={() => {}}
        />
      </List.Section>

      <View style={styles.footer}>
        <Text variant="bodySmall" style={styles.versionText}>Salah Tracker v1.0.0</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.background,
  },
  footer: {
    marginTop: 'auto',
    padding: 24,
    alignItems: 'center',
  },
  versionText: {
    color: COLORS.grey,
  }
});
