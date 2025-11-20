import { Body, Controller, Get, Param, Post, Put } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  createUser(@Body() payload: CreateUserDto): Promise<UserResponseDto> {
    return this.usersService.createUser(payload);
  }

  @Put(':userId')
  updateUser(@Param('userId') userId: string, @Body() payload: UpdateUserDto): Promise<UserResponseDto> {
    return this.usersService.updateUser(userId, payload);
  }

  @Get()
  getUsers(): Promise<UserResponseDto[]> {
    return this.usersService.getUsers();
  }

  @Get(':userId')
  getUserById(@Param('userId') userId: string): Promise<UserResponseDto> {
    return this.usersService.getUserById(userId);
  }
}

