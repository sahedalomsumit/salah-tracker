import { MD3DarkTheme as DefaultTheme } from 'react-native-paper';
import { COLORS } from './constants.ts';

export const theme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: COLORS.primaryLight,
    onPrimary: COLORS.text,
    secondary: COLORS.primary,
    onSecondary: COLORS.text,
    background: COLORS.background,
    surface: COLORS.surface,
    onSurface: COLORS.text,
    onSurfaceVariant: COLORS.grey,
    outline: COLORS.grey,
    error: COLORS.status.missed,
  },
  roundness: 16,
};
