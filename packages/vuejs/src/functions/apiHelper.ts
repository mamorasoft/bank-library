import axios, { AxiosResponse, Method } from 'axios';

/**
 * Wrapper HTTP request menggunakan Axios.
 * Mendukung GET, POST, PUT, DELETE, PATCH dengan deteksi otomatis untuk upload file.
 *
 * @param method HTTP Method (GET, POST, PUT, DELETE, dll)
 * @param url Endpoint URL target
 * @param data Request body payload (untuk POST, PUT, PATCH)
 * @param params Query parameters (biasanya untuk GET)
 * @returns Promise berisi AxiosResponse
 */
export async function callApi(
  method: string,
  url: string,
  data: any = null,
  params: any = null
): Promise<AxiosResponse> {
  const token = typeof window !== 'undefined' ? localStorage.getItem('auth_key') : null;

  let body = data;
  let isFile = false;

  // Deteksi otomatis apakah ada File/Blob dalam data
  if (data && typeof data === 'object') {
    for (const key of Object.keys(data)) {
      if (
        (typeof File !== 'undefined' && data[key] instanceof File) ||
        (typeof Blob !== 'undefined' && data[key] instanceof Blob)
      ) {
        isFile = true;
        break;
      }
    }
  }

  // Jika ada file, konversi ke FormData
  if (isFile && data && typeof data === 'object') {
    const formData = new FormData();
    for (const [key, value] of Object.entries(data)) {
      if (value instanceof File || value instanceof Blob) {
        formData.append(key, value);
      } else if (value !== null && value !== undefined) {
        // Append value lainnya sebagai string
        formData.append(key, typeof value === 'object' ? JSON.stringify(value) : String(value));
      }
    }
    body = formData;
  }

  const config: any = {
    method: method.toLowerCase() as Method,
    url,
    headers: {
      ...(isFile ? {} : { 'Content-Type': 'application/json' }),
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    ...(body ? { data: body } : {}),
    ...(params ? { params } : {}),
  };

  return await axios(config);
}
