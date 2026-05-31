import Checklist from "../../model/Checklist.js";
import User from "../../model/User.js";
import Attraction from "../../model/Attraction.js";
import ItemChecklist from "../../model/ItemChecklist.js";
import { messages } from "../../../config/constants.js";

const include = [
  { model: User, as: "user", attributes: ["id", "name"] },
  { model: Attraction, as: "attraction", attributes: ["id", "name"] },
  { model: ItemChecklist, as: "items" },
];

export async function ListChecklistController(req, res) {
  try {
    const checklists = await Checklist.findAll({ include });
    return res.json(checklists);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function GetChecklistController(req, res) {
  try {
    const checklist = await Checklist.findByPk(req.params.id, { include });
    if (!checklist) return res.status(404).json({ message: messages.checklist.error.notFound });
    return res.json(checklist);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function CreateChecklistController(req, res) {
  try {
    const { attractionId, dateTime, notes } = req.body;
    if (!attractionId) return res.status(400).json({ message: messages.checklist.error.requiredAttraction });
    const checklist = await Checklist.create({
      userId: req.user.id,
      attractionId,
      dateTime: dateTime || new Date(),
      notes,
    });
    return res.status(201).json(checklist);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function UpdateChecklistController(req, res) {
  try {
    const checklist = await Checklist.findByPk(req.params.id);
    if (!checklist) return res.status(404).json({ message: messages.checklist.error.notFound });
    const { attractionId, dateTime, notes } = req.body;
    const updates = {};
    if (attractionId !== undefined) updates.attractionId = attractionId;
    if (dateTime !== undefined) updates.dateTime = dateTime;
    if (notes !== undefined) updates.notes = notes;
    await checklist.update(updates);
    return res.json({ message: messages.checklist.success.updated });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function DeleteChecklistController(req, res) {
  try {
    const checklist = await Checklist.findByPk(req.params.id);
    if (!checklist) return res.status(404).json({ message: messages.checklist.error.notFound });
    await checklist.destroy();
    return res.json({ message: messages.checklist.success.deleted });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
