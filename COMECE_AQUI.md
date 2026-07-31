# 🚀 Comece Aqui - MVP YesMyHome CRM

## ⚡ 5 Minutos para Começar

### 1️⃣ Inicie o Node.js Backend

Abra um terminal/PowerShell e execute:

```powershell
cd "C:\Users\romul\Desktop\yesmyhome-backend"
node src/server.js
```

Você deve ver:
```
✅ Database initialized
✅ Cron jobs iniciados
🚀 Backend rodando em http://localhost:5000
```

**⚠️ DEIXE ESTE TERMINAL ABERTO!**

---

### 2️⃣ Inicie o Laravel CRM

Abra OUTRO terminal e execute:

```powershell
cd "C:\Users\romul\Desktop\laravel-crm-2.2"
php artisan serve
```

Você deve ver:
```
INFO  Server running on [http://127.0.0.1:8000]
```

---

### 3️⃣ Teste o Sistema

Abra um TERCEIRO terminal e execute o script de teste:

```powershell
cd "C:\Users\romul\Desktop\laravel-crm-2.2"
.\TESTE_MVP.ps1
```

Você verá:
```
✅ Backend online
✅ Lead criado com sucesso
✅ WhatsApp enviado
✅ Email enviado
✅ TESTE COMPLETO EXECUTADO!
```

---

### 4️⃣ Use os Endpoints

Acesse qualquer um desses endpoints no seu navegador ou via curl:

```bash
# Criar Lead
curl -X POST http://localhost/api/integration/leads \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@email.com"}'

# Listar Leads
curl http://localhost/api/integration/leads

# Health Check
curl http://localhost/api/integration/health
```

---

## 📊 Arquitetura

```
┌─────────────────┐
│  Seu Frontend   │ (Website, App)
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│  Laravel CRM (8000)     │ ← Gerencia leads
│  /api/integration       │ ← Sincroniza com backend
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│  Node.js Backend (5000) │ ← Envia SMS/Email
│  Twilio + Resend        │ ← Automações
└─────────────────────────┘
```

---

## 🔗 Links Úteis

| Nome | URL | Descrição |
|------|-----|-----------|
| **Laravel CRM** | http://localhost:8000 | Interface de gerenciamento |
| **API Endpoints** | http://localhost:8000/api/integration | Endpoints da API |
| **Node.js Backend** | http://localhost:5000 | Backend direto |
| **Documentação** | `INTEGRACAO_MVP.md` | Guia completo dos endpoints |

---

## 📱 Testar via Postman ou cURL

### Criar Lead
```bash
curl -X POST http://localhost/api/integration/leads \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "+5511999999999",
    "whatsapp": "+5511999999999",
    "property_type": "chácara",
    "operation_type": "sale"
  }'
```

### Listar Leads
```bash
curl http://localhost/api/integration/leads
```

### Atualizar Status
```bash
curl -X PUT http://localhost/api/integration/leads/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "contactado"}'
```

### Enviar WhatsApp
```bash
curl -X POST http://localhost/api/integration/leads/1/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "whatsapp",
    "message": "Olá! Temos uma oportunidade para você!"
  }'
```

---

## 🐛 Troubleshooting

### Erro: "Backend offline"
```powershell
# Verificar se Node.js está rodando
netstat -ano | findstr :5000

# Se não estiver, inicie:
cd "C:\Users\romul\Desktop\yesmyhome-backend"
node src/server.js
```

### Erro: "Laravel não encontrado"
```powershell
# Verificar se Laravel está rodando
netstat -ano | findstr :8000

# Se não estiver, inicie:
cd "C:\Users\romul\Desktop\laravel-crm-2.2"
php artisan serve
```

### Erro: "Email/WhatsApp não enviado"
- Verificar credenciais Twilio em `.env`
- Verificar API Key Resend em `.env`
- Ver logs: `storage/logs/laravel.log`

---

## ✅ Checklist para Apresentação

- [ ] Node.js Backend rodando (porta 5000)
- [ ] Laravel CRM rodando (porta 8000)
- [ ] Script de teste executado com sucesso
- [ ] Criar um lead via API
- [ ] Verificar se chegou WhatsApp/Email
- [ ] Mostrar dashboard com estatísticas
- [ ] Explicar fluxo de sincronização

---

## 🎯 Próximos Passos

1. **Testar com mais leads** - Criar 5-10 leads para demonstrar
2. **Mostrar automações** - Mostrar WhatsApp e Email sendo enviados
3. **Explicar sincronização** - Como os dados fluem entre sistemas
4. **Customizações** - O que pode ser customizado para o cliente

---

## 📞 Suporte

Se algo não funcionar:
1. Verificar se ambos servidores estão rodando
2. Verificar logs em `storage/logs/laravel.log`
3. Verificar configurações no `.env`
4. Ler `INTEGRACAO_MVP.md` para mais detalhes

---

**Status:** 🟢 **PRONTO PARA MVP**

Criado em: 30/07/2026
Versão: 1.0 (MVP)
