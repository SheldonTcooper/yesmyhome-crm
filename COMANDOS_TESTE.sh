#!/bin/bash

# Script de teste para migrações SQLite
# Uso: bash COMANDOS_TESTE.sh

echo ""
echo "================================================================================"
echo "TESTE DE MIGRAÇÕES SQLITE"
echo "================================================================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Limpar cache
echo -e "${YELLOW}1. Limpando cache...${NC}"
php artisan config:clear
php artisan cache:clear
composer dump-autoload
echo -e "${GREEN}✅ Cache limpo${NC}"
echo ""

# 2. Backup do banco atual
echo -e "${YELLOW}2. Fazendo backup do banco SQLite...${NC}"
if [ -f "database/database.sqlite" ]; then
    cp database/database.sqlite database/database.sqlite.backup
    echo -e "${GREEN}✅ Backup criado: database/database.sqlite.backup${NC}"
else
    echo -e "${YELLOW}ℹ️  Banco SQLite não existe (primeiro teste)${NC}"
fi
echo ""

# 3. Configurar para SQLite
echo -e "${YELLOW}3. Configurando .env para SQLite...${NC}"
# Backup do .env
cp .env .env.backup.mysql

# Substituir configurações
sed -i 's/DB_CONNECTION=.*/DB_CONNECTION=sqlite/' .env
sed -i 's/DB_DATABASE=.*/DB_DATABASE=\/full\/path\/to\/database\/database.sqlite/' .env

echo -e "${GREEN}✅ .env configurado para SQLite${NC}"
echo -e "${YELLOW}   Verifique se DB_DATABASE está correto: database/database.sqlite${NC}"
echo ""

# 4. Remover banco antigo
echo -e "${YELLOW}4. Removendo banco SQLite antigo...${NC}"
rm -f database/database.sqlite
echo -e "${GREEN}✅ Banco antigo removido${NC}"
echo ""

# 5. Rodar migrações
echo -e "${YELLOW}5. Executando migrações com SQLite...${NC}"
php artisan migrate:fresh --seed

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ SUCESSO! Migrações rodaram sem erros${NC}"
    echo ""

    # 6. Verificar status
    echo -e "${YELLOW}6. Status das migrações:${NC}"
    php artisan migrate:status
    echo ""

    echo -e "${GREEN}✅ TESTE SQLITE PASSOU${NC}"

else
    echo ""
    echo -e "${RED}❌ ERRO nas migrações!${NC}"
    echo ""
    echo "Verifique os erros acima e consulte:"
    echo "  - MIGRATION_SQLITE_FIX.md"
    echo "  - DETAILED_CHANGES.md"
    exit 1
fi

echo ""
echo "================================================================================"
echo "AGORA TESTE COM MYSQL PARA CONFIRMAR QUE NÃO QUEBROU"
echo "================================================================================"
echo ""

# 7. Restaurar .env para MySQL
echo -e "${YELLOW}7. Restaurando .env para MySQL...${NC}"
cp .env.backup.mysql .env
echo -e "${GREEN}✅ .env restaurado para MySQL${NC}"
echo ""

# 8. Limpar cache novamente
echo -e "${YELLOW}8. Limpando cache...${NC}"
php artisan config:clear
composer dump-autoload
echo -e "${GREEN}✅ Cache limpo${NC}"
echo ""

# 9. Rodar migrações em MySQL
echo -e "${YELLOW}9. Executando migrações com MySQL...${NC}"
php artisan migrate:fresh --seed

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ SUCESSO! Migrações MySQL também funcionam${NC}"
    echo ""

    # 10. Verificar status
    echo -e "${YELLOW}10. Status das migrações:${NC}"
    php artisan migrate:status
    echo ""

    echo -e "${GREEN}✅ TESTE MYSQL PASSOU${NC}"

else
    echo ""
    echo -e "${RED}❌ ERRO nas migrações MySQL!${NC}"
    echo ""
    echo "Verifique os erros acima e consulte:"
    echo "  - MIGRATION_SQLITE_FIX.md"
    echo "  - DETAILED_CHANGES.md"
    exit 1
fi

echo ""
echo "================================================================================"
echo -e "${GREEN}✅ TODOS OS TESTES PASSARAM${NC}"
echo "================================================================================"
echo ""
echo "Próximos passos:"
echo "  1. Verificar que a aplicação inicia: php artisan tinker"
echo "  2. Fazer commit das mudanças: git add . && git commit -m '...'"
echo "  3. Push para repositório: git push"
echo ""
