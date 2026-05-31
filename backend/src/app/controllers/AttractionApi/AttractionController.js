import Attraction from "../../model/Attraction.js";
import { messages } from "../../../config/constants.js";

export async function ListAttractionController(req, res) {
  try {
    const attractions = await Attraction.findAll();
    return res.json(attractions);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function GetAttractionController(req, res) {
  try {
    const attraction = await Attraction.findByPk(req.params.id);
    if (!attraction) return res.status(404).json({ message: messages.attraction.error.notFound });
    return res.json(attraction);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function CreateAttractionController(req, res) {
  try {
    const { name, active } = req.body;
    if (!name) return res.status(400).json({ message: messages.attraction.error.requiredName });
    const attraction = await Attraction.create({ name, active: active ?? true });
    return res.status(201).json(attraction);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function UpdateAttractionController(req, res) {
  try {
    const attraction = await Attraction.findByPk(req.params.id);
    if (!attraction) return res.status(404).json({ message: messages.attraction.error.notFound });
    const { name, active } = req.body;
    const updates = {};
    if (name !== undefined) updates.name = name;
    if (active !== undefined) updates.active = active;
    await attraction.update(updates);
    return res.json({ message: messages.attraction.success.updated });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}

export async function DeleteAttractionController(req, res) {
  try {
    const attraction = await Attraction.findByPk(req.params.id);
    if (!attraction) return res.status(404).json({ message: messages.attraction.error.notFound });
    await attraction.destroy();
    return res.json({ message: messages.attraction.success.deleted });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
