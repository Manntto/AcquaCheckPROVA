import ItemChecklist from "../../model/ItemChecklist.js";
import Question from "../../model/Question.js";
import { messages } from "../../../config/constants.js";

export async function ListItemChecklistController(req, res) {
  try {
    const items = await ItemChecklist.findAll({
      where: { checklistId: req.params.checklistId },
      include: [{ model: Question, as: "question", attributes: ["id", "question"] }],
    });
    return res.json(items);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function GetItemChecklistController(req, res) {
  try {
    const item = await ItemChecklist.findByPk(req.params.id, {
      include: [{ model: Question, as: "question", attributes: ["id", "question"] }],
    });
    if (!item) return res.status(404).json({ message: "Item não encontrado" });
    return res.json(item);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function CreateItemChecklistController(req, res) {
  try {
    const { checklistId, questionId, compliant } = req.body;
    if (checklistId === undefined || questionId === undefined || compliant === undefined)
      return res.status(400).json({ message: "checklistId, questionId e compliant são obrigatórios" });
    const item = await ItemChecklist.create({ checklistId, questionId, compliant });
    return res.status(201).json(item);
  } catch (err) {
    if (err.name === "SequelizeUniqueConstraintError")
      return res.status(409).json({ message: "Item já existe neste checklist para esta pergunta" });
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function UpdateItemChecklistController(req, res) {
  try {
    const item = await ItemChecklist.findByPk(req.params.id);
    if (!item) return res.status(404).json({ message: "Item não encontrado" });
    const { compliant } = req.body;
    if (compliant !== undefined) await item.update({ compliant });
    return res.json({ message: "Item atualizado com sucesso" });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function DeleteItemChecklistController(req, res) {
  try {
    const item = await ItemChecklist.findByPk(req.params.id);
    if (!item) return res.status(404).json({ message: "Item não encontrado" });
    await item.destroy();
    return res.json({ message: "Item excluído com sucesso" });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
