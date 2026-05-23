CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  attraction_id INTEGER REFERENCES attractions(id),
  question VARCHAR(100)
);


INSERT INTO questions (attraction_id, question) VALUES 
(1, 'O sensor de fluxo de água está funcionando corretamente?'),
(1, 'As juntas do tobogã estão lisas e sem frestas?'),
(2, 'O gerador de ondas está operando sem ruídos anormais?'),
(2, 'Os botões de parada de emergência estão acessíveis e funcionando?');