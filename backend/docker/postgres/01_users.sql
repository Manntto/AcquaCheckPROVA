CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(250),
  role VARCHAR(100)
);

INSERT INTO users (name, email, password, role) VALUES 
('Maximus Ponciano', 'admin@acquacheck.com', '$2b$10$xpYCukDqWzsy9qbv5h8b4ObsthbpdkUwXHPcKPHNel1ohR8ztMncW', 'admin');