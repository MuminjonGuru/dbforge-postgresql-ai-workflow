INSERT INTO plans (name, monthly_price, max_users, max_api_calls)
VALUES
('Free', 0.00, 3, 1000),
('Pro', 49.00, 15, 50000),
('Business', 199.00, 75, 500000),
('Enterprise', 799.00, 500, 5000000);

INSERT INTO tenants (company_name, industry, country, status, created_at)
SELECT
    'Company ' || gs,
    CASE 
        WHEN gs % 5 = 0 THEN 'FinTech'
        WHEN gs % 5 = 1 THEN 'Healthcare'
        WHEN gs % 5 = 2 THEN 'E-commerce'
        WHEN gs % 5 = 3 THEN 'Education'
        ELSE 'Cybersecurity'
    END,
    CASE 
        WHEN gs % 4 = 0 THEN 'United Kingdom'
        WHEN gs % 4 = 1 THEN 'United States'
        WHEN gs % 4 = 2 THEN 'Germany'
        ELSE 'Singapore'
    END,
    CASE 
        WHEN gs % 12 = 0 THEN 'inactive'
        WHEN gs % 17 = 0 THEN 'trial'
        ELSE 'active'
    END,
    NOW() - (gs || ' days')::INTERVAL
FROM generate_series(1, 80) gs;

INSERT INTO users (tenant_id, full_name, email, role, last_login_at, created_at)
SELECT
    t.id,
    'User ' || u || ' Tenant ' || t.id,
    'user' || u || '.tenant' || t.id || '@example.com',
    CASE 
        WHEN u = 1 THEN 'admin'
        WHEN u % 4 = 0 THEN 'analyst'
        ELSE 'member'
    END,
    NOW() - ((random() * 40)::INT || ' days')::INTERVAL,
    t.created_at + ((random() * 10)::INT || ' days')::INTERVAL
FROM tenants t
CROSS JOIN generate_series(1, 5) u;

INSERT INTO subscriptions (tenant_id, plan_id, status, started_at, ended_at)
SELECT
    t.id,
    CASE
        WHEN t.id % 10 = 0 THEN 4
        WHEN t.id % 4 = 0 THEN 3
        WHEN t.id % 2 = 0 THEN 2
        ELSE 1
    END,
    CASE
        WHEN t.status = 'inactive' THEN 'cancelled'
        WHEN t.status = 'trial' THEN 'trial'
        ELSE 'active'
    END,
    CURRENT_DATE - ((random() * 300)::INT),
    CASE WHEN t.status = 'inactive' THEN CURRENT_DATE - ((random() * 30)::INT) ELSE NULL END
FROM tenants t;

INSERT INTO invoices (tenant_id, invoice_number, amount, status, issued_at, due_date, paid_at)
SELECT
    t.id,
    'INV-' || t.id || '-' || m,
    p.monthly_price,
    CASE
        WHEN random() < 0.75 THEN 'paid'
        WHEN random() < 0.90 THEN 'open'
        ELSE 'overdue'
    END,
    CURRENT_DATE - (m * 30),
    CURRENT_DATE - (m * 30) + 14,
    CASE WHEN random() < 0.75 THEN CURRENT_DATE - (m * 30) + ((random() * 10)::INT) ELSE NULL END
FROM tenants t
JOIN subscriptions s ON s.tenant_id = t.id
JOIN plans p ON p.id = s.plan_id
CROSS JOIN generate_series(1, 8) m;

INSERT INTO payments (invoice_id, amount, payment_method, status, paid_at)
SELECT
    i.id,
    i.amount,
    CASE 
        WHEN random() < 0.6 THEN 'card'
        WHEN random() < 0.85 THEN 'bank_transfer'
        ELSE 'paypal'
    END,
    'successful',
    i.paid_at::TIMESTAMP
FROM invoices i
WHERE i.status = 'paid';

INSERT INTO usage_events (tenant_id, user_id, event_type, feature_name, api_calls, created_at)
SELECT
    u.tenant_id,
    u.id,
    CASE 
        WHEN random() < 0.5 THEN 'api_request'
        WHEN random() < 0.75 THEN 'dashboard_view'
        WHEN random() < 0.9 THEN 'report_export'
        ELSE 'login'
    END,
    CASE 
        WHEN random() < 0.3 THEN 'analytics'
        WHEN random() < 0.55 THEN 'billing'
        WHEN random() < 0.75 THEN 'automation'
        WHEN random() < 0.9 THEN 'security'
        ELSE 'integrations'
    END,
    (random() * 500)::INT,
    NOW() - ((random() * 180)::INT || ' days')::INTERVAL
FROM users u
CROSS JOIN generate_series(1, 80) e;

INSERT INTO support_tickets (tenant_id, user_id, priority, status, subject, created_at, resolved_at)
SELECT
    u.tenant_id,
    u.id,
    CASE 
        WHEN random() < 0.1 THEN 'critical'
        WHEN random() < 0.3 THEN 'high'
        WHEN random() < 0.7 THEN 'medium'
        ELSE 'low'
    END,
    CASE 
        WHEN random() < 0.65 THEN 'resolved'
        WHEN random() < 0.85 THEN 'open'
        ELSE 'waiting_customer'
    END,
    CASE 
        WHEN random() < 0.3 THEN 'Billing issue'
        WHEN random() < 0.55 THEN 'API performance problem'
        WHEN random() < 0.75 THEN 'User access problem'
        ELSE 'Dashboard data mismatch'
    END,
    NOW() - ((random() * 120)::INT || ' days')::INTERVAL,
    CASE WHEN random() < 0.65 THEN NOW() - ((random() * 60)::INT || ' days')::INTERVAL ELSE NULL END
FROM users u
WHERE random() < 0.35;

INSERT INTO audit_log (tenant_id, user_id, action, ip_address, risk_level, created_at)
SELECT
    u.tenant_id,
    u.id,
    CASE 
        WHEN random() < 0.45 THEN 'login_success'
        WHEN random() < 0.65 THEN 'login_failed'
        WHEN random() < 0.8 THEN 'role_changed'
        WHEN random() < 0.9 THEN 'api_key_created'
        ELSE 'password_reset'
    END,
    ('192.168.' || (random() * 255)::INT || '.' || (random() * 255)::INT)::INET,
    CASE 
        WHEN random() < 0.75 THEN 'low'
        WHEN random() < 0.93 THEN 'medium'
        ELSE 'high'
    END,
    NOW() - ((random() * 90)::INT || ' days')::INTERVAL
FROM users u
CROSS JOIN generate_series(1, 15) a;



-- Script that is shown in the video.
-- SELECT
--   DATE_TRUNC('month', i.issued_at) :: DATE AS billing_month,
--   p.name AS plan_name,
--   COUNT(DISTINCT t.id) AS tenant_count,
--   SUM(i.amount) AS monthly_revenue
-- FROM invoices i
--   JOIN tenants t
--     ON t.id = i.tenant_id
--   JOIN subscriptions s
--     ON s.tenant_id = t.id
--   JOIN plans p
--     ON p.id = s.plan_id
-- WHERE i.status = 'paid'
-- GROUP BY billing_month,
--          p.name
-- ORDER BY billing_month DESC, monthly_revenue DESC;
