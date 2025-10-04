# Teste para Estagiário de Analytics – Quod

Este repositório contém a solução para o desafio de Estágio em Analytics da Quod. O objetivo é mostrar a capacidade de **simular um conjunto de dados de vendas**, aplicar **técnicas de limpeza e tratamento de dados**, realizar **análises exploratórias com visualizações**, escrever **consultas SQL** e **interpretar os resultados obtidos**. O código foi desenvolvido em **Python 3.11** utilizando bibliotecas de ciência de dados amplamente conhecidas.

---

## Visão geral das tarefas

O desafio foi dividido em três partes, cada uma com objetivos específicos.

### Programação em Python – Simulação, limpeza e análise de dados

**Simulação de dados.** Geração de um dataset sintético de vendas com ~300 linhas (mínimo de 50 registros) entre **01/01/2023** e **31/12/2023**. Foram definidas **6 categorias de produtos** (Eletrônicos, Casa & Cozinha, Esporte, Moda, Brinquedos e Material Escolar) e, para cada categoria, uma lista de produtos.  
- **Preços**: gerados a partir de distribuições **log-normais** específicas por categoria.  
- **Quantidade**: segue uma **distribuição de Poisson** ajustada por **sazonalidade mensal**.  
- **Sujeiras propositalmente adicionadas** ao CSV: campos ausentes, datas inválidas, quantidades como string ou iguais a zero/negativas e duplicatas.  
- O arquivo bruto é salvo em `data/raw/vendas_2023.csv`.

**Diagnóstico do CSV.** A função `diagnosticar_csv_plus` (Etapa 01) faz uma varredura detalhada do arquivo bruto:  
- Amostra e **tipos das colunas**.  
- **Contagem de valores ausentes**.  
- **Duplicatas** (linha a linha e por chaves `(ID, Data)`).  
- **Colunas `object`** que deveriam ser numéricas.  
- **Datas inválidas**.  
- **Quantidades ou preços** não numéricos/negativos.  
- **Exemplos de linhas problemáticas** para orientar a limpeza.

**Limpeza de dados.** A função `clean_sales_csv` transforma o arquivo bruto em um dataset consistente. Entre as etapas:  
- Conversão de datas com `pd.to_datetime` (tratamento de erros).  
- Remoção de **duplicatas exatas** e de **IDs repetidos**.  
- Normalização de textos para `string`.  
- Conversão de **preços** e **quantidades** para numéricos.  
- Substituição de valores **não positivos por `NaN`**.  
- **Imputação** de valores ausentes (mediana do produto ou **mediana global**).  
- **Agregação** de linhas duplicadas por `(ID, Data)` com **mediana/moda**.  
- **Imputação cruzada** de `Produto ↔ Categoria`.  
- **Descarte** de registros sem **produto** ou **categoria**.  
- **Arredondamento** de preços e quantidades e **ordenação final**.  
- Resultado em `data/processed/data_clean.csv` e **relatório** com contagens de linhas descartadas/imputadas.

**Análise de vendas.** A função `analisar_vendas` carrega o conjunto limpo, calcula o **total de vendas** (`Quantidade * Preco`) por linha e soma **por produto**.  
- Gera `data/processed/vendas_por_produto.csv` (totais por produto com 2 casas).  
- Imprime o **Top-5 atual**: Caixa Bluetooth, Mouse Óptico, Camiseta Básica, Fone Pro e Smartwatch.

---

## Análise Exploratória de Dados (EDA)

O notebook `Parte01/Etapa02.ipynb` carrega o conjunto limpo (`data/processed/data_clean.csv`), converte a coluna `Data` para `datetime` e cria a coluna `Total`. Com **matplotlib**, são geradas duas visualizações principais:

1. **Tendência de vendas mensais.** Agrupamento por `Data.dt.to_period("M")` e gráfico de linhas mostrando a variação do faturamento em 2023. Observa-se **sazonalidade forte** com picos em fevereiro, agosto e dezembro.  
2. **Top‑5 produtos.** Gráfico de barras com os cinco produtos de maior venda absoluta. Evidencia-se **efeito de longa cauda**: poucos produtos concentram a maior parte da receita; os demais representam fração menor.

O notebook também imprime **insights preliminares** em texto: (i) existência de sazonalidade ao longo do ano; (ii) concentração de vendas em poucos produtos.

---

## Consultas SQL

Embora não estejam presentes no repositório original, o desafio pede a escrita de consultas SQL para trabalhar com a base limpa. Abaixo, exemplos que atendem aos requisitos propostos.  
As consultas assumem uma tabela chamada `vendas` com colunas `ID`, `Data`, `Produto`, `Categoria`, `Quantidade` e `Preco` (estrutura idêntica a `data_clean.csv`). A segunda consulta usa `strftime` do **SQLite**; ajuste conforme o SGBD.

### (a) Soma total de vendas por produto e categoria (ordem decrescente)
```sql
SELECT
  Produto,
  Categoria,
  SUM(Quantidade * Preco) AS total_vendas
FROM vendas
GROUP BY Produto, Categoria
ORDER BY total_vendas DESC;
```

