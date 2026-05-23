CREATE TABLE checklists (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  attraction_id INTEGER REFERENCES attractions(id),
  date_time TIMESTAMP,
  notes TEXT
);

INSERT INTO checklists (user_id, attraction_id, date_time, notes) VALUES 
(1, 1, NOW(), 'Inspeção matinal de rotina realizada com sucesso. Tudo pronto para abertura.');