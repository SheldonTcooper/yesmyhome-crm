# 📋 GUIA DE INTEGRAÇÃO - CRM + Website YesMyHome

**Data**: 30/07/2026 | **Status**: Pronto para Integração

---

## 🎯 OBJETIVO

Integrar o site **yesmyhome.com.br** (Jetimob) com o **CRM Laravel** para que:
- ✅ Leads do site apareçam automaticamente no CRM
- ✅ SMS automático enviado para o cliente
- ✅ Email automático enviado para o cliente
- ✅ Admin vê lead em tempo real no Dashboard

---

## 📊 ARQUITETURA DA INTEGRAÇÃO

```
┌─────────────────────────────────────────────────────────────┐
│                    SITE YESMYHOME.COM.BR                     │
│                       (Jetimob Platform)                      │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Formulário de Contato / Solicitar Imóvel           │   │
│  │  → Nome, Email, Telefone, WhatsApp, Tipo Imóvel    │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                    │
│                   Webhook POST para:                          │
│              http://crm.seu-dominio.com/api/webhook/create-lead
│                                                               │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│                    CRM LARAVEL (Backend)                      │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  1. Recebe dados do webhook                          │  │
│  │  2. Cria lead no Node.js Backend                     │  │
│  │  3. Envia SMS via Twilio                             │  │
│  │  4. Envia Email via Resend                           │  │
│  │  5. Lead aparece no Dashboard                        │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                               │
│  Endpoints:                                                   │
│  - POST /api/webhook/create-lead (recebe do site)           │
│  - GET /dashboard (visualiza leads)                          │
│  - POST /api/webhook/send-message (envia mensagens)          │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## ❓ INFORMAÇÕES QUE VOCÊ PRECISA COLETAR

### **1. DO SITE (Jetimob)**

- [ ] **URL exato do site**: https://www.yesmyhome.com.br/
- [ ] **Plataforma**: Jetimob ✓ (confirmado)
- [ ] **Tem API disponível?** 
  - SIM → Qual documentação?
  - NÃO → Usar webhook?
- [ ] **Formulários existentes**:
  - [ ] Formulário "Solicitar Imóvel" - qual é a URL?
  - [ ] Formulário "Trabalhe Conosco" - qual é a URL?
  - [ ] Formulário "Contato" - qual é a URL?
  - [ ] Quais campos tem cada formulário?
- [ ] **Quem tem acesso ao painel do Jetimob?**
  - Nome/Email:
  - Senha: (não enviar, só confirmar que tem acesso)
- [ ] **Jetimob permite webhooks customizados?**
  - Pode fazer isso você, ou precisa contato da Jetimob?

---

### **2. DO CRM (Já configurado)**

✅ **Já temos:**
- Endpoint webhook pronto: `/api/webhook/create-lead`
- Banco de dados: Node.js Backend
- Mensageria: Twilio + Resend
- Dashboard: pronto
- API: pronta

❌ **Falta atualizar:**
- [ ] **Domínio do CRM**: 
  - Local: `http://localhost:8000`
  - Produção: `https://crm.seu-dominio.com` (qual é?)
  
- [ ] **Número Twilio brasileiro**:
  - Atual: +1 775 368 5844 (teste americano)
  - Precisa: +55 XX XXXX-XXXX (número real)
  - [ ] Já tem? SIM / NÃO
  - Se SIM, qual número?

- [ ] **Domínio de Email verificado**:
  - Atual: tauritecnologia.com.br (não verificado)
  - Precisa: verificar em https://resend.com/domains
  - [ ] Já fez? SIM / NÃO

---

## 📝 MAPEAMENTO DE CAMPOS

### **Dados que vêm do Site → Campos do CRM**

```
SITE JETIMOB              →    CRM LARAVEL
─────────────────             ────────────
Nome                      →    name
Email                     →    email
Telefone                  →    phone
WhatsApp                  →    whatsapp
Tipo de Imóvel            →    property_type
Tipo de Operação          →    operation_type
(Compra/Aluguel)
Mensagem/Observação       →    notes
Formulário de origem      →    source (qual formulário?)
Data/Hora                 →    created_at
```

---

## 🔧 OPÇÕES DE INTEGRAÇÃO

### **OPÇÃO 1: Webhook Direto (RECOMENDADO)**

**Como funciona:**
1. Adiciona um webhook no Jetimob
2. Quando form é enviado → POST para nosso endpoint
3. Dados chegam no CRM automaticamente

