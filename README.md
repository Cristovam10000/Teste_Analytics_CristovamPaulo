# Teste para Estagiario de Analytics - Quod

Este repositorio contem a solucao para o desafio de Estagio em Analytics da Quod. O objetivo e demonstrar a capacidade de **simular um conjunto de dados de vendas**, aplicar **tecnicas de limpeza e tratamento**, produzir **analises exploratorias com visualizacoes**, escrever **consultas SQL** e **interpretar os resultados**. O codigo foi desenvolvido em **Python 3.11** com bibliotecas populares de ciencia de dados.

---

## Visao geral das tarefas

O desafio foi dividido em tres partes com objetivos especificos.

### Programacao em Python - Simulacao, limpeza e analise de dados

**Simulacao de dados.** Gera um dataset sintetico (~300 linhas) de 01/01/2023 a 31/12/2023. Foram definidas **6 categorias** (Eletronicos, Casa & Cozinha, Esporte, Moda, Brinquedos e Material Escolar) e listas de produtos para cada uma.
- **Precos**: distribuicoes log-normais por categoria.
- **Quantidades**: distribuicao de Poisson ajustada por sazonalidade mensal.
- **Ruido proposital**: valores ausentes, datas invalidas, numeros como texto, zeros/negativos e duplicatas.
- Saida bruta: `data/raw/vendas_2023.csv`.

**Diagnostico do CSV.** A funcao `diagnosticar_csv_plus` (Etapa 01) inspeciona o arquivo bruto:
- Amostra e tipos de coluna.
- Contagem de nulos.
- Duplicatas (linha a linha e por `(ID, Data)`).
- Colunas textuais que deveriam ser numericas.
- Datas invalidas ou fora do periodo.
- Quantidades/precos nao numericos ou menores/iguais a zero.
- Exemplos de registros problematicos para orientar a limpeza.

**Limpeza de dados.** A funcao `clean_sales_csv` transforma o arquivo em dataset consistente:
- Conversao robusta de datas.
- Remocao de duplicatas exatas e IDs repetidos.
- Normalizacao de textos para `string`.
- Conversao de campos numericos com tratamento de formatos mistos.
- Substituicao de valores nao positivos por `NaN`.
- Imputacao de faltantes (mediana do produto ou mediana global).
- Agregacao de duplicados `(ID, Data)` via mediana/moda.
- Imputacao cruzada Produto <-> Categoria e descarte de registros sem informacao.
- Arredondamento final e ordenacao. Resultado: `data/processed/data_clean.csv` + relatorio de limpeza.

**Analise de vendas.** `analisar_vendas` soma o total por produto, grava `data/processed/vendas_por_produto.csv` e exibe o ranking Top-5 atual (Caixa Bluetooth, Fone Pro, Smartwatch, Mouse Optico, Bola Oficial).

---

## Analise exploratoria de dados (EDA)

`Parte01/Etapa02.ipynb` carrega `data_clean.csv`, calcula `Total = Quantidade * Preco` e gera duas figuras:
1. **Tendencia mensal** (linha) com picos em dezembro, fevereiro e janeiro.
2. **Top-5 produtos** (barras) evidenciando concentracao de receita.

A ultima celula do notebook traz os insights quantitativos atualizados.

---

## Consultas SQL

Exemplos para a Parte 2 (estrutura equivalente ao CSV limpo):

```sql
-- Total de vendas por produto e categoria (decrescente)
SELECT Produto, Categoria, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
FROM vendas
GROUP BY Produto, Categoria
ORDER BY total_vendas DESC;

-- Cinco produtos com menor faturamento em junho/2023 (SQLite)
WITH junho AS (
    SELECT Produto, ROUND(SUM(Quantidade * Preco), 2) AS total_vendas
    FROM vendas
    WHERE Data >= '2023-06-01' AND Data < '2023-07-01'
    GROUP BY Produto
)
SELECT Produto, total_vendas
FROM junho
ORDER BY total_vendas ASC, Produto ASC
LIMIT 5;
```

