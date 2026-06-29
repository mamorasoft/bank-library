/**
 * Tailwind responsive breakpoints (default, in ascending order).
 * Used by `responsiveColsTailwind` to emit `sm:` / `md:` / ... prefix classes.
 */
const BREAKPOINTS = ['sm', 'md', 'lg', 'xl', '2xl'] as const;

/**
 * Global install options consumed by `app.use(BankLibrary, options)`.
 * Currently only carries the default grid column value.
 */
export interface GridColOptions {
  /**
   * Default column value read by `getDefaultCol()`.
   */
  defaultCol?: number;
}

// Module-level holder — written by install() (see src/index.ts) and read by getDefaultCol().
// Held outside any Vue reactive system because these helpers are pure functions
// that can be called outside of components.
let __globalOptions: GridColOptions = {};

/**
 * Internal: sets the global options. Called from the plugin's `install()`.
 * Exported for test purposes only.
 */
export function _setGlobalGridOptions(options: GridColOptions): void {
  __globalOptions = { ...options };
}

/**
 * Returns the `defaultCol` value configured via `app.use(BankLibrary, { defaultCol: N })`,
 * or `undefined` if no global option has been set.
 */
export function getDefaultCol(): number | undefined {
  return __globalOptions.defaultCol;
}

/**
 * Builds a responsive Tailwind class string for `col-span-{N}` across breakpoints.
 *
 * Starts at `defaultCol` for the base (no prefix) and adds `step` columns
 * at each Tailwind breakpoint (`sm`, `md`, `lg`, `xl`, `2xl`),
 * capping at `max` — once `current` reaches `max`, iteration stops.
 *
 * @param defaultCol - Column span on the smallest viewport. Must be >= 1.
 * @param step - Increment per breakpoint. Negative or zero values are treated as 1.
 * @param max - Upper bound for column span. Must be >= `defaultCol`.
 * @returns Space-separated Tailwind classes.
 *
 * @example
 * responsiveColsTailwind(1, 2, 8)
 * // => "col-span-1 sm:col-span-2 md:col-span-4 lg:col-span-6 xl:col-span-8"
 *
 * @example
 * responsiveColsTailwind(2, 1, 6)
 * // => "col-span-2 sm:col-span-3 md:col-span-4 lg:col-span-5 xl:col-span-6"
 */
export function responsiveColsTailwind(
  defaultCol: number,
  step: number,
  max: number
): string {
  if (!Number.isInteger(defaultCol) || defaultCol < 1) {
    throw new RangeError(
      `responsiveColsTailwind: defaultCol must be an integer >= 1, received ${defaultCol}`
    );
  }
  if (!Number.isInteger(max) || max < defaultCol) {
    throw new RangeError(
      `responsiveColsTailwind: max must be an integer >= defaultCol (${defaultCol}), received ${max}`
    );
  }

  const safeStep = step > 0 ? step : 1;
  const classes: string[] = [`col-span-${defaultCol}`];

  let current = defaultCol;
  for (const bp of BREAKPOINTS) {
    if (current >= max) break;
    current = Math.min(current + safeStep, max);
    classes.push(`${bp}:col-span-${current}`);
  }

  return classes.join(' ');
}