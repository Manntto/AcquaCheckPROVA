import express from "express";
import authenticator from "../app/middlewares/auth.middleware.js";
import {
  ListAttractionController,
  GetAttractionController,
  CreateAttractionController,
  UpdateAttractionController,
  DeleteAttractionController,
} from "../app/controllers/AttractionApi/AttractionController.js";

const router = express.Router();

router.get("/", authenticator, ListAttractionController);
router.get("/:id", authenticator, GetAttractionController);
router.post("/", authenticator, CreateAttractionController);
router.put("/:id", authenticator, UpdateAttractionController);
router.delete("/:id", authenticator, DeleteAttractionController);

export default router;
