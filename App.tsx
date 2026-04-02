import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { PaperProvider } from 'react-native-paper';
import { StatusBar } from 'expo-status-bar';
import { BottomTabs } from './src/navigation/BottomTabs.tsx';
import { theme } from './src/utils/theme.ts';
import { initDB } from './src/database/db.ts';

export default function App() {
  React.useEffect(() => {
    initDB()
      .then(() => console.log('Database initialized'))
      .catch((err: Error) => console.error('Database initialization failed', err));
  }, []);

  return (
    <PaperProvider theme={theme}>
      <NavigationContainer>
        <BottomTabs />
        <StatusBar style="auto" />
      </NavigationContainer>
    </PaperProvider>
  );
}
