import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { lastValueFrom } from 'rxjs';
import { TicketResponseDto } from './dto/ticket-response.dto';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketDto } from './dto/update-ticket.dto';
import { TicketQueryDto } from './dto/ticket-query.dto';
import { mapAxiosError } from '../common/utils/http-error.util';

interface PaginatedTicketResponse {
  content: TicketResponseDto[];
  totalElements: number;
  totalPages: number;
  number: number;
  size: number;
}

@Injectable()
export class TicketsService {
  private readonly basePath = '/api/tickets';

  constructor(private readonly httpService: HttpService) {}

  async createTicket(payload: CreateTicketDto): Promise<TicketResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.post<TicketResponseDto>(this.basePath, payload));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async updateTicket(ticketId: string, payload: UpdateTicketDto): Promise<TicketResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.put<TicketResponseDto>(`${this.basePath}/${ticketId}`, payload));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async getTicketById(ticketId: string): Promise<TicketResponseDto> {
    try {
      const response = await lastValueFrom(this.httpService.get<TicketResponseDto>(`${this.basePath}/${ticketId}`));
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async getTickets(query: TicketQueryDto): Promise<PaginatedTicketResponse> {
    try {
      const response = await lastValueFrom(
        this.httpService.get<PaginatedTicketResponse>(this.basePath, {
          params: query,
        }),
      );
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }

  async getTicketsByUser(userId: string): Promise<TicketResponseDto[]> {
    try {
      const response = await lastValueFrom(
        this.httpService.get<TicketResponseDto[]>(`${this.basePath}/user/${userId}`),
      );
      return response.data;
    } catch (error) {
      mapAxiosError(error);
    }
  }
}

