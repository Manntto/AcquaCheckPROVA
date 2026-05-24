import app from "./src/app.js";
import sequelize from "./src/database/sequelize.js";
import initRelations from "./src/database/relations.js";
import { config } from "./src/config/constants.js";

const start = async () => {
  try {
    await sequelize.authenticate();
    console.log("Banco conectado.");

    initRelations();

    app.listen(config.server.port, () => {
      console.log(`Servidor rodando na porta ${config.server.port}`);
    });
  } catch (error) {
    console.error("Falha ao conectar no banco:", error);
    process.exit(1);
  }
};

start();