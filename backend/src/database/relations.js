import User from '../app/model/User.js';
import Attraction from '../app/model/Attraction.js';
import Question from '../app/model/Question.js';
import Checklist from '../app/model/Checklist.js';
import ItemChecklist from '../app/model/ItemChecklist.js';

export default function initRelations() {
    // 1. Attraction <-> Question (1:N)
    Attraction.hasMany(Question, { foreignKey: 'attractionId', as: 'questions' });
    Question.belongsTo(Attraction, { foreignKey: 'attractionId', as: 'attraction' });

    // 2. User <-> Checklist (1:N)
    User.hasMany(Checklist, { foreignKey: 'userId', as: 'checklists' });
    Checklist.belongsTo(User, { foreignKey: 'userId', as: 'user' });

    // 3. Attraction <-> Checklist (1:N)
    Attraction.hasMany(Checklist, { foreignKey: 'attractionId', as: 'checklists' });
    Checklist.belongsTo(Attraction, { foreignKey: 'attractionId', as: 'attraction' });

    // 4. Checklist <-> ItemChecklist (1:N)
    Checklist.hasMany(ItemChecklist, { foreignKey: 'checklistId', as: 'items' });
    ItemChecklist.belongsTo(Checklist, { foreignKey: 'checklistId', as: 'checklist' });

    // 5. Question <-> ItemChecklist (1:N)
    Question.hasMany(ItemChecklist, { foreignKey: 'questionId', as: 'items' });
    ItemChecklist.belongsTo(Question, { foreignKey: 'questionId', as: 'question' });
}