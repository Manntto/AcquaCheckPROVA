import express from "express";
import cors from "cors";
import { config } from "./config/constants.js";
import { setupSwagger } from "./swagger.js";
import authRoutes from "./routes/auth.routes.js";
import userRoutes from "./routes/user.routes.js";
import attractionRoutes from "./routes/attraction.routes.js";
import questionRoutes from "./routes/question.routes.js";
import checklistRoutes from "./routes/checklist.routes.js";
import itemChecklistRoutes from "./routes/item-checklist.routes.js";

const app = express();

app.use(cors({ origin: config.server.corsOrigin }));
app.use(express.json());

setupSwagger(app);

app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/attractions", attractionRoutes);
app.use("/questions", questionRoutes);
app.use("/checklists", checklistRoutes);
app.use("/items", itemChecklistRoutes);

export default app;
