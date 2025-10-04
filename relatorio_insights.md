# Relatorio de Insights - Vendas 2023

Este documento resume os achados das Partes 1 e 2 do desafio, cobrindo a simulacao, limpeza, exploracao e consultas SQL sobre a base de vendas de 2023.

**Contexto e dados**
- Dataset sintetico com 300 registros entre 01/01/2023 e 31/12/2023.
- Processos aplicados: tratamento de ausencias/inconsistencias, remocao de duplicatas e padronizacao de tipos.
- Artefatos entregues: `data/processed/data_clean.csv`, `data/processed/vendas_por_produto.csv`, figuras em `reports/figures/` e banco `vendas.db` (tabela `vendas`).

**Principais insights**
- **Picos sazonais concentrados**: dezembro, fevereiro e janeiro somam ~R$ 66,3 mil (35% da receita anual), juntando férias, volta as aulas e festividades de fim de ano.
- **Dependencia de eletronicos de alto ticket**: o segmento gera R$ 74,7 mil (40% do total). A Caixa Bluetooth responde por R$ 25,1 mil e os cinco produtos lideres concentram 40,5% da receita.
- **Categorias intermediarias sustentam o miolo do ano**: Casa & Cozinha (R$ 29,3 mil), Esporte (R$ 28,5 mil) e Brinquedos (R$ 23,8 mil) mantem o giro dos meses medianos; Material Escolar adiciona R$ 11,4 mil no acumulado e participa de 10,5% das vendas de fevereiro.
- **Meses de baixa acentuada**: junho (R$ 9,0 mil) e marco (R$ 9,7 mil) ficam abaixo de R$ 10 mil cada, mostrando oportunidade para campanhas de impulso e nivelamento da demanda.

**Recomendacoes**
- Planejar estoque, logistica e campanhas dedicadas para os meses criticos (dez/fev/jan) e para promocoes como Black Friday.
- Desenvolver estrategias de cross-sell e diversificacao para reduzir a dependencia de poucos eletronicos.
- Ativar campanhas pontuais em periodos de baixa (marco e junho) com bundles, descontos progressivos ou incentivos de frete.
- Monitorar mensalmente ticket medio, taxa de recompra e margem por produto para ajustar o mix continuamente.

**Observacoes**
- As consultas SQL foram escritas para junho/2023; executar para 2024 exige estender a simulacao ate junho/2024 e reprocessar os artefatos.
