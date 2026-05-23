import express from "express";
import cors from "cors";
import "./database/sequelize.js";

import { config } from "./config/constants.js";

const app = express();
const port = 3000;

app.use(
  cors({ origin: config.server.corsOrigin, }),
);

app.use(express.json());

app.listen(port, () => {
  console.log("Servidor subiu");
});
