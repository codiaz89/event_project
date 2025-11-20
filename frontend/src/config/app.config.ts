import { registerAs } from '@nestjs/config';

export interface ApiConfig {
  baseUrl: string;
  username: string;
  password: string;
}

export default registerAs<ApiConfig>('api', () => ({
  baseUrl: process.env.API_BASE_URL ?? 'http://localhost:8080',
  username: process.env.API_USERNAME ?? 'admin',
  password: process.env.API_PASSWORD ?? 'admin123',
}));

