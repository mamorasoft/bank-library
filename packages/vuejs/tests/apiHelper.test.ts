import { describe, it, expect, vi, beforeEach } from 'vitest';
import { callApi } from '../src/functions/apiHelper';
import axios from 'axios';

// Mock axios
vi.mock('axios', () => {
  return {
    default: vi.fn(),
  };
});

describe('callApi', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    if (typeof window !== 'undefined') {
      localStorage.clear();
    }
  });

  it('should make standard API calls with JSON content type', async () => {
    vi.mocked(axios).mockResolvedValueOnce({ data: { success: true } });

    const response = await callApi('POST', '/api/test', { key: 'value' });

    expect(axios).toHaveBeenCalledWith({
      method: 'post',
      url: '/api/test',
      headers: {
        'Content-Type': 'application/json',
      },
      data: { key: 'value' },
    });
    expect(response.data).toEqual({ success: true });
  });

  it('should inject Authorization token if available in localStorage', async () => {
    vi.mocked(axios).mockResolvedValueOnce({ data: { authorized: true } });
    
    // Set mock token in localStorage
    localStorage.setItem('auth_key', 'my-super-secret-token');

    await callApi('GET', '/api/user');

    expect(axios).toHaveBeenCalledWith({
      method: 'get',
      url: '/api/user',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer my-super-secret-token',
      },
    });
  });

  it('should convert data to FormData if File or Blob is detected', async () => {
    vi.mocked(axios).mockResolvedValueOnce({ data: { uploaded: true } });

    // Mock File and Blob (available in jsdom environment)
    const mockFile = new File(['hello'], 'hello.txt', { type: 'text/plain' });

    await callApi('POST', '/api/upload', {
      name: 'test-file',
      file: mockFile,
    });

    expect(axios).toHaveBeenCalledOnce();
    const config = vi.mocked(axios).mock.calls[0][0] as any;
    
    expect(config.method).toBe('post');
    expect(config.url).toBe('/api/upload');
    expect(config.headers['Content-Type']).toBeUndefined(); // multipart/form-data doesn't set Content-Type manually so browser handles boundary
    expect(config.data).toBeInstanceOf(FormData);
  });
});
