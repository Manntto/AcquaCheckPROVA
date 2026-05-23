import express from "express";
import cors from "cors";
import sequelize from "./database/sequelize.js";
import initRelations from "./database/relations.js";
import { config } from "./config/constants.js";

import authRoutes from "./routes/auth.routes.js";

const app = express();
const port = 3000;

app.use(cors({ origin: config.server.corsOrigin }));
app.use(express.json());
app.use(config.api.prefixAuth, authRoutes);

initRelations();
sequelize.authenticate()

app.listen(port, () => {
  console.log("Servidor subiu");
});