**Vantagens:**
- ✅ Tempo real
- ✅ Sem intermediários
- ✅ Sem custo extra
- ✅ Simples

**Desvantagens:**
- ❌ Precisa acesso ao painel Jetimob

**URL do webhook:**
```
https://crm.seu-dominio.com/api/webhook/create-lead
```

**Método:** POST

**Headers esperados:**
```json
{
  "Content-Type": "application/json"
}
```

**Payload esperado:**
```json
{
  "name": "João Silva",
  "email": "joao@email.com",
  "phone": "+5541999999999",
  "whatsapp": "+5541999999999",
  "property_type": "apartment",
  "operation_type": "sale"
}
```

---

### **OPÇÃO 2: Zapier/Make.com (ALTERNATIVA)**

**Como funciona:**
1. Configurar Zapier/Make para capturar form submit
2. Zapier envia POST para nosso webhook
3. Dados chegam no CRM

**Vantagens:**
- ✅ Não precisa mexer no código
- ✅ Suporte Zapier/Make
- ✅ Fácil configurar

**Desvantagens:**
- ❌ Custo mensal (~$20-30)
- ❌ Latência pequena

**Requer:**
- [ ] Conta Zapier/Make
- [ ] Conhecer campos do formulário Jetimob

---

### **OPÇÃO 3: Código HTML Customizado**

Se o Jetimob permitir, inserir um formulário customizado que envie direto para o CRM.

**Requer:**
- [ ] Acesso HTML do site
- [ ] Permissão para inserir scripts

---

## ✅ CHECKLIST - O QUE FAZER AGORA

### **Fase 1: Coleta de Informações (HOJE)**

- [ ] Verificar qual é o domínio do CRM em produção
- [ ] Comprar número Twilio brasileiro (R$20/mês)
- [ ] Verificar domínio no Resend (https://resend.com/domains)
- [ ] Acessar painel do Jetimob
- [ ] Documentar todos os formulários do site
- [ ] Documentar campos de cada formulário

### **Fase 2: Setup Twilio (HOJE)**

1. Ir em https://www.twilio.com/console
2. Comprar número brasileiro
3. Atualizar `.env`:
   ```
   TWILIO_PHONE="+55 41 XXXX-XXXX"
   ```

### **Fase 3: Verificar Domínio Resend (HOJE)**

1. Ir em https://resend.com/domains
2. Adicionar domínio: tauritecnologia.com.br
3. Seguir instruções de DNS
4. Quando verificado, emails funcionam automaticamente

### **Fase 4: Configurar Webhook (AMANHÃ)**

**No Jetimob:**
1. Ir em painel → Webhooks / Integrações
2. Adicionar novo webhook
3. URL: `https://crm.seu-dominio.com/api/webhook/create-lead`
4. Método: POST
5. Quando: ao enviar formulário de contato
6. Testar webhook

**No CRM:**
1. Webhook já está pronto
2. Testar com: `/demo-integracao.html`

### **Fase 5: Teste End-to-End (AMANHÃ)**

1. Abrir site yesmyhome.com.br
2. Preencher formulário de contato
3. Verificar:
   - [ ] Lead aparece no Dashboard
   - [ ] SMS recebido no WhatsApp
   - [ ] Email recebido na caixa de entrada
4. Se OK → Ir para produção

---

## 📞 INFORMAÇÕES A FORNECER

Para eu ajudar na integração, me envie:

```
SITE:
- [ ] URL completa do site
- [ ] Nome de usuário Jetimob
- [ ] Formulários existentes (URLs)
- [ ] Campo de cada formulário

CRM:
- [ ] Domínio em produção (https://...)
- [ ] Já tem número Twilio brasileiro? Qual?
- [ ] Já verificou domínio Resend? Qual status?

CONTATO:
- [ ] Seu email para testes
- [ ] Seu WhatsApp para testes (com +55)
- [ ] Que tipo de lead capturar? (todos? só contato?)
```

---

## 🚀 PRÓXIMOS PASSOS

1. **Reúna as informações acima**
2. **Configure Twilio + Resend**
3. **Configure webhook no Jetimob**
4. **Faça teste end-to-end**
5. **Coloque em produção**

---

## 📞 SUPORTE

Se tiver dúvidas sobre qualquer passo, é só chamar! ✋

Aqui está tudo pronto, só falta integrar com o site.
