import { Sequelize } from 'sequelize';
import 'dotenv/config'; 

const DB_NAME = process.env.POSTGRES_DB;
const DB_USER = process.env.POSTGRES_USER;
const DB_PASS = process.env.POSTGRES_PASSWORD;

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASS, {
  host: 'localhost',
  dialect: 'postgres',
  port: 5432, 
  logging: false, 
});

const TestConexao = async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexão com sucesso.');
  } catch (error) {
    console.error('Falha ao conectar', error);
  }
};

TestConexao();

export default sequelize;