/**
 * Convert an array of objects to an object mapping by a specific key
 */
export const arrayToObject = <T extends Record<string, any>>(arr: T[], keyField: keyof T): Record<string, T> => {
  if (!Array.isArray(arr)) return {};
  return arr.reduce((acc, current) => {
    const key = String(current[keyField]);
    acc[key] = current;
    return acc;
  }, {} as Record<string, T>);
};

/**
 * Convert an object to an array of objects, adding the object key as a property
 */
export const objectToArray = <T extends Record<string, any>>(objArr: Record<string, T>, keyObj: string = 'id'): (T & { [key: string]: string })[] => {
  if (!objArr || typeof objArr !== 'object') return [];
  return Object.keys(objArr).map(key => ({
    ...objArr[key],
    [keyObj]: key
  }));
};
