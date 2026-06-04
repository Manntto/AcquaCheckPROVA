import { readFileSync } from "fs";

const loadJSON = (path) => JSON.parse(readFileSync(new URL(path, import.meta.url)));

export const config = loadJSON("./config.json");
export const messages = loadJSON("./messages.json");

// Valores sensíveis ou de ambiente não ficam no config.json
config.server.corsOrigin = process.env.CORS_ORIGIN || "http://localhost:5173";
