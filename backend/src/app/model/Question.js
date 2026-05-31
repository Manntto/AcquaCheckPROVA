import { DataTypes } from "sequelize";
import sequelize from "../../database/sequelize.js";

const Question = sequelize.define(
  "Question",
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    attractionId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: "attraction_id",
      references: { model: "attractions", key: "id" },
    },
    question: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
  },
  {
    tableName: "questions",
    timestamps: false,
  },
);

export default Question;
