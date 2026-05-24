import User from "../../model/User.js";
import { messages } from "../../config/constants.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import "dotenv/config";

export default async function CreateUserController (req, res){
    try{
        const {name, email, passoword} = req.body;
        if (!name) {
            error.push("name obrigatório!");
        }

        if (!email) {
            error.push("email obrigatório!");
        }

        if (!password) {
            error.push("password obrigatório!");
        }

        if (error.length > 0) {
            return response.status(400).json({ error: error });
        }
    }


}