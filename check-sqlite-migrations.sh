#!/bin/bash

# Validar que todas as migrações têm proteção SQLite para dropForeign

echo ""
echo "===== VERIFICAÇÃO DE MIGRAÇÕES SQLite ====="
echo ""

# Encontrar migrações com dropForeign
echo "Verificando migrações com dropForeign..."
echo ""

ISSUES=()
CHECKED=0

find packages -name "*.php" -path "*/Migrations/*" | while read file; do
    if grep -q "dropForeign" "$file"; then
        CHECKED=$((CHECKED + 1))
        FILENAME=$(basename "$file")

        # Verificar se tem proteção SQLite
        if ! grep -q "DB::getDriverName() !== 'sqlite'\|getDriverName() !== 'sqlite'\|getDriverName() === 'sqlite'\|DB::getDriverName() === 'sqlite'" "$file"; then
            echo "❌ $file"
            echo "   ✗ dropForeign sem proteção SQLite"
            echo ""
        fi
    fi
done

echo ""
echo "Verificação concluída!"
echo ""
