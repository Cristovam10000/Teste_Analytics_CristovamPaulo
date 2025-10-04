/* ------------------------------------------------------------
   Consulta 1
   Objetivo: Listar Produto, Categoria e soma total de vendas
             (Quantidade * Preco) por produto, ordenado desc.
   Logica:
     - Multiplicamos Quantidade por Preco (ou Preco_centavos/100).
     - Agrupamos por Produto e Categoria.
     - Ordenamos pelo total de vendas em ordem decrescente.
-------------------------------------------------------------*/

SELECT Produto, Categoria, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
FROM vendas
GROUP BY Produto, Categoria
ORDER BY total_vendas DESC;

/* ------------------------------------------------------------
   Consulta 2
   Objetivo: Listar os 5 produtos que menos venderam em
             junho de 2023.
   Logica:
     - Filtramos as linhas cuja Data esta em [2023-06-01, 2023-07-01).
     - Agregamos o total por Produto.
     - Selecionamos os 5 menores totais e exibimos em ordem desc.
-------------------------------------------------------------*/

WITH junho AS (
    SELECT Produto, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
    FROM vendas
    WHERE Data >= '2023-06-01' AND Data < '2023-07-01'
    GROUP BY Produto
), menos_vendidos AS (
    SELECT Produto, total_vendas
    FROM junho
    ORDER BY total_vendas ASC, Produto ASC
    LIMIT 5
)

SELECT Produto, total_vendas
FROM menos_vendidos
ORDER BY total_vendas DESC, Produto ASC;
