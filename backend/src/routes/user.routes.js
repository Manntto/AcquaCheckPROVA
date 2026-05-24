import express from "express";
import ListUserController from "../controllers/UserApi/ListUserController.js";
import authenticator from "../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/",authenticator, ListUserController);

export default router;