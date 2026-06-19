import { describe, it, expect, vi, beforeEach } from 'vitest';
import { callApi, CallApiError } from '../src/api/apiHelper';

function mockFetchResponse(body: any, init: { status?: number; statusText?: string; contentType?: string } = {}) {
  const { status = 200, statusText = 'OK', contentType = 'application/json' } = init;
  return {
    ok: status >= 200 && status < 300,
    status,
    statusText,
    headers: new Headers({ 'content-type': contentType }),
    json: async () => body,
    text: async () => (typeof body === 'string' ? body : JSON.stringify(body)),
  } as Response;
}

describe('callApi', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    vi.stubGlobal('fetch', vi.fn());
    if (typeof window !== 'undefined') {
      localStorage.clear();
    }
  });

  it('should make standard API calls with JSON content type', async () => {
    vi.mocked(fetch).mockResolvedValueOnce(mockFetchResponse({ success: true }));

    const response = await callApi({ method: 'POST', url: '/api/test', data: { key: 'value' } });

    expect(fetch).toHaveBeenCalledWith(
      '/api/test',
      expect.objectContaining({
        method: 'POST',
        body: JSON.stringify({ key: 'value' }),
        headers: expect.objectContaining({ 'Content-Type': 'application/json' }),
      })
    );
    expect(response.data).toEqual({ success: true });
  });

  it('should default to GET and build query params', async () => {
    vi.mocked(fetch).mockResolvedValueOnce(mockFetchResponse({ users: [] }));

    await callApi({ url: '/api/users', params: { page: 1 } });

    expect(fetch).toHaveBeenCalledWith('/api/users?page=1', expect.objectContaining({ method: 'GET' }));
  });

  it('should inject Authorization token if available in localStorage', async () => {
    vi.mocked(fetch).mockResolvedValueOnce(mockFetchResponse({ authorized: true }));

    localStorage.setItem('token', 'my-super-secret-token');

    await callApi({ method: 'GET', url: '/api/user' });

    expect(fetch).toHaveBeenCalledWith(
      '/api/user',
      expect.objectContaining({
        headers: expect.objectContaining({ Authorization: 'Bearer my-super-secret-token' }),
      })
    );
  });

  it('should convert data to FormData if File or Blob is detected', async () => {
    vi.mocked(fetch).mockResolvedValueOnce(mockFetchResponse({ uploaded: true }));

    const mockFile = new File(['hello'], 'hello.txt', { type: 'text/plain' });

    await callApi({ method: 'POST', url: '/api/upload', data: { name: 'test-file', file: mockFile } });

    expect(fetch).toHaveBeenCalledOnce();
    const [, init] = vi.mocked(fetch).mock.calls[0];

    expect((init as RequestInit).method).toBe('POST');
    expect((init as RequestInit).headers).not.toHaveProperty('Content-Type');
    expect((init as RequestInit).body).toBeInstanceOf(FormData);
  });

  it('should throw CallApiError on non-ok response', async () => {
    vi.mocked(fetch).mockResolvedValueOnce(
      mockFetchResponse({ message: 'Not found' }, { status: 404, statusText: 'Not Found' })
    );

    await expect(callApi({ url: '/api/missing' })).rejects.toMatchObject({
      status: 404,
      data: { message: 'Not found' },
    });
  });

  it('should support aborting the request via the returned promise', async () => {
    vi.mocked(fetch).mockImplementationOnce(
      (_url: any, init: any) =>
        new Promise((_resolve, reject) => {
          init.signal.addEventListener('abort', () => {
            const error = new Error('Aborted');
            error.name = 'AbortError';
            reject(error);
          });
        })
    );

    const request = callApi({ url: '/api/slow' });
    request.abort();

    await expect(request).rejects.toMatchObject({ name: 'AbortError' });
  });

  it('exposes CallApiError as a class', () => {
    const error = new CallApiError('failed', 500, 'Internal Server Error', null);
    expect(error).toBeInstanceOf(Error);
    expect(error.status).toBe(500);
  });
});
