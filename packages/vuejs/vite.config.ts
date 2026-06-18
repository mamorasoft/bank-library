/// <reference types="vitest" />
import { defineConfig } from 'vite';
import { resolve } from 'path';
import vue from '@vitejs/plugin-vue';
import dts from 'vite-plugin-dts';

export default defineConfig({
  build: {
    lib: {
      entry: {
        index: resolve(__dirname, 'src/index.ts'),
        functions: resolve(__dirname, 'src/functions/index.ts'),
        ui: resolve(__dirname, 'src/ui/index.ts'),
        api: resolve(__dirname, 'src/api/index.ts')
      },
      formats: ['es', 'cjs'],
      fileName: (format, entryName) => `${entryName}.${format === 'es' ? 'js' : 'cjs'}`
    },
    rollupOptions: {
      external: ['vue', 'axios'],
      output: {
        exports: 'named'
      }
    }
  },
  plugins: [
    vue(),
    dts({
      cleanVueFileName: true
    })
  ],
  test: {
    environment: 'jsdom'
  }
});
