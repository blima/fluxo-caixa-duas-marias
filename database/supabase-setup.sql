-- ============================================
-- Duas Marias Doces - Setup Completo para Supabase
-- Execute este script no SQL Editor do Supabase
-- Contém: Schema + Seed em um único arquivo
-- ============================================

-- ============================================
-- 1. EXTENSÃO UUID
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 2. ENUMS
-- ============================================
DO $$ BEGIN
    CREATE TYPE modalidade_enum AS ENUM ('a_vista', 'a_prazo');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE tipo_lancamento_enum AS ENUM ('receita', 'despesa');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================
-- 3. TABELAS
-- ============================================

-- Users
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    nome_usuario VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Lojas
CREATE TABLE IF NOT EXISTS lojas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    matriz BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Origens
CREATE TABLE IF NOT EXISTS origens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    padrao BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Destinos
CREATE TABLE IF NOT EXISTS destinos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    padrao BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Etiquetas
CREATE TABLE IF NOT EXISTS etiquetas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    cor VARCHAR(7) NOT NULL DEFAULT '#EC4899',
    padrao BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Tipos de Pagamento
CREATE TABLE IF NOT EXISTS tipos_pagamento (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(150) NOT NULL,
    descricao TEXT,
    modalidade modalidade_enum NOT NULL DEFAULT 'a_vista',
    parcelas INTEGER NOT NULL DEFAULT 1,
    taxa DECIMAL(5,2) NOT NULL DEFAULT 0,
    aplicavel_receita BOOLEAN NOT NULL DEFAULT TRUE,
    aplicavel_despesa BOOLEAN NOT NULL DEFAULT TRUE,
    padrao_receita BOOLEAN NOT NULL DEFAULT FALSE,
    padrao_despesa BOOLEAN NOT NULL DEFAULT FALSE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_parcelas_modalidade CHECK (
        (modalidade = 'a_vista' AND parcelas = 1)
        OR
        (modalidade = 'a_prazo' AND parcelas > 1)
    )
);

-- Lancamentos
CREATE TABLE IF NOT EXISTS lancamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tipo tipo_lancamento_enum NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    valor DECIMAL(15, 2) NOT NULL CHECK (valor > 0),
    taxa DECIMAL(5,2) NOT NULL DEFAULT 0,
    data_lancamento TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    data_evento DATE NOT NULL DEFAULT CURRENT_DATE,
    origem_id UUID REFERENCES origens(id),
    destino_id UUID REFERENCES destinos(id),
    etiqueta_id UUID NOT NULL REFERENCES etiquetas(id),
    tipo_pagamento_id UUID NOT NULL REFERENCES tipos_pagamento(id),
    usuario_id UUID NOT NULL REFERENCES users(id),
    loja_id UUID NOT NULL REFERENCES lojas(id),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_lancamento_origem_destino CHECK (
        (tipo = 'receita' AND origem_id IS NOT NULL)
        OR
        (tipo = 'despesa' AND destino_id IS NOT NULL)
    )
);

-- ============================================
-- 4. ÍNDICES ÚNICOS PARCIAIS
-- ============================================
CREATE UNIQUE INDEX IF NOT EXISTS idx_origens_padrao
    ON origens (padrao)
    WHERE padrao = TRUE AND ativo = TRUE;

CREATE UNIQUE INDEX IF NOT EXISTS idx_destinos_padrao
    ON destinos (padrao)
    WHERE padrao = TRUE AND ativo = TRUE;

CREATE UNIQUE INDEX IF NOT EXISTS idx_etiquetas_padrao
    ON etiquetas (padrao)
    WHERE padrao = TRUE AND ativo = TRUE;

-- ============================================
-- 5. ÍNDICES DE PERFORMANCE
-- ============================================
CREATE INDEX IF NOT EXISTS idx_lancamentos_tipo ON lancamentos(tipo);
CREATE INDEX IF NOT EXISTS idx_lancamentos_data_evento ON lancamentos(data_evento);
CREATE INDEX IF NOT EXISTS idx_lancamentos_usuario ON lancamentos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_lancamentos_etiqueta ON lancamentos(etiqueta_id);
CREATE INDEX IF NOT EXISTS idx_lancamentos_ativo ON lancamentos(ativo);
CREATE INDEX IF NOT EXISTS idx_lancamentos_loja ON lancamentos(loja_id);

