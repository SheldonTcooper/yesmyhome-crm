<?php

/**
 * Validar que todas as migrações têm proteção SQLite para dropForeign
 *
 * Uso: php check-sqlite-migrations.php
 */

$migrationsPath = __DIR__ . '/packages/*/src/Database/Migrations';
$issues = [];
$checked = 0;

// Encontrar todas as migrações
foreach (glob($migrationsPath, GLOB_BRACE) as $dir) {
    if (!is_dir($dir)) continue;

    foreach (glob($dir . '/*.php') as $file) {
        $checked++;
        $content = file_get_contents($file);

        // Verificar se tem dropForeign
        if (strpos($content, 'dropForeign') === false) {
            continue;
        }

        $filename = basename($file);
        $relativePath = str_replace(__DIR__ . '/', '', $file);

        // Verificar se tem proteção SQLite
        $hasProtection = strpos($content, "DB::getDriverName() !== 'sqlite'") !== false ||
                        strpos($content, 'getDriverName() !== \'sqlite\'') !== false ||
                        strpos($content, 'getDriverName() === \'sqlite\'') !== false ||
                        strpos($content, "getDriverName() === 'sqlite'") !== false;

        if (!$hasProtection) {
            $issues[] = [
                'file' => $relativePath,
                'filename' => $filename,
                'problem' => 'dropForeign sem proteção SQLite'
            ];
        }
    }
}

// Exibir resultados
echo "\n===== VERIFICAÇÃO DE MIGRAÇÕES SQLite =====\n\n";
echo "Total de migrações verificadas: $checked\n\n";

if (empty($issues)) {
    echo "✅ SUCESSO! Todas as migrações têm proteção SQLite.\n\n";
    exit(0);
} else {
    echo "⚠️  PROBLEMAS ENCONTRADOS: " . count($issues) . "\n\n";

    foreach ($issues as $issue) {
        echo "❌ {$issue['filename']}\n";
        echo "   Path: {$issue['file']}\n";
        echo "   Problema: {$issue['problem']}\n\n";
    }

    echo "\nAção necessária: Adicione proteção SQLite usando:\n";
    echo "if (DB::getDriverName() !== 'sqlite') {\n";
    echo "    \$table->dropForeign([...]);\n";
    echo "}\n\n";

    exit(1);
}
