import User from "../../model/User.js";
import { messages } from "../../../config/constants.js";

export default async function DeleteUserController(req, res) {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: "Usuário não encontrado" });
    await user.destroy();
    return res.json({ message: messages.user.success.deleted });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
