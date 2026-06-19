export type CallApiMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE' | string;

export interface CallApiOptions {
  method?: CallApiMethod;
  url: string;
  data?: Record<string, any> | null;
  params?: Record<string, any> | null;
  headers?: Record<string, string>;
  signal?: AbortSignal;
}

export interface CallApiResponse<T = any> {
  data: T;
  status: number;
  statusText: string;
  headers: Headers;
}

export interface CallApiPromise<T = any> extends Promise<CallApiResponse<T>> {
  abort: () => void;
}

export class CallApiError<T = any> extends Error {
  constructor(
    message: string,
    public readonly status: number,
    public readonly statusText: string,
    public readonly data: T
  ) {
    super(message);
    this.name = 'CallApiError';
  }
}

function buildUrl(url: string, params: Record<string, any> | null | undefined): string {
  if (!params) return url;

  const query = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value !== null && value !== undefined) {
      query.append(key, String(value));
    }
  }

  const queryString = query.toString();
  if (!queryString) return url;

  return url.includes('?') ? `${url}&${queryString}` : `${url}?${queryString}`;
}

function containsFile(data: Record<string, any>): boolean {
  return Object.values(data).some(
    (value) =>
      (typeof File !== 'undefined' && value instanceof File) ||
      (typeof Blob !== 'undefined' && value instanceof Blob)
  );
}

function toFormData(data: Record<string, any>): FormData {
  const formData = new FormData();
  for (const [key, value] of Object.entries(data)) {
    if (value instanceof File || value instanceof Blob) {
      formData.append(key, value);
    } else if (value !== null && value !== undefined) {
      formData.append(key, typeof value === 'object' ? JSON.stringify(value) : String(value));
    }
  }
  return formData;
}

async function parseBody(response: Response): Promise<any> {
  const contentType = response.headers.get('content-type') ?? '';
  if (contentType.includes('application/json')) {
    return response.json().catch(() => null);
  }
  const text = await response.text();
  return text.length ? text : null;
}

async function executeRequest<T>(options: CallApiOptions, signal: AbortSignal): Promise<CallApiResponse<T>> {
  const { method = 'GET', url, data = null, params = null, headers = {} } = options;
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null;

  const isFile = data && typeof data === 'object' && containsFile(data);
  const body = isFile ? toFormData(data as Record<string, any>) : data !== null ? JSON.stringify(data) : null;

  const response = await fetch(buildUrl(url, params), {
    method: method.toUpperCase(),
    headers: {
      ...(isFile || body === null ? {} : { 'Content-Type': 'application/json' }),
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
    ...(body !== null ? { body } : {}),
    signal,
  });

  const responseData = (await parseBody(response)) as T;

  if (!response.ok) {
    throw new CallApiError(
      `Request failed with status ${response.status}`,
      response.status,
      response.statusText,
      responseData
    );
  }

  return {
    data: responseData,
    status: response.status,
    statusText: response.statusText,
    headers: response.headers,
  };
}

/**
 * Wrapper HTTP request menggunakan fetch bawaan browser.
 * Mendukung GET, POST, PUT, DELETE, PATCH dengan deteksi otomatis untuk upload file.
 * Mendukung pembatalan request via `abort()` pada promise yang dikembalikan, atau via `signal` sendiri.
 *
 * @param options Konfigurasi request: method, url, data, params, headers, signal
 * @returns Promise berisi CallApiResponse, dengan tambahan method `abort()`
 */
export function callApi<T = any>(options: CallApiOptions): CallApiPromise<T> {
  const controller = new AbortController();

  if (options.signal) {
    if (options.signal.aborted) {
      controller.abort();
    } else {
      options.signal.addEventListener('abort', () => controller.abort(), { once: true });
    }
  }

  const promise = executeRequest<T>(options, controller.signal) as CallApiPromise<T>;
  promise.abort = () => controller.abort();

  return promise;
}
