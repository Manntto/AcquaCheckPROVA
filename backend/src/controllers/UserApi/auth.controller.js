import User from "../../model/User.js"
import { messages, config} from "../../config/constants.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import "dotenv/config";

export default async function login (req, res){
  const { email, password } = req.body;
  const user = await User.findOne({
    where: { email },
  });

  if (!user) {
    return res.status(404).json({ message: messages.auth.error.userNotFound });
  }

  const validPassword = await bcrypt.compare(password, user.password);
  if (!validPassword) {
    return res.status(404).json({ message: messages.auth.error.invalidPassword });
  }

  const loggedUser = { id: user.id, role: user.role };
  const secret = process.env.JWT_SECRET;
  const token = jwt.sign(loggedUser, secret, {
    expiresIn: config.jwt.expiresIn,
  });
  return res.json({ token });
};
