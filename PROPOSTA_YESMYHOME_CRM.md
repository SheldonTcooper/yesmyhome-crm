# PROPOSTA COMERCIAL
## CRM YesMyHome + Integração de Mensageria e IA

**Empresa:** Tauri Tecnologia  
**Cliente:** YesMyHome Negociações Imobiliárias LTDA  
**Data:** 30 de julho de 2026  
**CRECI:** J05989  
**Período de Validade:** 30 dias

---

## 📋 SUMÁRIO EXECUTIVO

A YesMyHome opera um negócio imobiliário que gera leads através de múltiplos canais (site, WhatsApp, telefone). Atualmente, não existe um sistema centralizado para gerenciar esses leads, resultando em perda de oportunidades e falta de follow-up automático.

**Solução Proposta:** Implementar um CRM integrado com automação de mensageria (SMS, WhatsApp, Email) e IA para qualificação e análise de leads.

**Benefícios:**
- ✅ Centralizar todos os leads em um único painel
- ✅ Resposta automática aos clientes (SMS + Email)
- ✅ Recuperação de leads esquecidos (Remarketing)
- ✅ Análise inteligente com IA (score de lead, previsão de conversão)
- ✅ Redução de 60-70% do tempo de resposta
- ✅ Aumento estimado de 25-35% na taxa de conversão

---

## 🎯 CENÁRIO 1: INTEGRAÇÃO COM SITE ATUAL

### 1.1 Descrição

Integrar o CRM com o site yesmyhome.com.br (Jetimob) mantendo a plataforma atual e adicionando automação de leads, mensageria e IA.

**Escopo:**
- Integração com formulários existentes (Jetimob)
- Dashboard de gerenciamento de leads
- Automação de SMS + Email + WhatsApp
- IA para qualificação de leads
- Remarketing automático (Email/SMS)

### 1.2 Arquitetura Técnica

```
SITE ATUAL (Jetimob)
        ↓ (Webhook)
CRM LARAVEL (localhost:8000)
        ↓
NODE.JS BACKEND (port 5000)
        ↓
BANCO DE DADOS SQLITE
```

**Componentes:**
1. **CRM Laravel** - Gerenciamento de leads
2. **Node.js Backend** - Processamento de dados
3. **Twilio** - SMS e WhatsApp
4. **Resend** - Email automático
5. **Claude IA API** - Análise de leads
6. **Dashboard Web** - Interface admin

### 1.3 Funcionalidades Incluídas

#### ✅ Gerenciamento de Leads
- Criar/editar/deletar leads
- Visualizar histórico completo
- Tags e categorias customizadas
- Status (Novo → Conversando → Fechado)
- Campo de notas internas
- Atribuição a agentes

#### ✅ Automação de Mensageria
- SMS automático ao criar lead (via Twilio)
- Email automático de boas-vindas (via Resend)
- WhatsApp automático com link de contato
- Sequências de follow-up automático (24h, 48h, 72h)
- Templates customizáveis
- Agendamento de mensagens

#### ✅ Remarketing Automático
- Email de reengajamento para leads inativos (7 dias)
- SMS com oferta especial
- Funil automático de recuperação
- Score de propensão de compra

#### ✅ IA Integrada
- Análise de lead em tempo real (Claude API)
- Score automático (0-100)
- Detecção de padrão de compra
- Resposta automática inicial via IA
- Sugestão de próximo passo
- Previsão de taxa de conversão

#### ✅ Relatórios e Análise
- Dashboard com KPIs em tempo real
- Gráficos de leads por fonte
- Taxa de conversão por agente
- ROI de campanhas
- Relatório mensal automático

### 1.4 Orçamento Cenário 1

#### **IMPLEMENTAÇÃO (One-time)**

| Item | Valor |
|------|-------|
| Configuração CRM + Integração Jetimob | R$ 3.000 |
| Setup Twilio Brasil + Verificação | R$ 500 |
| Setup Resend + Verificação Domínio | R$ 300 |
| Integração Claude IA API | R$ 1.200 |
| Dashboard Admin + UI/UX | R$ 2.500 |
| Configuração Webhooks | R$ 800 |
| Testes + QA | R$ 1.000 |
| Deploy + SSL Certificates | R$ 700 |
| Documentação + Treinamento | R$ 600 |
| **SUBTOTAL IMPLEMENTAÇÃO** | **R$ 10.600** |

#### **CUSTOS MENSAIS RECORRENTES**

