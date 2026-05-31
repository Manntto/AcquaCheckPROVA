import Question from "../../model/Question.js";
import Attraction from "../../model/Attraction.js";
import { messages } from "../../../config/constants.js";

export async function ListQuestionController(req, res) {
  try {
    const questions = await Question.findAll({ include: [{ model: Attraction, as: "attraction", attributes: ["id", "name"] }] });
    return res.json(questions);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function GetQuestionController(req, res) {
  try {
    const question = await Question.findByPk(req.params.id, {
      include: [{ model: Attraction, as: "attraction", attributes: ["id", "name"] }],
    });
    if (!question) return res.status(404).json({ message: messages.question.error.notFound });
    return res.json(question);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function CreateQuestionController(req, res) {
  try {
    const { attractionId, question } = req.body;
    if (!question) return res.status(400).json({ message: messages.question.error.requiredText });
    if (!attractionId) return res.status(400).json({ message: "attractionId é obrigatório" });
    const created = await Question.create({ attractionId, question });
    return res.status(201).json(created);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function UpdateQuestionController(req, res) {
  try {
    const q = await Question.findByPk(req.params.id);
    if (!q) return res.status(404).json({ message: messages.question.error.notFound });
    const { attractionId, question } = req.body;
    const updates = {};
    if (attractionId !== undefined) updates.attractionId = attractionId;
    if (question !== undefined) updates.question = question;
    await q.update(updates);
    return res.json({ message: messages.question.success.updated });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function DeleteQuestionController(req, res) {
  try {
    const q = await Question.findByPk(req.params.id);
    if (!q) return res.status(404).json({ message: messages.question.error.notFound });
    await q.destroy();
    return res.json({ message: messages.question.success.deleted });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
