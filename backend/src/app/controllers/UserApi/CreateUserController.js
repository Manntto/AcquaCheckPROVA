import User from "../../model/User.js";
import { messages } from "../../../config/constants.js";
import bcrypt from "bcryptjs";

export default async function CreateUserController(req, res) {
  try {
    const { name, email, password, role } = req.body;
    const errors = [];

    if (!name) errors.push(messages.user.error.requiredName);
    if (!email) errors.push(messages.user.error.requiredEmail);
    if (!password) errors.push(messages.user.error.requiredPassword);
    if (errors.length > 0) return res.status(400).json({ errors });

    const hashed = await bcrypt.hash(password, 10);
    const user = await User.create({ name, email, password: hashed, role: role || "inspector" });

    return res.status(201).json({ id: user.id, name: user.name, email: user.email, role: user.role });
  } catch (err) {
    if (err.name === "SequelizeUniqueConstraintError")
      return res.status(409).json({ message: "E-mail já cadastrado" });
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
