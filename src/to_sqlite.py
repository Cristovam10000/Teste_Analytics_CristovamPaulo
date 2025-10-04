from pathlib import Path
import pandas as pd
import sqlite3

def find_root(start: Path = Path.cwd(), marker="data", max_up=6) -> Path:
    p = start
    for _ in range(max_up):
        if (p / marker).exists():
            return p
        p = p.parent
    raise FileNotFoundError(f"Não achei a pasta '{marker}' acima de {start}")

ROOT = find_root()
CSV  = ROOT / "data" / "processed" / "data_clean.csv"
DB   = ROOT / "vendas.db"

print("ROOT :", ROOT)
print("CSV  :", CSV)
print("DB   :", DB)

# 1) Ler CSV (garante Data como datetime)
df = pd.read_csv(CSV, parse_dates=["Data"])

# 2) Conectar no SQLite nativo e gravar a tabela 'vendas'
with sqlite3.connect(DB) as con:
    df.to_sql("vendas", con, if_exists="replace", index=False)

print(f"OK! Criado {DB} com tabela 'vendas' ({len(df)} linhas).")