Adapte a sintaxe de data conforme o SGBD utilizado.

---

## Relatorio de insights

- **Volume total**: R$ 187.183,68 (291 registros limpos).
- **Picos sazonais**: dezembro, fevereiro e janeiro somam ~R$ 66,3 mil (35% da receita anual).
- **Dependencia de poucos produtos**: Caixa Bluetooth gera R$ 25,1 mil; Top-5 concentram 40,5% da receita.
- **Categorias de maior peso**: Eletronicos (R$ 74,7 mil, 40% do total), Casa & Cozinha (R$ 29,3 mil), Esporte (R$ 28,5 mil), Brinquedos (R$ 23,8 mil) e Material Escolar (R$ 11,4 mil).
- **Meses de baixa**: junho (R$ 9,0 mil) e marco (R$ 9,7 mil) ficam abaixo de R$ 10 mil, sugerindo campanhas de estimulo.

---

## Estrutura do repositorio

```text
Teste_Analytics_CristovamPaulo/
+-- Parte01/
¦   +-- Etapa01.ipynb              # Geracao, diagnostico, limpeza e analise de vendas
¦   +-- Etapa02.ipynb              # EDA e visualizacoes
+-- data/
¦   +-- raw/
¦   ¦   +-- vendas_2023.csv        # Dataset bruto com sujeiras
¦   +-- processed/
¦       +-- data_clean.csv         # Dataset limpo
¦       +-- vendas_por_produto.csv # Totais por produto
+-- reports/
¦   +-- figures/
¦       +-- tendencia_mensal.png
¦       +-- top5_produtos.png
+-- sql/
¦   +-- consultas_sql.sql
+-- src/
¦   +-- to_sqlite.py               # Script opcional para carregar o CSV no SQLite
+-- relatorio_insights.md          # Relatorio textual com insights
```

> Observacao: pastas adicionais (por exemplo `presentation/`) podem ser adicionadas conforme o material de entrega.

---

## Como executar os scripts

### Preparacao do ambiente

Crie um ambiente virtual (`python -m venv .venv`) e instale:

```bash
pip install pandas numpy faker matplotlib ipython notebook
```

### Etapa 01 - Simulacao e limpeza

Execute `Parte01/Etapa01.ipynb` sequencialmente. Arquivos gerados:
- `data/raw/vendas_2023.csv`
- `data/processed/data_clean.csv`
- `data/processed/vendas_por_produto.csv`

O notebook imprime um resumo da limpeza (linhas descartadas, imputacoes etc.).

### Etapa 02 - EDA

Com `data_clean.csv` pronto, execute `Parte01/Etapa02.ipynb`. As figuras sao salvas em `reports/figures` e os insights atualizados aparecem ao final.

### Consultas SQL e relatorio

Abra `sql/consultas_sql.sql` no SGBD preferido (ex.: SQLite). Use `src/to_sqlite.py` para recriar a tabela `vendas` em `vendas.db` se desejar. O arquivo `relatorio_insights.md` resume os principais achados.

---

## Assuncoes e consideracoes

- O dataset cobre apenas 2023. Para responder consultas de junho/2024, defina `EXTENDER_ATE_2024_06 = True` em `Etapa01.ipynb` e regenere os artefatos.
- Dados sao 100% sinteticos; valores podem ser ajustados conforme novas iteracoes.
- Visualizacoes usam `matplotlib`, mas outras bibliotecas podem ser integradas sem alterar o pipeline.
- O codigo foi escrito com foco em clareza e reutilizacao (funcoes, comentarios pontuais e parametrizacao).

---

## Conclusao

O repositorio cobre o ciclo completo de analytics do desafio: simulacao, limpeza, EDA, SQL e relato de insights. Seguindo as instrucoes acima e possivel reproduzir os resultados, avaliar a organizacao do codigo e compreender as decisoes tecnicas tomadas.

---
