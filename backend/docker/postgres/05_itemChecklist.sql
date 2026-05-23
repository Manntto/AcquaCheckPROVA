CREATE TABLE checklist_items (
  id SERIAL PRIMARY KEY,
  checklist_id INTEGER REFERENCES checklists(id),
  question_id INTEGER REFERENCES questions(id),
  compliant BOOLEAN
);

INSERT INTO checklist_items (checklist_id, question_id, compliant) VALUES 
(1, 1, true),
(1, 2, true);