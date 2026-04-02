import { supabase } from '../lib/supabase.ts';

export type SupabasePrayerRecord = {
  id?: string;
  user_id?: string;
  date: string;
  prayer_name: string;
  status: string;
  created_at?: string;
};

export const supabaseService = {
  /**
   * Upserts a prayer status record.
   * If a record for the same date and prayer_name exists, it updates it.
   */
  async savePrayerStatus(record: SupabasePrayerRecord) {
    const { data, error } = await supabase
      .from('prayers')
      .upsert(
        {
          date: record.date,
          prayer_name: record.prayer_name,
          status: record.status,
          user_id: record.user_id, // This will be null if not authenticated
        },
        { onConflict: 'user_id,date,prayer_name' }
      )
      .select();

    if (error) {
      console.error('supabaseService: savePrayerStatus failed', error);
      throw error;
    }
    return data;
  },

  /**
   * Fetches prayers for a specific date.
   */
  async getPrayersForDate(date: string) {
    const { data, error } = await supabase
      .from('prayers')
      .select('*')
      .eq('date', date);

    if (error) {
      console.error('supabaseService: getPrayersForDate failed', error);
      return [];
    }
    return data as SupabasePrayerRecord[];
  },

  /**
   * Fetches all prayers for the current user.
   */
  async getAllPrayers() {
    const { data, error } = await supabase
      .from('prayers')
      .select('*')
      .order('date', { ascending: false });

    if (error) {
      console.error('supabaseService: getAllPrayers failed', error);
      return [];
    }
    return data as SupabasePrayerRecord[];
  },
};
