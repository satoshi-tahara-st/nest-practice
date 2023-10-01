import { Module } from '@nestjs/common';
// import {TypeOrmModule } from '@nestjs/typeorm'
import { ItemsModule } from './items/items.module';

@Module({
  imports: [ItemsModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
