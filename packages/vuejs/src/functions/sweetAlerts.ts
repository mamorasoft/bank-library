// sweetalert2 import dinamis untuk SSR-safe & tidak menambah ke barrel utama.
// Tipe didefinisikan lokal agar tidak bergantung pada @types/sweetalert2.
import Swal from 'sweetalert2';

type SweetAlertIcon = 'success' | 'error' | 'warning' | 'info' | 'question';

interface SweetAlertResult {
  isConfirmed: boolean;
  isDenied: boolean;
  isDismissed: boolean;
  value?: unknown;
}

/**
 * Checks if the code is running in a browser environment.
 * Crucial for Nuxt.js SSR compatibility to avoid "window is not defined".
 */
const isClient = typeof window !== 'undefined';

export const confirmDelete = (
  title: string,
  text: string,
  icon: SweetAlertIcon = 'warning'
): Promise<SweetAlertResult> => {
  if (!isClient) return Promise.resolve({ isConfirmed: false, isDenied: false, isDismissed: true });
  return Swal.fire({
    title,
    text,
    icon,
    showCancelButton: true,
    confirmButtonColor: '#d33',
    cancelButtonColor: '#3085d6',
    confirmButtonText: 'Ya, hapus!',
    cancelButtonText: 'Batal'
  });
};

export const confirmGenerate = (
  title: string,
  text: string,
  icon: SweetAlertIcon = 'question'
): Promise<SweetAlertResult> => {
  if (!isClient) return Promise.resolve({ isConfirmed: false, isDenied: false, isDismissed: true });
  return Swal.fire({
    title,
    text,
    icon,
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Ya, generate!',
    cancelButtonText: 'Batal'
  });
};

export const messageSuccess = (
  icon: SweetAlertIcon = 'success',
  message: string
): Promise<SweetAlertResult> | void => {
  if (!isClient) return;
  return Swal.fire({
    icon,
    title: message,
    showConfirmButton: false,
    timer: 1500
  });
};

export const messageError = (
  icon: SweetAlertIcon = 'error',
  message: string
): Promise<SweetAlertResult> | void => {
  if (!isClient) return;
  const Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true,
    didOpen: (toast: HTMLElement) => {
      toast.onmouseenter = Swal.stopTimer;
      toast.onmouseleave = Swal.resumeTimer;
    }
  });
  return Toast.fire({
    icon,
    title: message
  });
};

export const dialogError = (message: string): Promise<SweetAlertResult> | void => {
  if (!isClient) return;
  return Swal.fire({
    icon: 'error',
    title: 'Oops...',
    text: message
  });
};