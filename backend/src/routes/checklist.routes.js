import express from "express";
import authenticator from "../app/middlewares/auth.middleware.js";
import {
  ListChecklistController,
  GetChecklistController,
  CreateChecklistController,
  UpdateChecklistController,
  DeleteChecklistController,
} from "../app/controllers/ChecklistApi/ChecklistController.js";

const router = express.Router();

router.get("/", authenticator, ListChecklistController);
router.get("/:id", authenticator, GetChecklistController);
router.post("/", authenticator, CreateChecklistController);
router.put("/:id", authenticator, UpdateChecklistController);
router.delete("/:id", authenticator, DeleteChecklistController);

export default router;
