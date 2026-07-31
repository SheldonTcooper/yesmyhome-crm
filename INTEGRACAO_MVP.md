# 🚀 Integração Laravel CRM + Node.js Backend - MVP

## ✅ Status Atual

- ✅ Laravel CRM 12 configurado
- ✅ Node.js Backend (YesMyHome) rodando
- ✅ Twilio + Resend integrados
- ✅ APIs conectadas

---

## 📋 Endpoints Disponíveis

### Base URL
```
http://localhost/api/integration
```

### 1. Criar Lead
```bash
POST /leads

{
  "name": "Maria Silva",
  "email": "maria@email.com",
  "phone": "+5511988776655",
  "whatsapp": "+5511987654321",
  "property_type": "chácara",
  "operation_type": "sale",
  "source": "website"
}

Response: 201 Created
```

### 2. Listar Todos os Leads
```bash
GET /leads

Response: 200 OK
[
  {
    "id": 1,
    "name": "Maria Silva",
    "email": "maria@email.com",
    "status": "novo",
    ...
  }
]
```

### 3. Ver Detalhes de um Lead
```bash
GET /leads/1

Response: 200 OK
{
  "id": 1,
  "name": "Maria Silva",
  "email": "maria@email.com",
  "automations": [...]
}
```

### 4. Atualizar Status do Lead
```bash
PUT /leads/1/status

{
  "status": "contactado"
}

Status válidos: novo, contactado, visitado, proposta, fechado, perdido

Response: 200 OK
```

### 5. Enviar Mensagem (Email ou WhatsApp)
```bash
POST /leads/1/send-message

{
  "channel": "whatsapp",
  "message": "🏠 Olá! Encontramos uma chácara perfeita para você!"
}

Channel: "email" ou "whatsapp"

Response: 200 OK
```

### 6. Obter Estatísticas
```bash
GET /dashboard/stats

Response: 200 OK
{
  "totalLeads": 10,
  "newLeads": 3,
  "contactedLeads": 5,
  "automationsSent": 25
}
```

### 7. Health Check (Verificar conectividade)
```bash
GET /health

Response: 200 OK
{
  "success": true,
  "backend_online": true,
  "message": "Backend conectado!"
}
```

---

## 🧪 Teste Rápido com cURL

### 1. Criar Lead de Teste
```bash
curl -X POST http://localhost/api/integration/leads \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "+5511999999999",
    "whatsapp": "+5511999999999",
    "property_type": "casa",
    "operation_type": "sale",
    "source": "crm"
  }'
```

### 2. Listar Leads
```bash
curl http://localhost/api/integration/leads
```

### 3. Atualizar Status
```bash
curl -X PUT http://localhost/api/integration/leads/1/status \
  -H "Content-Type: application/json" \
  -d '{"status": "contactado"}'
```

### 4. Enviar WhatsApp
```bash
curl -X POST http://localhost/api/integration/leads/1/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "whatsapp",
    "message": "Olá! Temos uma ótima oportunidade para você!"
  }'
```

### 5. Verificar Saúde
```bash
curl http://localhost/api/integration/health
```

---

## 🔧 Como Usar no Seu App/Frontend

### JavaScript/React
```javascript
// Criar lead
const response = await fetch('http://localhost/api/integration/leads', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    name: 'Maria',
    email: 'maria@email.com',
    phone: '+5511988776655',
    whatsapp: '+5511988776655',
    property_type: 'chácara',
    operation_type: 'sale',
    source: 'website'
  })
});

const data = await response.json();
console.log(data);
```

### Python
```python
import requests

url = "http://localhost/api/integration/leads"
payload = {
    "name": "Maria",
    "email": "maria@email.com",
    "phone": "+5511988776655",
    "whatsapp": "+5511988776655",
    "property_type": "chácara",
    "operation_type": "sale",
    "source": "website"
}

response = requests.post(url, json=payload)
print(response.json())
```

---

## 📊 Fluxo Completo

1. **Lead entra no site/formulário**
   ↓
2. **Dados enviados para CRM** (POST /api/integration/leads)
   ↓
3. **CRM sincroniza com Node.js Backend**
   ↓
4. **Backend envia Email + WhatsApp automáticos**
   ↓
5. **Vendedor vê lead no CRM e pode**:
   - Atualizar status
   - Enviar mensagens diretas
   - Ver automações executadas
   ↓
6. **Dados sincronizados em tempo real**

---

## ⚙️ Arquitetura

```
┌─────────────────┐
│  Website/App    │
└────────┬────────┘
         │ POST /leads
         ▼
┌─────────────────────────────┐
│  Laravel CRM (Porta 80)     │
│  ├─ Gerenciamento de Leads  │
│  ├─ Interface Admin         │
│  └─ API Integration         │
└────────┬────────────────────┘
         │ HTTP API
         ▼
┌─────────────────────────────┐
│ Node.js Backend (Porta 5000)│
│ ├─ Database (PostgreSQL)    │
│ ├─ Twilio (SMS/WhatsApp)    │
│ ├─ Resend (Email)           │
│ └─ Cron Jobs                │
└─────────────────────────────┘
```

---

## 🔐 Segurança (Para Produção)

⚠️ **Antes de colocar em produção:**

1. Adicionar autenticação (JWT/Bearer Token)
2. Validar origem das requisições (CORS)
3. Rate limiting
4. HTTPS obrigatório
5. Validação de dados rigorosa

---

## 📱 Teste no Postman

**Importe esta coleção:**

```json
{
  "info": {
    "name": "YesMyHome Integration",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Create Lead",
      "request": {
        "method": "POST",
        "url": "http://localhost/api/integration/leads",
        "body": {
          "mode": "raw",
          "raw": "{\"name\": \"Test\", \"email\": \"test@email.com\"}"
        }
      }
    }
  ]
}
```

---

## 🐛 Troubleshooting

### Erro: "Backend offline"
- Verificar se Node.js está rodando: `node src/server.js`
- Verificar porta 5000: `netstat -ano | findstr :5000`

### Erro: "Email não enviado"
- Verificar RESEND_API_KEY no .env
- Verificar logs: `tail -f storage/logs/laravel.log`

### Erro: "WhatsApp não enviado"
- Verificar credenciais Twilio
- Verificar se número está em formato correto

---

## ✅ Checklist MVP

- [x] Laravel CRM instalado e migrado
- [x] Node.js Backend rodando
- [x] Twilio configurado
- [x] Resend configurado
- [x] APIs integradas
- [x] Documentação pronta
- [ ] Testes com cliente

---

## 📞 Próximos Passos

1. Testar todos os endpoints
2. Criar Dashboard visual no CRM
3. Implementar webhook para sincronização em tempo real
4. Adicionar autenticação
5. Deploy em produção

---

**Status:** 🟢 **PRONTO PARA APRESENTAÇÃO MVP**

Criado em: 30/07/2026
