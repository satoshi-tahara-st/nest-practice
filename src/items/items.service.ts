import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { ItemStatus } from './item-status.enum';
import { Item } from '../entities/item.entity';
import { CreateItemDto } from './dto/create-item.dto';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entitiy';

@Injectable()
export class ItemsService {
  @InjectRepository(Item) private readonly itemRepository: Repository<Item>;

  async findAll(): Promise<Item[]> {
    return await this.itemRepository.find();
  }

  async findById(id: string): Promise<Item> {
    const found = await this.itemRepository.findOneBy({ id });
    if (!found) {
      throw new NotFoundException();
    }
    return found;
  }

  async create(createItemDto: CreateItemDto, user: User): Promise<Item> {
    const { name, price, description } = createItemDto;
    const item = this.itemRepository.create({
      name,
      price,
      description,
      status: ItemStatus.ON_SALE,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      user,
    });
    await this.itemRepository.save(item);
    return item;
  }

  async updateStatus(id: string, user: User): Promise<Item> {
    const item = await this.findById(id);
    if (item.userId === user.id) {
      throw new BadRequestException('自身の商品を購入することはできません');
    }
    item.status = ItemStatus.SOLD_OUT;
    item.updatedAt = new Date().toISOString();
    const updatedItem = await this.itemRepository.update(id, {
      status: item.status,
      updatedAt: item.updatedAt,
    });
    if (updatedItem.affected === 0) {
      throw new NotFoundException(`${id}のデータを更新できませんでした`);
    }
    return item;
  }

  async delete(id: string, user: User): Promise<void> {
    const item = await this.findById(id);
    if (item.userId !== user.id) {
      throw new BadRequestException('他人の商品を削除することはできません');
    }
    const response = await this.itemRepository.delete({ id });
    if (response.affected !== 1) {
      throw new NotFoundException(`${id}のデータを削除できませんでした`);
    }
  }
}
