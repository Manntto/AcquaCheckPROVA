import express from "express";
import authenticator from "../app/middlewares/auth.middleware.js";
import ListUserController from "../app/controllers/UserApi/ListUserController.js";
import CreateUserController from "../app/controllers/UserApi/CreateUserController.js";
import GetUserController from "../app/controllers/UserApi/GetUserController.js";
import UpdateUserController from "../app/controllers/UserApi/UpdateUserController.js";
import DeleteUserController from "../app/controllers/UserApi/DeleteUserController.js";

const router = express.Router();

router.get("/", authenticator, ListUserController);
router.get("/:id", authenticator, GetUserController);
router.post("/", CreateUserController);
router.put("/:id", authenticator, UpdateUserController);
router.delete("/:id", authenticator, DeleteUserController);

export default router;
