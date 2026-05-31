import "dotenv/config";
import sequelize from "./src/database/sequelize.js";
import initRelations from "./src/database/relations.js";

const [, , command] = process.argv;

async function migrate() {
  try {
    initRelations();
    await sequelize.sync({ alter: true });
    console.log("✅ Migrations executadas com sucesso.");
  } catch (err) {
    console.error("❌ Erro ao executar migrations:", err.message);
    process.exit(1);
  } finally {
    await sequelize.close();
  }
}

async function migrate_fresh() {
  try {
    initRelations();
    await sequelize.sync({ force: true });
    console.log("✅ Banco recriado com sucesso (force).");
  } catch (err) {
    console.error("❌ Erro ao recriar banco:", err.message);
    process.exit(1);
  } finally {
    await sequelize.close();
  }
}

switch (command) {
  case "migrate":
    await migrate();
    break;
  case "migrate:fresh":
    await migrate_fresh();
    break;
  default:
    console.log("Comandos disponíveis:");
    console.log("  node command.js migrate        — sincroniza tabelas (alter)");
    console.log("  node command.js migrate:fresh  — recria todas as tabelas (force)");
    process.exit(0);
}
