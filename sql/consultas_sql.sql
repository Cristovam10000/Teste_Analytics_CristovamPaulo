/* ------------------------------------------------------------
   Consulta 1
   Objetivo: Listar Produto, Categoria e soma total de vendas
             (Quantidade * Preco) por produto, ordenado desc.
   Lógica:
     - Multiplicamos Quantidade por Preco (ou Preco_centavos/100).
     - Agrupamos por Produto e Categoria.
     - Ordenamos pelo total de vendas em ordem decrescente.
-------------------------------------------------------------*/


SELECT Produto, Categoria, ROUND(SUM(Quantidade  * Preco), 2) AS total_vendas
FROM vendas
GROUP BY Produto, Categoria
ORDER BY total_vendas DESC;

/* ------------------------------------------------------------
   Consulta 2
   Objetivo: Identificar os produtos que venderam menos em
             junho de 2023.
   Lógica:
     - Filtramos as linhas cuja Data está em [2023-06-01, 2023-07-01).
     - Agregamos o total por Produto.
     - Selecionamos os de menor total (empate possível).
-------------------------------------------------------------*/

with junho AS (
    SELECT Produto, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
    FROM vendas
    WHERE Data >= '2023-06-01' AND Data < '2023-07-01'
    GROUP BY Produto
)

SELECT * FROM junho 
WHERE total_vendas = (SELECT MIN(total_vendas) FROM junho)
ORDER BY Produto;

/* ------------------------------------------------------------
   Observação sobre 2024
   O enunciado pede junho/2024, mas a base simulada cobre 2023.
   Caso os dados sejam estendidos até 2024-06, use o recorte abaixo:

   with junho24 AS (
       SELECT Produto, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
       FROM vendas
       WHERE Data >= '2024-06-01' AND Data < '2024-07-01'
       GROUP BY Produto
   )
   SELECT * FROM junho24
   WHERE total_vendas = (SELECT MIN(total_vendas) FROM junho24)
   ORDER BY Produto;
-------------------------------------------------------------*/
