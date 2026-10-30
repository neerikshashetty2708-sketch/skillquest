import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: { proxy: { '/api': 'https://skillquest-r8ef.onrender.com/' } } // same-origin cookies, no CORS setup
});
