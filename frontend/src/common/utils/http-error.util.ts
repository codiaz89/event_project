import { HttpException, HttpStatus } from '@nestjs/common';
import { AxiosError } from 'axios';

export function mapAxiosError(error: unknown): never {
  const axiosError = error as AxiosError;
  if (axiosError?.response) {
    const status = axiosError.response.status ?? HttpStatus.BAD_GATEWAY;
    const message = axiosError.response.data ?? axiosError.message;
    throw new HttpException(message as string, status);
  }
  throw new HttpException('Error de comunicación con el backend', HttpStatus.BAD_GATEWAY);
}

