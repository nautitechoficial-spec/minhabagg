-- Ajustes finais para novas funcionalidades do painel
-- Execute este arquivo no banco da MinhaBagg

CREATE TABLE IF NOT EXISTS wallet_bank_accounts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  store_id INT UNSIGNED NOT NULL,
  bank_name VARCHAR(120) NULL,
  agency VARCHAR(30) NULL,
  account_number VARCHAR(60) NULL,
  account_type VARCHAR(30) NULL DEFAULT 'corrente',
  pix_key_type VARCHAR(30) NULL,
  pix_key VARCHAR(150) NULL,
  holder_name VARCHAR(150) NULL,
  holder_document VARCHAR(40) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_wallet_bank_accounts_store (store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS wallet_withdrawals (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  store_id INT UNSIGNED NOT NULL,
  amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processed_at DATETIME NULL,
  notes TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_wallet_withdrawals_store_status (store_id, status),
  KEY idx_wallet_withdrawals_requested_at (requested_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Opcional: melhora da rastreabilidade de pedidos criados manualmente
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS manual_notes TEXT NULL AFTER gateway_last_error;

ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS source_context VARCHAR(60) NULL AFTER sales_channel;
