SELECT
  to_char(i.issued_at, 'YYYY-MM') AS year_month,
  p.name AS plan_name,
  SUM(i.amount) AS monthly_recurring_revenue
FROM
  public.invoices i
JOIN
  public.subscriptions s ON i.tenant_id = s.tenant_id
                         AND s.status = 'active'
                         AND (s.ended_at IS NULL OR s.ended_at >= date_trunc('month', i.issued_at))
                         AND s.started_at <= i.issued_at
JOIN
  public.plans p ON s.plan_id = p.id
WHERE
  i.status = 'paid'
  AND i.issued_at >= date_trunc('month', CURRENT_DATE) - INTERVAL '5 months'
  AND i.issued_at < date_trunc('month', CURRENT_DATE) + INTERVAL '1 month'
GROUP BY
  year_month,
  plan_name
ORDER BY
  year_month DESC,
  plan_name;
