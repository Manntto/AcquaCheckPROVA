import jwt from "jsonwebtoken";
import "dotenv/config";
// Ajuste a rota se necessário e inclua a extensão .json
import { messages } from "../config/messages.json" assert { type: "json" }; 

const jwtSecret = process.env.JWT_SECRET;

export const authenticator = (req, res, next) => {
  // Pega o header da requisição
  const authHeader = req.headers.authorization;

  // Valida se ele existe ou se começa com 'Bearer '
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: messages.auth.noToken });
  }

  // Separa o "Bearer" do "TOKEN_AQUI" de forma segura
  const token = authHeader.split(" ")[1];

  try {
    // Verifica se o token é válido
    const decoded = jwt.verify(token, jwtSecret);
    
    // Injeta os dados decodificados (id, role, etc) em inglês para manter o padrão
    req.user = decoded; 
    
    next();
  } catch (error) {
    return res.status(401).json({ message: messages.auth.invalidToken });
  }
};