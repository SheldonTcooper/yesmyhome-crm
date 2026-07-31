# 🚀 Deploy no Render.com - YesMyHome CRM

## ✅ Pré-requisitos

- Conta GitHub (grátis)
- Conta Render.com (grátis)
- Este repositório

---

## 📋 PASSO A PASSO (5 minutos)

### **1️⃣ Fazer Push para GitHub**

```bash
cd C:\Users\romul\Desktop\laravel-crm-2.2

# Inicializar Git (se não tiver)
git init

# Adicionar arquivo render.yaml
git add render.yaml Dockerfile docker-compose.yml .env.example

# Commit
git commit -m "Add Render deployment config"

# Fazer push (crie repo no GitHub primeiro)
git push origin main
```

### **2️⃣ Conectar ao Render.com**

1. Acesse: https://render.com
2. Clique em **"Sign up with GitHub"**
3. Autorize o Render
4. Clique em **"New +"** → **"Web Service"**
5. Selecione seu repositório do GitHub

### **3️⃣ Configurar Deploy**

No formulário do Render:

```
Name: yesmyhome-crm
Environment: Docker
Region: Oregon (FREE)
Branch: main
```

### **4️⃣ Ambiente (Environment Variables)**

Adicione no Render:

```
APP_NAME=YesMyHome CRM
APP_ENV=production
APP_DEBUG=false
APP_KEY=[deixar vazio, será gerado]
APP_URL=https://yesmyhome-crm.onrender.com
DB_CONNECTION=sqlite
```

### **5️⃣ Deploy**

Clique em **"Deploy"**

Aguarde 3-5 minutos...

✅ Quando ficar verde, acesse:

```
https://yesmyhome-crm.onrender.com
```

---

## 🎯 RESULTADO

Seu cliente vai poder acessar:

```
https://yesmyhome-crm.onrender.com
https://yesmyhome-crm.onrender.com/demo-integracao.html
```

De **qualquer lugar**, de **qualquer dispositivo**! 📱💻

---

## ⚠️ LIMITAÇÕES (Plano Free)

- ⏱️ Projeto "dorme" após 15 min sem uso (acorda em 2-3 seg)
- 💾 Dados não persistem (resetam diariamente)
- 🔄 Não tem backup automático

**Para produção:** Upgrade para pago (~$7/mês)

---

## 🔄 Auto-Deploy

Depois de conectar, **qualquer push no GitHub** dispara novo deploy automaticamente!

```bash
git add .
git commit -m "Update CRM"
git push origin main
# Render faz deploy automaticamente em 2-3 min
```

---

## 📞 Se Não Funcionar

Verifique:
1. GitHub repo é público?
2. `render.yaml` está na raiz?
3. Dockerfile existe?
4. Você tem conta Render ativa?

---

**Pronto! Você tem um MVP online! 🎉**
