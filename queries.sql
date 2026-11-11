-- ==============================================
-- Comparador de Ofertas (SQL)
-- Ajudar a achar o melhor preço e desconto real
-- de cada produto. Dados FICTICIOS.
-- ==============================================

DROP VIEW IF EXISTS vw_ofertas;
DROP VIEW IF EXISTS vw_melhores_ofertas;
DROP TABLE IF EXISTS precos;
DROP TABLE IF EXISTS  produtos;
DROP TABLE IF EXISTS  lojas;

CREATE TABLE lojas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL
);

CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  categoria VARCHAR(40) NOT NULL
);

CREATE TABLE precos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  loja_id INT NOT NULL,
  preco_original DECIMAL(10,2) NOT NULL,
  preco_black_friday DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (produto_id) REFERENCES produtos(id),
  FOREIGN KEY (loja_id) REFERENCES lojas(id)
);

INSERT INTO lojas (nome) VALUES
('TechMais'), ('CasaFacil'), ('SuperPreco');

INSERT INTO produtos (nome, categoria) VALUES
('Smartphone 128GB', 'Eletronicos'),
('Notebook 15 polegadas', 'Informatica'),
('Fone Bluetooth', 'Eletronicos'),
('Smart TV 43 polegadas', 'Eletronicos'),
('Air Fryer 4L', 'Casa'),
('Cadeira Gamer', 'Moveis'),
('Mouse Gamer', 'Informatica'),
('Monitor 27 polegadas', 'Informatica'),
('Tablet 10 polegadas', 'Eletronicos'),
('Cafeteira Expresso', 'Casa'),
('Aspirador de Po', 'Casa');

INSERT INTO precos (produto_id, loja_id, preco_original, preco_black_friday) VALUES
(1, 1, 1800.00, 1499.00), (1, 2, 1850.00, 1599.00),(1, 3, 1790.00, 1649.00),
(2, 1, 3500.00, 2999.00),(2, 2, 3400.00, 3199.00),(2, 3, 3600.00, 2899.00),
(3, 1, 250.00, 179.00), (3, 2, 240.00, 199.00),   (3, 3, 260.00, 189.00),
(4, 1, 2200.00, 1799.00),(4, 2, 2300.00, 1699.00),(4, 3, 2100.00, 1899.00),
(5, 1, 450.00, 329.00), (5, 2, 420.00, 349.00),   (5, 3, 480.00, 339.00),
(6, 1, 1100.00, 899.00), (6, 2, 1200.00, 849.00), (6, 3, 1000.00, 879.00),
(7, 1, 180.00, 129.00), (7, 2, 170.00, 139.00), (7, 3, 190.00, 149.00),
(8, 1, 1500.00, 1199.00), (8, 2, 1450.00, 1249.00), (8, 3, 1600.00, 1149.00),
(9, 1, 2200.00, 1899.00), (9, 2, 2100.00, 1799.00), (9, 3, 2300.00, 1999.00),
(10, 1, 650.00, 499.00), (10, 2, 700.00, 529.00), (10, 3, 620.00, 479.00),
(11, 1, 800.00, 649.00), (11, 2, 750.00, 599.00), (11, 3, 850.00, 679.00);

-- VIEWS Todas as ofertas, com o percentual de desconto ja calculado
CREATE VIEW vw_ofertas AS
SELECT p.nome AS produto,
        p.categoria,
        l.nome AS loja,
        pr.preco_original,
        pr.preco_black_friday,
        ROUND((pr.preco_original - pr.preco_black_friday) / pr.preco_original * 100, 1) AS desconto_pct
FROM precos pr
JOIN produtos p ON p.id = pr.produto_id
JOIN lojas l ON l.id = pr.loja_id;

-- Apenas a melhor oferta (menor preco) de cada produto
CREATE VIEW vw_melhores_ofertas AS
SELECT *
FROM vw_ofertas o 
WHERE o.preco_black_friday = (
  SELECT MIN(o2.preco_black_friday)
  FROM vw_ofertas o2
  WHERE o2.produto = o.produto
);

-- Consulta A: todas as ofertas, da maior para a menor com o percentual de desconto
SELECT produto, loja, preco_original, preco_black_friday, desconto_pct
FROM vw_ofertas
ORDER BY desconto_pct DESC;

-- Consulta B: menor preço de cada produto
SELECT p.nome AS produto,
        MIN(pr.preco_black_friday) AS menor_preco
FROM precos pr
JOIN produtos p ON p.id = pr.produto_id
GROUP BY p.nome
ORDER BY p.nome;

-- Consulta C: qual loja tem esse menor preço
SELECT p.nome AS produto,
      l.nome AS loja,
      pr.preco_black_friday AS preco 
FROM precos pr
JOIN produtos p ON p.id = pr.produto_id
JOIN lojas l ON l.id = pr.loja_id
WHERE pr.preco_black_friday = (
  SELECT MIN(pr2.preco_black_friday)
  FROM precos pr2
  WHERE pr2.produto_id = pr.produto_id
)
ORDER BY p.nome;

-- Consulta D: quanto voce economiza escolhendo a loja certa 
SELECT produto,
        MIN(preco_black_friday) AS menor_preco,
        MAX(preco_black_friday) AS maior_preco,
        MAX(preco_black_friday) - MIN(preco_black_friday) AS economia 
FROM vw_ofertas
GROUP BY produto
ORDER BY economia DESC;
  
-- Consulta E: melhores ofertas de uma categoria
SELECT produto, loja, preco_black_friday, desconto_pct
FROM vw_melhores_ofertas
WHERE categoria = 'Eletronicos'
ORDER BY preco_black_friday;

-- Consulta F: desconto medio por loja
SELECT loja, ROUND(AVG(desconto_pct), 1) AS desconto_medio_pct
FROM vw_ofertas
GROUP BY loja
ORDER BY desconto_medio_pct DESC;


-- Banco: MySQL 8.x 

