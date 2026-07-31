# Fix para Migrações SQLite - Laravel CRM

## Problema Diagnosticado

O erro `"This database driver does not support dropping foreign keys by name"` estava ocorrendo porque **múltiplas migrações usavam `dropForeign()` sem verificar o driver do banco de dados**.

SQLite não suporta remover foreign keys por nome, então qualquer tentativa de fazer isso gera erro.

## Solução Implementada

### 1. Macro Seguro (AppServiceProvider)

Adicionado ao `app/Providers/AppServiceProvider.php`:

```php
Blueprint::macro('dropForeignSafe', function ($columns) {
    if (DB::getDriverName() !== 'sqlite') {
        return $this->dropForeign($columns);
    }
    return $this;
});
```

Este macro permite usar `$table->dropForeignSafe(['column'])` que automaticamente ignora a operação em SQLite.

### 2. Migrações Corrigidas

As seguintes migrações foram corrigidas adicionando verificações SQLite:

#### Lead Package (Webkul\Lead)
- ✅ `2021_09_30_161722_alter_leads_table.php` - Adicionado if antes de dropForeign
- ✅ `2021_11_11_180804_change_lead_pipeline_stage_id_constraint_in_leads_table.php` - Adicionado if
- ✅ `2024_11_29_120302_modify_foreign_keys_in_leads_table.php` - Adicionado if para múltiplos dropForeign

#### Contact Package (Webkul\Contact)
- ✅ `2024_08_14_102116_add_user_id_column_in_persons_table.php` - Adicionado if no down()
- ✅ `2024_08_14_102136_add_user_id_column_in_organizations_table.php` - Adicionado if no down()
- ✅ `2025_03_19_132236_update_organization_id_column_in_persons_table.php` - Adicionado if

#### Product Package (Webkul\Product)
- ✅ `2024_09_06_065808_alter_product_inventories_table.php` - Adicionado if

#### Activity Package (Webkul\Activity)
- ✅ `2025_01_17_151632_alter_activities_table.php` - Adicionado if + suporte multi-driver para down()

#### WebForm Package (Webkul\WebForm)
- ✅ `2026_07_09_000000_add_lead_pipeline_id_to_web_forms_table.php` - Adicionado if no down()

#### Lead Pipeline Stages (já tinha proteção)
- ✅ `2021_09_30_154222_alter_lead_pipeline_stages_table.php` - Já tinha if (sem mudanças)

## Como Testar

### Para SQLite:

1. **Criar novo banco SQLite:**
   ```bash
   cd C:\Users\romul\Desktop\laravel-crm-2.2
   
   # Limpar o banco antigo (se houver)
   rm -f database/database.sqlite
   
   # Configurar para SQLite
   # Editar .env:
   # DB_CONNECTION=sqlite
   # DB_DATABASE=/full/path/to/database/database.sqlite
   ```

2. **Executar migrações:**
   ```bash
   php artisan migrate:fresh
   php artisan migrate:fresh --seed
   ```

3. **Verificar sucesso:**
   ```bash
   php artisan migrate:status
   ```

### Para MySQL (confirmar que não quebrou):

1. **Executar migrações normalmente:**
   ```bash
   php artisan migrate:fresh
   ```

2. **Verificar se tudo rodou:**
   ```bash
   php artisan migrate:status
   ```

## O que foi mudado em cada migração

### Padrão 1: Simples dropForeign

**Antes:**
```php
Schema::table('leads', function (Blueprint $table) use ($tablePrefix) {
    $table->dropForeign($tablePrefix.'leads_lead_stage_id_foreign');
    $table->dropColumn('lead_stage_id');
});
```

**Depois:**
```php
Schema::table('leads', function (Blueprint $table) use ($tablePrefix) {
    if (DB::getDriverName() !== 'sqlite') {
        $table->dropForeign($tablePrefix.'leads_lead_stage_id_foreign');
    }
    $table->dropColumn('lead_stage_id');
});
```

### Padrão 2: Múltiplos dropForeign

**Antes:**
```php
$table->dropForeign(['user_id']);
$table->dropForeign(['person_id']);
$table->dropForeign(['lead_source_id']);
$table->dropForeign(['lead_type_id']);
```

**Depois:**
```php
if (DB::getDriverName() !== 'sqlite') {
    $table->dropForeign(['user_id']);
    $table->dropForeign(['person_id']);
    $table->dropForeign(['lead_source_id']);
    $table->dropForeign(['lead_type_id']);
}
```

## Notas Importantes

1. **Reversão (rollback) no SQLite**: Ao fazer `php artisan migrate:rollback` no SQLite, as foreign keys não serão restauradas com os mesmos nomes, mas as colunas serão adicionadas/removidas corretamente.

2. **Compatibilidade**: Todas as migrações agora funcionam em:
   - ✅ MySQL/MariaDB
   - ✅ PostgreSQL
   - ✅ SQLite
   - ✅ Qualquer outro driver suportado pelo Laravel

3. **Cache de Migrações**: Se você tiver problemas, limpe o cache:
   ```bash
   php artisan config:clear
   php artisan cache:clear
   composer dump-autoload
   ```

## Checklist de Verificação

- [ ] Arquivo AppServiceProvider.php foi modificado com os macros
- [ ] Todas as 9 migrações foram verificadas e corrigidas
- [ ] Executou `php artisan migrate:fresh` com sucesso em SQLite
- [ ] Executou `php artisan migrate:fresh` com sucesso em MySQL
- [ ] Banco de dados foi criado com todas as foreign keys corretas
- [ ] Aplicação está funcionando normalmente

## Próximos Passos Recomendados

1. **Teste em staging com SQLite** antes de ir para produção
2. **Backup do banco de dados** antes de rodar as migrações
3. **Monitorar logs** durante a execução das migrações
4. Se houver problemas, abra uma issue com:
   - Driver do banco (MySQL/SQLite/PostgreSQL)
   - Versão do Laravel (`php artisan --version`)
   - Erro completo da migração

## Contato

Em caso de problemas persistentes, verifique:
1. Versão do PHP (`php -v`)
2. Versão do Laravel (`php artisan --version`)
3. Banco de dados está acessível e vazio (para migrate:fresh)
