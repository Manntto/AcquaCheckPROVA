import { DataTypes } from "sequelize";
import sequelize from "../database/sequelize.js";

const Attraction = sequelize.define(
  "Attraction",
  {
    id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
    },
    active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
    },
  },
  {
    tableName: "attractions",
    timestamps: false,
  },
);

export default Attraction;
