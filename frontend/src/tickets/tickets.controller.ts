import { Body, Controller, Get, Param, Post, Put, Query } from '@nestjs/common';
import { TicketsService } from './tickets.service';
import { CreateTicketDto } from './dto/create-ticket.dto';
import { UpdateTicketDto } from './dto/update-ticket.dto';
import { TicketQueryDto } from './dto/ticket-query.dto';
import { TicketResponseDto } from './dto/ticket-response.dto';

@Controller('tickets')
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Post()
  createTicket(@Body() payload: CreateTicketDto): Promise<TicketResponseDto> {
    return this.ticketsService.createTicket(payload);
  }

  @Put(':ticketId')
  updateTicket(
    @Param('ticketId') ticketId: string,
    @Body() payload: UpdateTicketDto,
  ): Promise<TicketResponseDto> {
    return this.ticketsService.updateTicket(ticketId, payload);
  }

  @Get(':ticketId')
  getTicketById(@Param('ticketId') ticketId: string): Promise<TicketResponseDto> {
    return this.ticketsService.getTicketById(ticketId);
  }

  @Get()
  getTickets(@Query() query: TicketQueryDto) {
    return this.ticketsService.getTickets(query);
  }

  @Get('user/:userId')
  getTicketsByUser(@Param('userId') userId: string): Promise<TicketResponseDto[]> {
    return this.ticketsService.getTicketsByUser(userId);
  }
}

