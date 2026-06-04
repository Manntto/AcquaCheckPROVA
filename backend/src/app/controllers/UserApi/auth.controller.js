import User from "../../model/User.js"
import { messages, config } from "../../../config/constants.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import "dotenv/config";

export default async function login(req, res) {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });

    if (!user) {
      return res.status(401).json({ message: messages.auth.error.userNotFound });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ message: messages.auth.error.invalidPassword });
    }

    const token = jwt.sign(
      { id: user.id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: config.jwt.expiresIn }
    );

    return res.json({ token });
  } catch {
    return res.status(500).json({ message: messages.common.error.serverError });
  }
}
