CREATE TABLE IF NOT EXISTS abastecimentos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    data TEXT NOT NULL,
    veiculo_id TEXT NOT NULL,
    combustivel TEXT NOT NULL,
    litros REAL NOT NULL CHECK (litros > 0),
    valor_total REAL NOT NULL CHECK (valor_total > 0),
    preco_litro REAL NOT NULL CHECK (preco_litro > 0),
    odometro INTEGER CHECK (odometro IS NULL OR odometro >= 0),
    observacao TEXT,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS abastecimentos_pendentes (
    chat_id TEXT PRIMARY KEY,
    usuario_id TEXT NOT NULL,
    dados_json TEXT NOT NULL,
    status TEXT NOT NULL,
    campo_pendente TEXT,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
