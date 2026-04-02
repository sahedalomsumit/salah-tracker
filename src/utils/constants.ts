export const COLORS = {
  primary: '#1F3D36', // Deep Green
  primaryLight: '#2E7D6B', // Soft Emerald
  background: '#1A1A1A', // Dark Background from README
  surface: '#252525', // Slightly lighter card surface
  surfaceElevated: '#333333', // Even lighter for active states
  text: '#FFFFFF', // Light Text for dark mode
  textLight: '#E0E0E0',
  grey: '#8A8A8A',
  status: {
    on_time: '#4CAF50',
    qaza: '#FF9800',
    missed: '#F44336',
  },
};

export const PRAYERS = [
  { id: 'fajr', name: 'Fajr' },
  { id: 'dhuhr', name: 'Dhuhr' },
  { id: 'asr', name: 'Asr' },
  { id: 'maghrib', name: 'Maghrib' },
  { id: 'isha', name: 'Isha' },
];

export const STATUSES = [
  { id: 'on_time', label: 'On Time', icon: 'check-circle' },
  { id: 'qaza', label: 'Qaza', icon: 'clock-outline' },
  { id: 'missed', label: 'Missed', icon: 'close-circle' },
];
