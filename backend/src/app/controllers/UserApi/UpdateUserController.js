import User from "../../model/User.js";
import { messages } from "../../../config/constants.js";
import bcrypt from "bcryptjs";

export default async function UpdateUserController(req, res) {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) return res.status(404).json({ message: "Usuário não encontrado" });

    const { name, email, password, role } = req.body;
    const updates = {};
    if (name) updates.name = name;
    if (email) updates.email = email;
    if (role) updates.role = role;
    if (password) updates.password = await bcrypt.hash(password, 10);

    await user.update(updates);
    return res.json({ message: messages.user.success.updated });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
