import express from "express";
import authenticator from "../app/middlewares/auth.middleware.js";
import {
  ListItemChecklistController,
  GetItemChecklistController,
  CreateItemChecklistController,
  UpdateItemChecklistController,
  DeleteItemChecklistController,
} from "../app/controllers/ItemChecklistApi/ItemChecklistController.js";

const router = express.Router();

router.get("/checklist/:checklistId", authenticator, ListItemChecklistController);
router.get("/:id", authenticator, GetItemChecklistController);
router.post("/", authenticator, CreateItemChecklistController);
router.put("/:id", authenticator, UpdateItemChecklistController);
router.delete("/:id", authenticator, DeleteItemChecklistController);

export default router;
