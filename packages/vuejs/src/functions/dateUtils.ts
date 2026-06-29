/**
 * Validate if a given date is valid
 */
export const validDate = (date: any): boolean => {
  if (!date) return false;
  const parsed = new Date(date);
  return !isNaN(parsed.getTime());
};
