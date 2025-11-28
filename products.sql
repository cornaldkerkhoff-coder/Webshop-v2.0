-- Tabel voor producten

CREATE TABLE IF NOT EXISTS products (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  slug                VARCHAR(100) NOT NULL UNIQUE,
  name                VARCHAR(200) NOT NULL,
  short_description   VARCHAR(255) NOT NULL,
  long_description    TEXT,
  category            VARCHAR(100) NOT NULL,
  subcategory         VARCHAR(100),
  brand               VARCHAR(100),
  tags                JSON,
  price_retail        DECIMAL(10,2) NOT NULL,
  price_currency      CHAR(3) NOT NULL DEFAULT 'EUR',
  supplier_price      DECIMAL(10,2),
  supplier_currency   CHAR(3) DEFAULT 'EUR',
  supplier_name       VARCHAR(150),
  supplier_product_url VARCHAR(500),
  vat_rate            DECIMAL(4,2) DEFAULT 21.00,
  stock_status        VARCHAR(20) DEFAULT 'in_stock',
  stock_quantity      INT,
  main_image_url      VARCHAR(500),
  extra_image_urls    JSON,
  created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                      ON UPDATE CURRENT_TIMESTAMP
);

-- Voorbeeldproducten (pas prijzen / teksten gerust aan)

INSERT INTO products (
  slug, name, short_description, long_description,
  category, subcategory, brand, tags,
  price_retail, price_currency,
  supplier_price, supplier_currency, supplier_name, supplier_product_url,
  vat_rate, stock_status, stock_quantity,
  main_image_url, extra_image_urls
) VALUES
(
  'aqara-smart-plug-zigbee',
  'Aqara Smart Plug Zigbee',
  'Slimme stekker om lampen en apparaten op afstand te schakelen.',
  'Slimme Zigbee-stopcontactadapter waarmee je lampen en apparaten op afstand kunt bedienen via een hub of app. Ondersteunt automatiseringen en tijdschema’s.',
  'Smart Home', 'Smart Plug', 'Aqara',
  JSON_ARRAY('smart plug', 'zigbee', 'energie', 'smart home'),
  28.59, 'EUR',
  21.99, 'EUR', 'EU smart home wholesaler',
  'https://www.smarthomedepot.eu/',
  21.00, 'in_stock', 20,
  'https://example.com/images/aqara-smart-plug.jpg',
  JSON_ARRAY()
),
(
  'sonoff-mini-d-smart-relay',
  'Sonoff MINI-D Smart WiFi Relay',
  'Compact WiFi-relais om bestaande schakelaars slim te maken.',
  'Inbouw WiFi-relaismodule voor achter een bestaande schakelaar. Schakel verlichting of stopcontacten via app, tijdschema’s of automatiseringen.',
  'Smart Home', 'Relay', 'Sonoff',
  JSON_ARRAY('wifi', 'relais', 'inbouw', 'verlichting'),
  15.75, 'EUR',
  12.10, 'EUR', 'Marketcom EU (Sonoff distributeur)',
  'https://www.marketcom.eu/sonoff-smartwise-shelly-EU-wholesale-distribution/',
  21.00, 'in_stock', 40,
  'https://example.com/images/sonoff-mini-d.jpg',
  JSON_ARRAY()
),
(
  'shelly-plug-s-gen3',
  'Shelly Plug S Gen3',
  'Slimme stekker met WiFi, Bluetooth en verbruiksmeter.',
  'Compacte smart plug met WiFi en Bluetooth. Meet energieverbruik en maakt het mogelijk apparaten op afstand te schakelen.',
  'Smart Home', 'Smart Plug', 'Shelly',
  JSON_ARRAY('smart plug', 'energieverbruik', 'wifi', 'bluetooth'),
  27.90, 'EUR',
  21.40, 'EUR', 'Smart Home Depot (Shelly)',
  'https://www.smarthomedepot.eu/',
  21.00, 'in_stock', 30,
  'https://example.com/images/shelly-plug-s.jpg',
  JSON_ARRAY()
);