### (b) Produtos que venderam menos no mês de junho de 2024 (exemplo se dataset for estendido)
```sql
SELECT
  Produto,
  SUM(Quantidade) AS quantidade_total
FROM vendas
WHERE strftime('%Y-%m', Data) = '2024-06'
GROUP BY Produto
ORDER BY quantidade_total ASC;
```

---

## Relatório de insights

- **Volume total de vendas**: R$ 176.811,77 (dados limpos, 291 registros).
- **Picos sazonais**: fevereiro, agosto e dezembro somam cerca de R$ 67,1 mil (38% do faturamento anual).
- **Dependência de poucos produtos**:
  - Caixa Bluetooth: R$ 22,7 mil.
  - Top-5 itens respondem por 38,8% da receita total.
- **Categorias de maior peso**: Eletrônicos (R$ 61,4 mil), Casa & Cozinha (R$ 33,1 mil) e Esporte (R$ 25,8 mil).
- **Meses de baixa**: abril e maio ficam abaixo de R$ 10 mil e demandam campanhas de estímulo.

Esses números são detalhados tanto nas visualizações da Etapa 02 quanto no relatório final.

---

## Estrutura do repositório

```text
Teste_Analytics_CristovamPaulo/
├── Parte01/
│   ├── Etapa01.ipynb              # Geração de dados, diagnóstico, limpeza e análise de vendas
│   └── Etapa02.ipynb              # EDA e visualizações (tendência mensal e top‑5 produtos)
├── data/
│   ├── raw/
│   │   └── vendas_2023.csv        # CSV sintético com sujeiras (dataset bruto)
│   └── processed/
│       ├── data_clean.csv         # Conjunto de vendas limpo e padronizado
│       └── vendas_por_produto.csv # Total de vendas por produto (ranking)
├── reports/
│   └── figures/
│       ├── tendencia_mensal.png   # Gráfico de linha (gerado na Etapa 02)
│       └── top5_produtos.png      # Gráfico de barras (gerado na Etapa 02)
├── sql/
│   └── consultas_sql.sql          # (sugestão) consultas SQL da Parte 2
├── presentation/                  # (sugestão) slides/apresentações finais
└── relatorio_insights.md          # (sugestão) relatório textual com insights
```

> **Observação.** Algumas pastas como `sql/` e `presentation/` podem estar vazias ou não presentes no repositório inicial; são previstas no enunciado para armazenar as consultas da Parte 2 e materiais da Parte 3.

---

## Como executar os scripts

### Preparação do ambiente

É recomendável utilizar um ambiente virtual (`venv` ou `conda`). Após ativar, instale as dependências:

```bash
pip install pandas numpy faker matplotlib ipython
```

Para executar os notebooks, instale o Jupyter:

```bash
pip install notebook
jupyter notebook
```

### Execução da Etapa 01 (simulação e limpeza)

Abra o notebook `Parte01/Etapa01.ipynb` no Jupyter e execute as células em ordem. Ao final, serão gerados:

- `data/raw/vendas_2023.csv`
- `data/processed/data_clean.csv`
- `data/processed/vendas_por_produto.csv`

Também será exibido no console um **resumo da limpeza** com contagem de linhas descartadas e imputadas.

### Execução da Etapa 02 (EDA)

Antes de rodar `Parte01/Etapa02.ipynb`, garanta que `data/processed/data_clean.csv` exista (gerado na Etapa 01). Abra o notebook e execute todas as células. Serão criados os gráficos em `reports/figures` e impressos os **insights iniciais**.

### Consultas SQL e relatório

Crie o arquivo `sql/consultas_sql.sql` com as consultas sugeridas. Utilize um SGBD de sua preferência (SQLite, PostgreSQL, MySQL etc.) e **carregue o CSV limpo** para executar as consultas.  
Escreva `relatorio_insights.md` destacando os achados e sugerindo ações para o negócio.

---

## Assunções e considerações

- **Período do dataset.** O enunciado solicita dados de 2023; a simulação **não foi estendida para 2024**. Para responder consultas de **junho/2024**, defina `EXTENDER_ATE_2024_06 = True` no notebook de simulação para incluir datas até `2024-06-30`.  
- **Dados sintéticos.** Todos os dados são fictícios e servem apenas para demonstrar habilidade técnica. Valores monetários são expressos em **reais (R$)** e **escalados em centavos** no arquivo limpo para evitar perdas de precisão (por exemplo, `27560.00` representa **R$ 275,60**).  
- **Visualizações.** Utilizou-se **matplotlib** (estilo *seaborn*) para criar os gráficos; outras bibliotecas (como **seaborn** ou **plotly**) poderiam ser usadas, salvando as figuras em `reports/figures`.  
- **Qualidade do código.** Código **comentado**, estruturado em **funções** e com limpeza **parametrizada** (ex.: chaves para agregar duplicatas, número de casas decimais), facilitando reutilização e testes.

---

## Conclusão

Este repositório demonstra a capacidade de realizar **todo o ciclo de análise de dados** de um problema fictício: da geração e tratamento do dataset até a apresentação de insights por meio de **gráficos e SQL**. Seguindo a estrutura proposta, é possível **reproduzir resultados**, verificar a organização do código e compreender as decisões tomadas ao longo do projeto. A **documentação clara** e a **limpeza cuidadosa** evidenciam atenção aos detalhes e boas práticas de ciência de dados.

---