| Serviço | Uso | Valor/Mês |
|---------|-----|-----------|
| **Twilio SMS** | 500 SMS/mês | R$ 150 |
| **Twilio WhatsApp** | 200 msgs/mês | R$ 100 |
| **Resend Email** | 5.000 emails/mês | R$ 0 (free) |
| **Claude IA API** | ~1.000 análises/mês | R$ 150 |
| **Hosting Laravel** | AWS/DigitalOcean | R$ 100 |
| **Domínio (.com.br)** | Anual ÷ 12 | R$ 30 |
| **SSL Certificate** | Anual ÷ 12 | R$ 10 |
| **Backup Automático** | Cloud Storage | R$ 30 |
| **Monitoramento 24/7** | Uptime Monitoring | R$ 20 |
| **SUBTOTAL MENSAL** | | **R$ 590** |

#### **CUSTOS ANUAIS**

| Item | Valor |
|------|-------|
| Implementação One-time | R$ 10.600 |
| Custos Mensais (12 meses) | R$ 7.080 |
| **TOTAL CENÁRIO 1** | **R$ 17.680** |

**Custo/Mês (amortizado):** R$ 1.473  
**ROI esperado:** 4-6 meses (economia com atendimento + aumento conversão)

---

## 🎯 CENÁRIO 2: SITE NOVO + CRM INTEGRADO

### 2.1 Descrição

Criar um novo site moderno (NextJS/React) integrado nativamente com o CRM, mantendo o domínio yesmyhome.com.br e descontinuando a plataforma Jetimob.

**Escopo:**
- Novo site responsivo + SEO otimizado
- CRM integrado nativamente
- Automação de mensageria
- IA para qualificação
- Remarketing automático
- Blog integrado
- Área do cliente
- Admin dashboard

### 2.2 Arquitetura Técnica

```
NOVO SITE (NextJS/React)
        ↓ (API nativa)
CRM LARAVEL (Backend unified)
        ↓
NODE.JS BACKEND (port 5000)
        ↓
POSTGRESQL DATABASE
```

**Componentes:**
1. **Site Novo** - NextJS Frontend
2. **CRM Laravel** - API + Backend
3. **Node.js Backend** - Processamento
4. **PostgreSQL** - Banco de dados
5. **Twilio** - Mensageria
6. **Resend** - Email
7. **Claude IA API** - Inteligência
8. **CDN Cloudflare** - Performance
9. **Analytics** - Rastreamento

### 2.3 Funcionalidades Incluídas

#### ✅ Website Novo
- Design responsivo (Mobile/Tablet/Desktop)
- SEO otimizado (meta tags, sitemap, schema markup)
- Performance otimizada (Core Web Vitals)
- Página de listagem de imóveis
- Filtros avançados (preço, tipo, bairro)
- Detalhe de imóvel com fotos/vídeo
- CMS para gerenciar conteúdo
- Blog integrado (notícias + dicas)
- Formulários de contato estratégicos
- Chat de atendimento em tempo real
- WhatsApp flutuante

#### ✅ CRM Integrado
- Todos os itens do Cenário 1 +
- Integração nativa (sem webhooks)
- Gerenciamento de imóveis
- Relacionamento com leads
- Pipeline de vendas visual (Kanban)
- Histórico completo de interação

#### ✅ Automação Avançada
- Seqências de email personalizadas
- Mensagens baseadas em comportamento
- Agendamento de visitas automático
- Confirmação de agendamento via SMS
- Lembrete 24h antes da visita
- Pesquisa de satisfação pós-visita

#### ✅ IA Integrada
- Chatbot IA para atendimento inicial
- Qualificação automática de leads
- Recomendação de imóvel (baseado em preferência)
- Score de propensão de compra
- Previsão de price point ideal
- Análise de competidor

#### ✅ Análise e Relatórios
- Dashboard executivo
- Análise por agente
- Análise por campanha
- Previsão de receita
- Relatório de NPS
- Exportação de dados

### 2.4 Orçamento Cenário 2

#### **IMPLEMENTAÇÃO (One-time)**

| Item | Valor |
|------|-------|
| Design UI/UX - 5 telas principais | R$ 3.000 |
| Desenvolvimento Frontend NextJS | R$ 8.000 |
| Integração com CRM Laravel | R$ 3.500 |
| Desenvolvimento Backend APIs | R$ 4.000 |
| Setup PostgreSQL + Migrações | R$ 1.500 |
| Twilio + Resend + IA Setup | R$ 1.500 |
| Implementação Claude IA avançada | R$ 2.000 |
| SEO + Performance Optimization | R$ 1.500 |
| Testes QA + Staging | R$ 1.500 |
| Deploy + CI/CD Pipeline | R$ 1.500 |
| SSL + DNS + CDN Setup | R$ 800 |
| Migração de dados (se houver) | R$ 1.000 |
| Treinamento + Documentação | R$ 1.200 |
| Suporte pós-launch (1 mês) | R$ 1.500 |
| **SUBTOTAL IMPLEMENTAÇÃO** | **R$ 33.700** |