-- ============================================
-- 6. SEED - DADOS INICIAIS
-- ============================================

-- Usuário admin (login: admin / senha: admin123)
INSERT INTO users (nome, nome_usuario, email, senha_hash)
VALUES ('Administrador', 'admin', 'admin@duasmarias.com', '$2b$10$wA5t7M.X1k/ttrIEpLSCbuzUV0PHEvl8aOxaV/oAjHyd90jmfWUWu')
ON CONFLICT (nome_usuario) DO NOTHING;

-- Loja principal (Matriz)
INSERT INTO lojas (nome, matriz)
SELECT 'Duas Marias Doces', TRUE
WHERE NOT EXISTS (SELECT 1 FROM lojas WHERE nome = 'Duas Marias Doces');

-- Origens (de onde vem o dinheiro)
INSERT INTO origens (nome, descricao, padrao) VALUES
('Vendas Balcão', 'Vendas realizadas no balcão da loja', TRUE),
('Encomendas', 'Encomendas de doces e bolos personalizados', FALSE),
('Eventos', 'Receitas de buffet e eventos', FALSE),
('Delivery', 'Vendas por delivery e aplicativos', FALSE),
('Revenda', 'Revenda para outros estabelecimentos', FALSE);

-- Destinos (para onde vai o dinheiro)
INSERT INTO destinos (nome, descricao, padrao) VALUES
('Fornecedores Ingredientes', 'Compra de ingredientes e matéria-prima', TRUE),
('Embalagens', 'Compra de embalagens, caixas e sacolas', FALSE),
('Funcionários', 'Folha de pagamento e encargos', FALSE),
('Aluguel', 'Aluguel do ponto comercial', FALSE),
('Energia / Água / Gás', 'Contas de consumo (luz, água, gás)', FALSE),
('Equipamentos', 'Manutenção e compra de equipamentos de cozinha', FALSE),
('Marketing', 'Publicidade, redes sociais e divulgação', FALSE),
('Impostos', 'Pagamento de impostos e taxas', FALSE);

-- Etiquetas (categorias com cores da identidade visual)
INSERT INTO etiquetas (nome, descricao, cor, padrao) VALUES
('Produção', 'Custos de produção de doces', '#EC4899', TRUE),
('Matéria-Prima', 'Ingredientes e insumos', '#F59E0B', FALSE),
('Operacional', 'Despesas operacionais do dia a dia', '#8B5CF6', FALSE),
('Investimento', 'Investimentos e melhorias', '#10B981', FALSE),
('Pessoal', 'Gastos com pessoal e folha', '#3B82F6', FALSE),
('Vendas', 'Receitas de vendas em geral', '#06B6D4', FALSE);

-- Tipos de Pagamento
INSERT INTO tipos_pagamento (nome, descricao, modalidade, parcelas, aplicavel_receita, aplicavel_despesa) VALUES
('Dinheiro', 'Pagamento em dinheiro', 'a_vista', 1, TRUE, TRUE),
('PIX', 'Transferência via PIX', 'a_vista', 1, TRUE, TRUE),
('Cartão de Débito', 'Pagamento com cartão de débito', 'a_vista', 1, TRUE, TRUE),
('Cartão de Crédito 1x', 'Pagamento com cartão à vista', 'a_vista', 1, TRUE, TRUE),
('Cartão de Crédito 2x', 'Parcelamento em 2 vezes', 'a_prazo', 2, TRUE, TRUE),
('Cartão de Crédito 3x', 'Parcelamento em 3 vezes', 'a_prazo', 3, TRUE, TRUE),
('Cartão de Crédito 6x', 'Parcelamento em 6 vezes', 'a_prazo', 6, TRUE, TRUE),
('Cartão de Crédito 12x', 'Parcelamento em 12 vezes', 'a_prazo', 12, TRUE, TRUE),
('Boleto', 'Pagamento via boleto bancário', 'a_vista', 1, FALSE, TRUE),
('Transferência Bancária', 'Transferência entre contas', 'a_vista', 1, TRUE, TRUE);

-- ============================================
-- PRONTO! Banco configurado para Duas Marias Doces
-- Login: admin / admin123
-- ============================================
