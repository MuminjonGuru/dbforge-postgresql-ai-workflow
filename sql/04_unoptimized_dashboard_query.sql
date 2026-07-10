SELECT t.company_name,
       t.industry,
       p.name AS plan_name,
       COUNT(DISTINCT u.id) AS total_users,
       COUNT(DISTINCT ue.id) AS usage_events,
       SUM(ue.api_calls) AS total_api_calls,
       COUNT(DISTINCT i.id) AS invoice_count,
       SUM(i.amount) AS total_invoiced,
       COUNT(DISTINCT st.id) AS ticket_count
FROM tenants t
JOIN subscriptions s ON s.tenant_id = t.id
JOIN plans p ON p.id = s.plan_id
LEFT JOIN users u ON u.tenant_id = t.id
LEFT JOIN usage_events ue ON ue.tenant_id = t.id
LEFT JOIN invoices i ON i.tenant_id = t.id
LEFT JOIN support_tickets st ON st.tenant_id = t.id
WHERE t.status = 'active'
  AND ue.created_at >= NOW() - INTERVAL '90 days'
GROUP BY t.company_name,
         t.industry,
         p.name
ORDER BY total_api_calls DESC;