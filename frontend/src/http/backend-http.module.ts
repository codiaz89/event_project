import { Global, Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';

@Global()
@Module({
  imports: [
    HttpModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        baseURL: config.get<string>('api.baseUrl'),
        auth: {
          username: config.get<string>('api.username'),
          password: config.get<string>('api.password'),
        },
        timeout: 5000,
        headers: {
          'Content-Type': 'application/json',
        },
      }),
    }),
  ],
  exports: [HttpModule],
})
export class BackendHttpModule {}

