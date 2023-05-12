
--- Inserir alguns dados fictícios na tabela item
INSERT INTO Item (name, description, price, start_date, end_date, state, category_id, created_at)
VALUES ('LG70Nano', 'Ultima Geracao Nano', 2000.00, '2020-01-15', '2020-02-15', 'Ativo', 1, '2020-01-20');
INSERT INTO Item (name, description, price, start_date, end_date, state, category_id, created_at)
VALUES ('MacBookAir', 'Ultima Geracao M2', 9000.00, '2020-01-01', '2020-02-15', 'Ativo', 1, '2020-01-20');


select * from item


SELECT id, customer, email, first_name, last_name, gender, address, birthdate, DATE(created_at) as created_at
FROM customer;


SELECT id, customer_id, item_id, quantity, price, DATE(created_at) as created_at
FROM orders;

----- união das tabelas customer, item e orders

SELECT c.id as customer_id, c.first_name, c.last_name, c.email, c.gender, c.address, c.birthdate,
       i.id as item_id, i.name as item_name, i.description as item_description, i.price as item_price,
       o.quantity, o.price as order_price, o.created_at as order_created_at
FROM customer c
JOIN orders o ON c.id = o.customer_id
JOIN item i ON o.item_id = i.id;

---Listar os usuários que fazem aniversário no dia de hoje e que a quantidade de vendas realizadas em Janeiro/2020 sejam superiores a 1500

SELECT c.id as customer_id, c.first_name, c.last_name, c.email, c.gender, c.address, c.birthdate,
       i.id as item_id, i.name as item_name, i.description as item_description, i.price as item_price,
       o.quantity, o.price as order_price, DATE(o.created_at) as order_created_at
FROM customer c
JOIN orders o ON c.id = o.customer_id
JOIN item i ON o.item_id = i.id
WHERE DATE(o.created_at) BETWEEN '2020-01-01' AND '2020-01-31'
AND o.price * o.quantity > 1500;


----Para cada mês de 2020, solicitamos que seja exibido um top 5 dos usuários que mais venderam ($) na categoria Celulares. Solicitamos o mês e ano da análise, nome e sobrenome do vendedor, quantidade de vendas realizadas, quantidade de produtos vendidos e o total vendido;

SELECT DATE_PART('month', o.created_at) as month, 
       DATE_PART('year', o.created_at) as year, 
       c.first_name, 
       c.last_name, 
       COUNT(o.id) as sales_count, 
       SUM(o.quantity) as products_sold, 
       SUM(o.price * o.quantity) as total_sales
FROM orders o
JOIN customer c ON o.customer_id = c.id
JOIN item i ON o.item_id = i.id
JOIN category cat ON i.category_id = cat.id
WHERE cat.name = 'Celulares' AND DATE_PART('year', o.created_at) = 2020
GROUP BY month, year, c.id, c.first_name, c.last_name
ORDER BY month, year, total_sales DESC
LIMIT 5;
 
 ------Solicitamos popular uma nova tabela com o preço e estado dos itens no final do dia. Considerar que esse processo deve permitir um reprocesso. Vale ressaltar que na tabela de item, vamos ter unicamente o último estado informado pela PK definida (esse item pode ser resolvido através de uma store procedure).
 
 CREATE TABLE item_price_state (
  id SERIAL PRIMARY KEY,
  item_id INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  state VARCHAR(255) NOT NULL,
  created_at DATE DEFAULT CURRENT_DATE
);

--- Inserir dados na nova tabela item_price_state 

INSERT INTO item_price_state (item_id, price, state, created_at) VALUES
(1, 50.00, 'SP', '2022-05-11'),
(2, 100.00, 'RJ', '2022-05-11'),
(3, 75.00, 'MG', '2022-05-11'),
(4, 120.00, 'RS', '2022-05-11'),
(5, 90.00, 'SC', '2022-05-11');
CREATE OR REPLACE PROCEDURE insert_item_price_state() 
AS $$
BEGIN
  INSERT INTO item_price_state (item_id, price, state)
    SELECT i.id, i.price, i.state
    FROM item i
    WHERE i.created_at <= CURRENT_DATE AND NOT EXISTS (
      SELECT 1 FROM item_price_state ips WHERE ips.item_id = i.id AND ips.created_at >= CURRENT_DATE
    );
END;
$$ LANGUAGE plpgsql;



select * from item_price_state





 
 
 


