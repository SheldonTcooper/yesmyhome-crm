<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);

$response = $kernel->handle(
    $request = \Illuminate\Http\Request::capture()
);

$db = app('db');
$columns = $db->select('PRAGMA table_info(lead_pipeline_stages)');

echo "=== lead_pipeline_stages SCHEMA ===\n";
foreach($columns as $col) {
    $nullable = $col->notnull ? 'NOT NULL' : 'NULL';
    echo "{$col->name} ({$col->type}) - {$nullable}\n";
}
