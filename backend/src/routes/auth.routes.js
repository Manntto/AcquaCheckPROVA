import express from "express";
import login from "../controllers/UserApi/auth.controller.js";

const router = express.Router();


router.post("/login", login);



export default router;