#### **CUSTOS MENSAIS RECORRENTES**

| Serviço | Uso | Valor/Mês |
|---------|-----|-----------|
| **Twilio SMS** | 500 SMS/mês | R$ 150 |
| **Twilio WhatsApp** | 200 msgs/mês | R$ 100 |
| **Resend Email** | 10.000 emails/mês | R$ 0 (free) |
| **Claude IA API** | ~2.000 análises/mês | R$ 300 |
| **Hosting (AWS/Vercel)** | - | R$ 200 |
| **PostgreSQL RDS** | - | R$ 100 |
| **CDN Cloudflare** | - | R$ 30 |
| **Domínio (.com.br)** | Anual ÷ 12 | R$ 30 |
| **SSL Certificate** | Anual ÷ 12 | R$ 10 |
| **Backup Automático** | Cloud Storage | R$ 50 |
| **Monitoramento 24/7** | Uptime + Performance | R$ 40 |
| **Analytics & Tracking** | Google Analytics 4 | R$ 0 (free) |
| **Manutenção Mensal** | Patches + Updates | R$ 150 |
| **SUBTOTAL MENSAL** | | **R$ 1.160** |

#### **CUSTOS ANUAIS**

| Item | Valor |
|------|-------|
| Implementação One-time | R$ 33.700 |
| Custos Mensais (12 meses) | R$ 13.920 |
| **TOTAL CENÁRIO 2** | **R$ 47.620** |

**Custo/Mês (amortizado):** R$ 3.968  
**ROI esperado:** 6-9 meses (novo site + leads automáticos + aumento conversão)

---

## 📊 COMPARAÇÃO CENÁRIOS

| Aspecto | Cenário 1 | Cenário 2 |
|--------|----------|----------|
| **Investimento Inicial** | R$ 10.600 | R$ 33.700 |
| **Custo Mensal** | R$ 590 | R$ 1.160 |
| **Custo Anual Total** | R$ 17.680 | R$ 47.620 |
| **Tempo Implementação** | 2-3 semanas | 6-8 semanas |
| **Break-even** | 4-6 meses | 6-9 meses |
| **Manutenção Site** | Terceirizado | Incluído |
| **SEO** | Jetimob (limitado) | Otimizado |
| **Performance** | Boa | Excelente |
| **Customização** | Limitada | Ilimitada |
| **Escalabilidade** | Média | Alta |

---

## 💡 RECOMENDAÇÃO

**Cenário 1** é ideal se:
- ✅ Orçamento limitado
- ✅ Quer resultado rápido (2-3 semanas)
- ✅ Site atual funciona bem
- ✅ Foco só em automação de leads

**Cenário 2** é ideal se:
- ✅ Quer presença digital modernizada
- ✅ SEO é prioridade
- ✅ Quer controle total do site
- ✅ Crescimento de longo prazo
- ✅ Diferenciação competitiva

**Recomendação da Tauri:** **Cenário 2**
- ROI melhor no longo prazo
- Site como diferencial competitivo
- Integração perfeita com CRM
- Reduz dependência de terceiros

---

## 🚀 TIMELINE

### **Cenário 1**
```
Semana 1: Coleta de requisitos + Setup Twilio + Resend
Semana 2: Integração Jetimob + Desenvolvimento Dashboard
Semana 3: IA + Testes + Deploy
Semana 4: Treinamento + Go-live
```

### **Cenário 2**
```
Semana 1-2: Design + Arquitetura
Semana 3-5: Desenvolvimento Frontend + Backend
Semana 6: Integração com CRM + Testes
Semana 7-8: Otimizações + Deploy + Treinamento
```

---

## ✅ PRÓXIMOS PASSOS

1. **Revisar proposta** (você)
2. **Decidir cenário** (Cenário 1 ou 2)
3. **Confirmar informações**:
   - [ ] Email para contato
   - [ ] WhatsApp para testes
   - [ ] Quem é o gestor do projeto
4. **Assinatura de contrato**
5. **Início do desenvolvimento**

---

## 📞 CONTATO

**Tauri Tecnologia**  
📧 romulo@tauritecnologia.com.br  
📱 (41) 98519-7035  
🌐 https://tauritecnologia.com.br

---

## 📋 ANEXOS INCLUSOS

- Guia de Integração Técnica
- Especificação Funcional Detalhada
- Diagrama de Arquitetura
- Contrato de Serviço
- SLA e Termos de Suporte

---

**Validade da Proposta:** 30 dias  
**Data de Emissão:** 30/07/2026

---

*Esta proposta é confidencial e destinada apenas ao uso do cliente indicado.*
