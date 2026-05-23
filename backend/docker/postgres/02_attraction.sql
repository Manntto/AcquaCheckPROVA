CREATE TABLE attractions (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  active BOOLEAN
);


INSERT INTO attractions (name, active) VALUES 
('Tobogã Insano', true),
('Piscina de Ondas', true),
('Rio Lento', true);