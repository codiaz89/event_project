import { IsNotEmpty, MaxLength } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  @MaxLength(120)
  firstName!: string;

  @IsNotEmpty()
  @MaxLength(120)
  lastName!: string;
}

