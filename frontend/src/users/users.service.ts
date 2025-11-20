import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { lastValueFrom } from 'rxjs';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';
import { mapAxiosError } from '../common/utils/http-error.util';

@Injectable()
export class UsersService {
  private readonly basePath = '/api/users';

  constructor(private readonly httpService: HttpService) {}

  async createUser(payload: CreateUserDto): Promise<UserResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.post<UserResponseDto>(this.basePath, payload));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async updateUser(userId: string, payload: UpdateUserDto): Promise<UserResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.put<UserResponseDto>(`${this.basePath}/${userId}`, payload));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async getUsers(): Promise<UserResponseDto[]> {
    try {
      const response = await lastValueFrom(this.httpService.get<UserResponseDto[]>(this.basePath));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async getUserById(userId: string): Promise<UserResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.get<UserResponseDto>(`${this.basePath}/${userId}`));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }
}

