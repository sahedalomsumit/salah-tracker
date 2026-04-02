import * as SQLite from 'expo-sqlite';

export type PrayerRecord = {
  id?: number;
  date: string; // YYYY-MM-DD
  prayer_name: string;
  status: string;
};

const DB_NAME = 'salah_tracker.db';

// Singleton-ish DB instance helper
let _db: SQLite.SQLiteDatabase | null = null;
const getDB = async () => {
  if (!_db) {
    _db = await SQLite.openDatabaseAsync(DB_NAME);
  }
  return _db;
};

export const initDB = async () => {
  const db = await getDB();
  await db.execAsync(`
    PRAGMA journal_mode = WAL;
    CREATE TABLE IF NOT EXISTS prayers (
      id INTEGER PRIMARY KEY NOT NULL,
      date TEXT NOT NULL,
      prayer_name TEXT NOT NULL,
      status TEXT NOT NULL,
      UNIQUE(date, prayer_name)
    );
  `);
};

import { supabaseService } from '../services/supabaseService.ts';

export const savePrayerStatus = async (record: PrayerRecord) => {
  try {
    const db = await getDB();
    const result = await db.runAsync(
      'INSERT OR REPLACE INTO prayers (date, prayer_name, status) VALUES (?, ?, ?)',
      [record.date, record.prayer_name, record.status]
    );
    console.log(`db.ts: Saved ${record.prayer_name} as ${record.status} for ${record.date} (result.changes: ${result.changes})`);
    
    // Cloud Sync (Best effort)
    try {
      await supabaseService.savePrayerStatus({
        date: record.date,
        prayer_name: record.prayer_name,
        status: record.status
      });
      console.log('db.ts: Synced to Supabase');
    } catch (syncError) {
      console.warn('db.ts: Supabase sync failed (offline or unconfigured)', syncError);
    }

    return result;
  } catch (error) {
    console.error('db.ts: savePrayerStatus failed', error);
    throw error;
  }
};


export const getPrayersForDate = async (date: string): Promise<PrayerRecord[]> => {
  try {
    const db = await getDB();
    const rows = await db.getAllAsync<PrayerRecord>(
      'SELECT * FROM prayers WHERE date = ?',
      [date]
    );
    return rows;
  } catch (error) {
    console.error('db.ts: getPrayersForDate failed', error);
    return [];
  }
};

export const getAllPrayers = async (): Promise<PrayerRecord[]> => {
  try {
    const db = await getDB();
    const rows = await db.getAllAsync<PrayerRecord>('SELECT * FROM prayers ORDER BY date DESC');
    return rows;
  } catch (error) {
    console.error('db.ts: getAllPrayers failed', error);
    return [];
  }
};
