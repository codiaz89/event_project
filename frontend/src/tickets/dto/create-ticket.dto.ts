import { IsEnum, IsNotEmpty, IsOptional, IsUUID, MaxLength } from 'class-validator';
import { TicketStatus } from './ticket-status.enum';

export class CreateTicketDto {
  @IsNotEmpty()
  @MaxLength(500)
  description!: string;

  @IsUUID()
  userId!: string;

  @IsOptional()
  @IsEnum(TicketStatus)
  status?: TicketStatus;
}

