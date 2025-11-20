import { TicketStatus } from './ticket-status.enum';

export interface TicketResponseDto {
  id: string;
  description: string;
  status: TicketStatus;
  userId: string;
  userFullName: string;
  createdAt: string;
  updatedAt: string;
}

