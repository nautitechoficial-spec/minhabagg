-- Patch leve para painel principal + notificações automáticas do afiliado da plataforma
-- Estrutura principal já existe no banco minhabag_db (23); este arquivo só garante regras padrão.

DELETE FROM platform_notification_rules WHERE code IN (
  'affiliate_sale_created_auto',
  'affiliate_sale_paid_auto',
  'store_subscription_paid_auto'
);

INSERT INTO platform_notification_rules (
  name, code, event_type, audience, scope_sector, schedule_time, schedule_timezone,
  trigger_mode, send_only_if_has_device, dedupe_window_minutes, cooldown_minutes,
  priority_level, allow_negative_message, notes,
  title_positive, message_positive, title_negative, message_negative,
  link_url, enabled, created_at, updated_at
) VALUES
(
  'Venda criada por afiliado',
  'affiliate_sale_created_auto',
  'AFFILIATE_SALE_CREATED',
  'ALL',
  'ALL',
  '00:00:00',
  'America/Sao_Paulo',
  'EVENT',
  0,
  15,
  0,
  'HIGH',
  1,
  'Disparo automático quando o painel principal gera a cobrança vinculada ao afiliado da plataforma.',
  'Pagamento gerado',
  '{{affiliate_name}} trouxe um novo possível cliente. Plano {{plan_name}} - R$ {{sale_amount}}.',
  NULL,
  NULL,
  '/equipe/',
  1,
  NOW(),
  NOW()
),
(
  'Venda paga por afiliado',
  'affiliate_sale_paid_auto',
  'AFFILIATE_SALE_APPROVED',
  'ALL',
  'ALL',
  '00:00:00',
  'America/Sao_Paulo',
  'EVENT',
  0,
  15,
  0,
  'CRITICAL',
  1,
  'Disparo automático quando o webhook confirma o pagamento da venda vinculada ao afiliado da plataforma.',
  'Venda confirmada',
  '{{team_name}} confirmou uma venda do plano {{plan_name}} no valor de R$ {{sale_amount}}.',
  NULL,
  NULL,
  '/equipe/',
  1,
  NOW(),
  NOW()
),
(
  'Assinatura paga da loja',
  'store_subscription_paid_auto',
  'STORE_SUBSCRIPTION_PAID',
  'ALL',
  'ALL',
  '00:00:00',
  'America/Sao_Paulo',
  'EVENT',
  0,
  30,
  0,
  'HIGH',
  1,
  'Regra padrão para assinaturas pagas da loja.',
  'Loja ativada',
  'A assinatura da loja {{store_name}} foi confirmada e está ativa.',
  NULL,
  NULL,
  '/equipe/',
  1,
  NOW(),
  NOW()
);
