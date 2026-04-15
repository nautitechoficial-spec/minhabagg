
-- Migração: Marketplaces + Afiliados (Minhabagg)
CREATE TABLE IF NOT EXISTS marketplace_integrations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  provider VARCHAR(50) NOT NULL,
  status ENUM('not_installed','installed','pending_auth','connected','paused','error') NOT NULL DEFAULT 'not_installed',
  app_id VARCHAR(255) NULL,
  app_secret VARCHAR(255) NULL,
  access_token TEXT NULL,
  refresh_token TEXT NULL,
  external_seller_id VARCHAR(255) NULL,
  external_shop_id VARCHAR(255) NULL,
  sync_catalog TINYINT(1) NOT NULL DEFAULT 1,
  sync_orders TINYINT(1) NOT NULL DEFAULT 1,
  sync_stock TINYINT(1) NOT NULL DEFAULT 1,
  sync_prices TINYINT(1) NOT NULL DEFAULT 0,
  price_markup_percent DECIMAL(8,2) NOT NULL DEFAULT 0,
  stock_reserve_percent DECIMAL(8,2) NOT NULL DEFAULT 0,
  auto_import_orders TINYINT(1) NOT NULL DEFAULT 1,
  last_sync_at DATETIME NULL,
  last_sync_status ENUM('success','warning','error') NULL,
  last_sync_message VARCHAR(255) NULL,
  meta_json LONGTEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_store_provider (store_id, provider),
  KEY idx_store (store_id),
  KEY idx_provider (provider)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS marketplace_integration_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  integration_id INT NULL,
  provider VARCHAR(50) NOT NULL,
  event_type VARCHAR(60) NOT NULL,
  level ENUM('info','success','warning','error') NOT NULL DEFAULT 'info',
  message VARCHAR(255) NOT NULL,
  payload_json LONGTEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_store_provider (store_id, provider),
  KEY idx_integration (integration_id),
  KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS marketplace_global_settings (
  store_id INT PRIMARY KEY,
  mobile_notifications TINYINT(1) NOT NULL DEFAULT 1,
  default_catalog_sync_interval_min INT NOT NULL DEFAULT 30,
  default_order_sync_interval_min INT NOT NULL DEFAULT 5,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS affiliate_settings (
  store_id INT PRIMARY KEY,
  default_commission_type ENUM('percentage','fixed') NOT NULL DEFAULT 'percentage',
  default_commission_value DECIMAL(10,2) NOT NULL DEFAULT 10.00,
  auto_approve TINYINT(1) NOT NULL DEFAULT 0,
  cookie_days INT NOT NULL DEFAULT 30,
  min_payout_amount DECIMAL(10,2) NOT NULL DEFAULT 50.00,
  payout_day_of_month TINYINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS affiliates (
  id INT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  customer_id INT NOT NULL,
  slug VARCHAR(120) NOT NULL,
  status ENUM('pending','active','inactive') NOT NULL DEFAULT 'pending',
  commission_type ENUM('percentage','fixed') NOT NULL DEFAULT 'percentage',
  commission_value DECIMAL(10,2) NOT NULL DEFAULT 10.00,
  notes VARCHAR(255) NULL,
  approved_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_store_customer (store_id, customer_id),
  UNIQUE KEY uk_store_slug (store_id, slug),
  KEY idx_store_status (store_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS affiliate_links (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  affiliate_id INT NOT NULL,
  slug VARCHAR(120) NOT NULL,
  target_type ENUM('store_home','product','collection','custom') NOT NULL DEFAULT 'store_home',
  target_id INT NULL,
  target_url VARCHAR(500) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_store_affiliate (store_id, affiliate_id),
  KEY idx_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS affiliate_clicks (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  affiliate_id INT NOT NULL,
  affiliate_link_id BIGINT NULL,
  session_token VARCHAR(120) NULL,
  referrer VARCHAR(500) NULL,
  landing_path VARCHAR(500) NULL,
  ip_hash VARCHAR(128) NULL,
  user_agent VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_store_affiliate_created (store_id, affiliate_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS affiliate_order_attributions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id INT NOT NULL,
  affiliate_id INT NOT NULL,
  order_id INT NOT NULL,
  customer_id INT NULL,
  commission_type ENUM('percentage','fixed') NOT NULL,
  commission_value DECIMAL(10,2) NOT NULL,
  commission_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
  order_total DECIMAL(10,2) NOT NULL DEFAULT 0,
  status ENUM('pending','approved','paid','canceled') NOT NULL DEFAULT 'pending',
  approved_at DATETIME NULL,
  paid_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_store_order_affiliate (store_id, order_id, affiliate_id),
  KEY idx_store_aff_status (store_id, affiliate_id, status),
  KEY idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
