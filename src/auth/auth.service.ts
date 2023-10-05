import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entitiy';
import { Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private readonly userRepository: Repository<User>,
  ) {}

  async signUp(createUserDto: CreateUserDto): Promise<User> {
    const { username, password, status } = createUserDto;
    const salt = await bcrypt.genSalt();
    const hashPassword = await bcrypt.hash(password, salt);
    const user = this.userRepository.create({
      username,
      password: hashPassword,
      status,
    });
    await this.userRepository.save(user);
    return user;
  }
}
