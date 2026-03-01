-- ============================================
-- Duas Marias Doces - Dados Iniciais (Seed)
-- Sistema de Fluxo de Caixa
-- ============================================

-- Usuário admin (login: admin / senha: admin123)
-- Hash bcrypt para 'admin123'
INSERT INTO users (nome, nome_usuario, email, senha_hash)
VALUES ('Administrador', 'admin', 'admin@duasmarias.com', '$2b$10$8KzaNdKIMyOkASCBkeRsKOnrr2mLJMheMCl2fEuPJFBVi6UBMqOYu')
ON CONFLICT (nome_usuario) DO NOTHING;

-- Loja principal (Matriz)
INSERT INTO lojas (nome, matriz)
VALUES ('Duas Marias Doces', TRUE);

-- ============================================
-- Origens (de onde vem o dinheiro)
-- ============================================
INSERT INTO origens (nome, descricao, padrao) VALUES
('Vendas Balcão', 'Vendas realizadas no balcão da loja', TRUE),
('Encomendas', 'Encomendas de doces e bolos personalizados', FALSE),
('Eventos', 'Receitas de buffet e eventos', FALSE),
('Delivery', 'Vendas por delivery e aplicativos', FALSE),
('Revenda', 'Revenda para outros estabelecimentos', FALSE);

-- ============================================
-- Destinos (para onde vai o dinheiro)
-- ============================================
INSERT INTO destinos (nome, descricao, padrao) VALUES
('Fornecedores Ingredientes', 'Compra de ingredientes e matéria-prima', TRUE),
('Embalagens', 'Compra de embalagens, caixas e sacolas', FALSE),
('Funcionários', 'Folha de pagamento e encargos', FALSE),
('Aluguel', 'Aluguel do ponto comercial', FALSE),
('Energia / Água / Gás', 'Contas de consumo (luz, água, gás)', FALSE),
('Equipamentos', 'Manutenção e compra de equipamentos de cozinha', FALSE),
('Marketing', 'Publicidade, redes sociais e divulgação', FALSE),
('Impostos', 'Pagamento de impostos e taxas', FALSE);

-- ============================================
-- Etiquetas (categorias)
-- ============================================
INSERT INTO etiquetas (nome, descricao, cor, padrao) VALUES
('Produção', 'Custos de produção de doces', '#EC4899', TRUE),
('Matéria-Prima', 'Ingredientes e insumos', '#F59E0B', FALSE),
('Operacional', 'Despesas operacionais do dia a dia', '#8B5CF6', FALSE),
('Investimento', 'Investimentos e melhorias', '#10B981', FALSE),
('Pessoal', 'Gastos com pessoal e folha', '#3B82F6', FALSE),
('Vendas', 'Receitas de vendas em geral', '#06B6D4', FALSE);

-- ============================================
-- Tipos de Pagamento
-- ============================================
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
