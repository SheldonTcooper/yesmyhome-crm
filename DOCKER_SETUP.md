# 🐳 Docker Setup - YesMyHome CRM

## ✅ Pré-requisitos

- Docker instalado (Docker Desktop para Windows)
- Docker Compose instalado

## 🚀 COMEÇAR (3 comandos)

### 1️⃣ Build da imagem (primeira vez)
```bash
cd C:\Users\romul\Desktop\laravel-crm-2.2
docker-compose build
```

### 2️⃣ Iniciar os containers (deixar rodando)
```bash
docker-compose up -d
```

### 3️⃣ Acessar a aplicação
```
http://localhost:8000
```

---

## 📊 Monitorar Status

Ver logs em tempo real:
```bash
docker-compose logs -f app
```

Ver containers rodando:
```bash
docker-compose ps
```

Ver espaço em disco:
```bash
docker system df
```

---

## 🛑 Parar Containers

Parar (deixa dados salvos):
```bash
docker-compose down
```

Limpar tudo (cuidado):
```bash
docker-compose down -v
```

---

## 🔄 Reiniciar

Depois que para, para rodar de novo:
```bash
docker-compose up -d
```

---

## ✨ O QUE FOI CONFIGURADO

✅ **PHP 8.2-FPM** - Runtime PHP
✅ **Nginx** - Web Server
✅ **Supervisor** - Gerencia processos
✅ **SQLite** - Banco de dados (local)
✅ **PostgreSQL** - Banco opcional (comentado)
✅ **Nginx conf** - CORS habilitado, cache estático, segurança
✅ **Health Check** - Auto-restart se falhar
✅ **Restart Policy** - Always (reinicia quando PC liga)
✅ **Logs** - Salva logs de erros

---

## 🌍 Acessar de Outro PC (na mesma rede)

Se seu PC é `192.168.1.100`:

```
http://192.168.1.100:8000
```

---

## 📱 Mostrar para Cliente

Seu cliente acessa via:
```
http://[seu-ip]:8000
```

Exemplo:
```
http://192.168.1.50:8000
```

---

## ⚠️ Possíveis Problemas

### Porta 8000 já em uso
```bash
# Liberar a porta
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Sem acesso à porta 8000
Fazer firewall liberar a porta 8000.

### Container não sobe
```bash
docker-compose logs app
# Ver erro e corrigir
```

### Limpeza total (resetar)
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d
```

---

## 🎯 RESUMO

- ✅ **Roda 24/7** (enquanto Docker Desktop está aberto)
- ✅ **Restart automático** se cair
- ✅ **Auto-start** quando PC liga (com Docker Desktop ativo)
- ✅ **Profissional** para mostrar ao cliente
- ✅ **Escalável** para adicionar mais containers depois

**Pronto!** 🚀
