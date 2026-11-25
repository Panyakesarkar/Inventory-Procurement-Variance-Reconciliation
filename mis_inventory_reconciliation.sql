-- ============================================================================
-- PROJECT 2 (MIS EXECUTIVE): Inventory & Procurement Variance Reconciliation
-- AUTHOR: Pranav Kesarkar | Tools: MySQL, Excel MIS
-- ============================================================================

-- 1. Three-Way Reconciliation: Purchase Order vs. Goods Receipt (GRN) vs. Vendor Invoice
SELECT
    po.po_id,
    po.vendor_name,
    po.warehouse_city,
    po.sku_category,
    po.ordered_qty,
    grn.received_qty,
    inv.billed_qty,
    po.unit_price_inr,
    (po.ordered_qty - grn.received_qty) AS short_supply_qty,
    (inv.billed_qty - grn.received_qty) * po.unit_price_inr AS overbilled_leakage_inr,
    CASE
        WHEN grn.received_qty IS NULL OR grn.received_qty = 0 THEN 'CRITICAL: Missing GRN'
        WHEN inv.billed_qty > grn.received_qty THEN 'AUDIT FLAG: Overbilled vs GRN'
        WHEN grn.received_qty < po.ordered_qty THEN 'WARNING: Short Supply'
        ELSE 'MATCHED'
    END AS reconciliation_status
FROM purchase_orders po
LEFT JOIN warehouse_grn grn ON po.po_id = grn.po_id
LEFT JOIN vendor_invoices inv ON po.po_id = inv.po_id
ORDER BY overbilled_leakage_inr DESC;

-- 2. Vendor-Wise Cost Leakage & SLA Accuracy Summary
SELECT
    po.vendor_name,
    COUNT(po.po_id) AS total_pos,
    SUM(CASE WHEN inv.billed_qty > grn.received_qty THEN 1 ELSE 0 END) AS overbilled_count,
    ROUND(SUM(GREATEST(inv.billed_qty - COALESCE(grn.received_qty, 0), 0) * po.unit_price_inr), 2) AS total_leakage_inr
FROM purchase_orders po
LEFT JOIN warehouse_grn grn ON po.po_id = grn.po_id
LEFT JOIN vendor_invoices inv ON po.po_id = inv.po_id
GROUP BY po.vendor_name
ORDER BY total_leakage_inr DESC;
