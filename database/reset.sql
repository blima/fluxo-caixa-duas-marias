-- ============================================
-- Duas Marias Doces - RESET COMPLETO
-- CUIDADO: Este script APAGA todos os dados!
-- ============================================

-- Dropar tabelas na ordem correta (dependências)
DROP TABLE IF EXISTS lancamentos CASCADE;
DROP TABLE IF EXISTS tipos_pagamento CASCADE;
DROP TABLE IF EXISTS etiquetas CASCADE;
DROP TABLE IF EXISTS destinos CASCADE;
DROP TABLE IF EXISTS origens CASCADE;
DROP TABLE IF EXISTS lojas CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Dropar enums
DROP TYPE IF EXISTS tipo_lancamento_enum CASCADE;
DROP TYPE IF EXISTS modalidade_enum CASCADE;

-- Recriar tudo
\i schema.sql
\i seed.sql
