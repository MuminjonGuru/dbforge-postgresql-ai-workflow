SELECT
  tenants.company_name,
  plans.name,
  subscriptions.status,
  invoices.amount,
  invoices.status
FROM subscriptions
  INNER JOIN tenants
    ON subscriptions.tenant_id = tenants.id
  INNER JOIN plans
    ON subscriptions.plan_id = plans.id
  INNER JOIN invoices
    ON invoices.tenant_id = tenants.id
WHERE invoices.status = 'paid'
