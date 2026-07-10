WITH active_tenants AS (
  SELECT t.id, t.company_name, t.industry
  FROM tenants t
  WHERE t.status = 'active'
),
sub_plans AS (
  SELECT s.tenant_id, p.name AS plan_name
  FROM subscriptions s
  JOIN plans p ON p.id = s.plan_id
),
agg_usage_events AS (
  SELECT ue.tenant_id,
         COUNT(DISTINCT ue.id) AS usage_events,
         SUM(ue.api_calls) AS total_api_calls
  FROM usage_events ue
  WHERE ue.created_at >= NOW() - INTERVAL '90 days'
  GROUP BY ue.tenant_id
),
agg_invoices AS (
  SELECT i.tenant_id,
         COUNT(DISTINCT i.id) AS invoice_count,
         SUM(i.amount) AS total_invoiced
  FROM invoices i
  GROUP BY i.tenant_id
),
agg_support_tickets AS (
  SELECT st.tenant_id,
         COUNT(DISTINCT st.id) AS ticket_count
  FROM support_tickets st
  GROUP BY st.tenant_id
),
agg_users AS (
  SELECT u.tenant_id,
         COUNT(DISTINCT u.id) AS total_users
  FROM users u
  GROUP BY u.tenant_id
)
SELECT
  t.company_name,
  t.industry,
  sp.plan_name,
  COALESCE(u.total_users, 0) AS total_users,
  COALESCE(ue.usage_events, 0) AS usage_events,
  COALESCE(ue.total_api_calls, 0) AS total_api_calls,
  COALESCE(i.invoice_count, 0) AS invoice_count,
  COALESCE(i.total_invoiced, 0) AS total_invoiced,
  COALESCE(st.ticket_count, 0) AS ticket_count
FROM active_tenants t
JOIN sub_plans sp ON sp.tenant_id = t.id
LEFT JOIN agg_users u ON u.tenant_id = t.id
LEFT JOIN agg_usage_events ue ON ue.tenant_id = t.id
LEFT JOIN agg_invoices i ON i.tenant_id = t.id
LEFT JOIN agg_support_tickets st ON st.tenant_id = t.id
ORDER BY total_api_calls DESC;
