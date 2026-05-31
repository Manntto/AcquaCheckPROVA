import express from "express";
import authenticator from "../app/middlewares/auth.middleware.js";
import {
  ListQuestionController,
  GetQuestionController,
  CreateQuestionController,
  UpdateQuestionController,
  DeleteQuestionController,
} from "../app/controllers/QuestionApi/QuestionController.js";

const router = express.Router();

router.get("/", authenticator, ListQuestionController);
router.get("/:id", authenticator, GetQuestionController);
router.post("/", authenticator, CreateQuestionController);
router.put("/:id", authenticator, UpdateQuestionController);
router.delete("/:id", authenticator, DeleteQuestionController);

export default router;
