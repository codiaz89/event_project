import { Global, Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';

@Global()
@Module({
  imports: [
    HttpModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => {
        const username = config.get<string>('api.username');
        const password = config.get<string>('api.password');
        const configOptions: any = {
          baseURL: config.get<string>('api.baseUrl'),
          timeout: 5000,
          headers: {
            'Content-Type': 'application/json',
          },
        };
        if (username && password) {
          configOptions.auth = {
            username,
            password,
          };
        }
        return configOptions;
      },
    }),
  ],
  exports: [HttpModule],
})
export class BackendHttpModule {}

