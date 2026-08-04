# Board Game Bar — Modelagem e Implementação de Banco de Dados

Projeto de banco de dados relacional desenvolvido para a disciplina de **Banco de Dados** na **Universidade Federal de Mato Grosso (UFMT)**.

O objetivo do sistema é gerenciar a operação completa de um bar temático de jogos de tabuleiro, englobando controle de acervo de jogos, reservas de mesas, comandas de consumo, clientes e histórico de partidas.

---

## Conteúdo do Repositório

O repositório está estruturado para cobrir o ciclo completo de engenharia de dados, desde a modelagem até a extração de relatórios:

```text
/
├── docs/
│   ├── modelo-conceitual.png    # Diagrama Entidade-Relacionamento (DER)
│   ├── modelo-relacional.pdf   # Esquema relacional e mapeamento
│   └── relatorio-tecnico.pdf    # Documentação técnica completa da disciplina
├── sql/
│   ├── 01_schema.sql            # Scripts de criação de tabelas e constraints (DDL)
│   ├── 02_seed.sql              # Inserção de dados para testes (DML)
│   └── 03_queries_reports.sql   # Relatórios padronizados (SELECTs, JOINs e VIEWs)
└── README.md
