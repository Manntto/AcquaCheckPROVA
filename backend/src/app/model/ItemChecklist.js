import { DataTypes } from "sequelize";
import sequelize from "../database/sequelize.js";

const ItemChecklist = sequelize.define(
  "ItemChecklist",
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    checklistId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: "checklist_id",
      references: { model: "checklists", key: "id" },
    },
    questionId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: "question_id",
      references: { model: "questions", key: "id" },
    },
    compliant: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
  },
  {
    tableName: "checklist_items",
    timestamps: false,
  },
);

export default ItemChecklist;
