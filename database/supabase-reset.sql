-- ============================================
-- Duas Marias Doces - RESET para Supabase
-- CUIDADO: Este script APAGA todos os dados!
-- Execute no SQL Editor do Supabase
-- Após executar, rode o supabase-setup.sql
-- ============================================

-- Dropar tabelas na ordem correta (respeitar FK)
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
