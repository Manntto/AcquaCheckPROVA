import User from "../../model/User.js";
import { messages } from "../../../config/constants.js";

export default async function ListUserController(req, res) {
  try {
    // pegando name email dos usuarios
    const users = await User.findAll({
      attributes: ["name", "email"],
    });
    //mandado como resposta
    res.json(users);
  } catch {
    res.status(500).json({ message: messages.common.error.serverError });
  }
}
