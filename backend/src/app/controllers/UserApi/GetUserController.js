import User from "../../model/User.js";
import { messages } from "../../../config/constants.js";

export default async function GetUserController(req, res) {
  try {
    const user = await User.findByPk(req.params.id, { attributes: ["id", "name", "email", "role"] });
    if (!user) return res.status(404).json({ message: "Usuário não encontrado" });
    return res.json(user);
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
