SELECT
  DATE_TRUNC('month', i.issued_at) :: DATE AS billing_month,
  p.name AS plan_name,
  COUNT(DISTINCT t.id) AS tenant_count,
  SUM(i.amount) AS monthly_revenue
FROM invoices i
  JOIN tenants t
    ON t.id = i.tenant_id
  JOIN subscriptions s
    ON s.tenant_id = t.id
  JOIN plans p
    ON p.id = s.plan_id
WHERE i.status = 'paid'
GROUP BY billing_month,
         p.name
ORDER BY billing_month DESC, monthly_revenue DESC;