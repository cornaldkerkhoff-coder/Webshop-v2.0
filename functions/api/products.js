// functions/api/products.js
// Eenvoudige API voor producten
// GET  /api/products        -> lijst met producten
// POST /api/products        -> verwacht volledige array, overschrijft tabel

export async function onRequestGet(context) {
  const db = context.env.DB;

  const { results } = await db
    .prepare("SELECT * FROM products ORDER BY name;")
    .all();

  // Strings met JSON weer omzetten naar echte arrays
  const products = results.map(row => ({
    ...row,
    price_retail: row.price_retail != null ? Number(row.price_retail) : null,
    supplier_price: row.supplier_price != null ? Number(row.supplier_price) : null,
    vat_rate: row.vat_rate != null ? Number(row.vat_rate) : null,
    stock_quantity: row.stock_quantity != null ? Number(row.stock_quantity) : null,
    tags: row.tags ? JSON.parse(row.tags) : [],
    extra_image_urls: row.extra_image_urls ? JSON.parse(row.extra_image_urls) : []
  }));

  return new Response(JSON.stringify(products), {
    headers: { "Content-Type": "application/json" }
  });
}

export async function onRequestPost(context) {
  const db = context.env.DB;
  const request = context.request;

  // LET OP: dit is zonder auth; iedereen kan de API aanroepen als hij de URL weet.
  // Voor een serieuze productie-shop moet hier later AUTH bij komen (login / secret header).
  
  let body;
  try {
    body = await request.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON" }), {
      status: 400,
      headers: { "Content-Type": "application/json" }
    });
  }

  if (!Array.isArray(body)) {
    return new Response(JSON.stringify({ error: "Expected an array of products" }), {
      status: 400,
      headers: { "Content-Type": "application/json" }
    });
  }

  // Tabel leegmaken en alles opnieuw invoegen (eenvoudig en veilig voor kleine aantallen)
  await db.prepare("DELETE FROM products;").run();

  const insert = db.prepare(`
    INSERT INTO products (
      slug, name, short_description, long_description,
      category, subcategory, brand, tags,
      price_retail, price_currency,
      supplier_price, supplier_currency, supplier_name, supplier_product_url,
      vat_rate, stock_status, stock_quantity,
      main_image_url, extra_image_urls
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
  `);

  for (const p of body) {
    await insert
      .bind(
        p.slug,
        p.name,
        p.short_description || "",
        p.long_description || "",
        p.category || "",
        p.subcategory || null,
        p.brand || null,
        JSON.stringify(p.tags || []),
        p.price_retail ?? 0,
        p.price_currency || "EUR",
        p.supplier_price ?? null,
        p.supplier_currency || "EUR",
        p.supplier_name || null,
        p.supplier_product_url || null,
        p.vat_rate ?? 21,
        p.stock_status || "in_stock",
        p.stock_quantity ?? null,
        p.main_image_url || null,
        JSON.stringify(p.extra_image_urls || [])
      )
      .run();
  }

  return new Response(JSON.stringify({ ok: true, count: body.length }), {
    headers: { "Content-Type": "application/json" }
  });
}
