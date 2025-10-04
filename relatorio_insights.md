# Relatório de Insights — Vendas 2023

Este documento resume os achados das Partes 1 e 2 do desafio, cobrindo a simulação, limpeza, exploração e consultas SQL sobre a base de vendas de 2023.

**Contexto e dados**
- Dataset sintético com 300 registros entre 01/01/2023 e 31/12/2023.
- Processos aplicados: tratamento de ausências/inconsistências, remoção de duplicatas e padronização de tipos.
- Artefatos entregues: `data/processed/data_clean.csv`, `data/processed/vendas_por_produto.csv`, figuras em `reports/figures/` e banco `vendas.db` (tabela `vendas`).

**Principais insights**
- **Picos sazonais concentrados**: fevereiro, agosto e dezembro somam ~R$ 67,1 mil (38% da receita anual), refletindo volta às aulas e datas promocionais de 2º semestre.
- **Dependência de eletrônicos de alto ticket**: o segmento gera R$ 61,4 mil (37% do total). A Caixa Bluetooth responde por R$ 22,7 mil e os cinco produtos líderes concentram 38,8% da receita.
- **Categorias intermediárias sustentam o “miolo” do ano**: Casa & Cozinha (R$ 33,1 mil) e Brinquedos (R$ 23,1 mil) mantêm o giro dos meses medianos; Material-Escolar adiciona R$ 2,6 mil em fevereiro (11,6% do mês).
- **Meses de baixa acentuada**: abril e maio registram menos de R$ 10 mil cada, indicando oportunidade para ações de estímulo e nivelamento da demanda.

**Recomendações**
- Planejar estoque, logística e campanhas dedicadas para os meses críticos (fev/ago/dez) e para promoções como Black Friday.
- Desenvolver estratégias de cross-sell e diversificação para reduzir a dependência de poucos eletrônicos.
- Ativar campanhas pontuais em abril e maio (bundles, descontos progressivos, frete incentivado) para suavizar a curva anual.
- Monitorar mensalmente ticket médio, taxa de recompra e margem por produto para ajustar o mix de maneira contínua.

**Observações**
- As consultas SQL foram escritas para junho/2023; executar para 2024 exige estender a simulação até junho/2024 e reprocessar os artefatos.
