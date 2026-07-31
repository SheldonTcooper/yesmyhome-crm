<?php
// Simple API endpoint without middleware protection
header('Content-Type: application/json');

// Handle CORS
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Load Laravel
require __DIR__ . '/../vendor/autoload.php';
$app = require __DIR__ . '/../bootstrap/app.php';
$kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);

// Get request
$request = \Illuminate\Http\Request::capture();

// Route API calls
$path = parse_url($request->getRequestUri(), PHP_URL_PATH);
$path = str_replace('/api-integration', '', $path);

if ($path === '/health') {
    echo json_encode([
        'success' => true,
        'backend_online' => true,
        'message' => 'Backend conectado!'
    ]);
    exit();
}

if ($path === '/leads' && $request->getMethod() === 'POST') {
    try {
        $service = $app->make(\App\Services\YesMyHomeIntegrationService::class);
        $data = $request->json()->all();
        $result = $service->createLead($data);

        if ($result) {
            http_response_code(201);
            echo json_encode([
                'success' => true,
                'message' => 'Lead criado com sucesso!',
                'data' => $result
            ]);
        } else {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Erro ao criar lead no backend'
            ]);
        }
    } catch (\Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
    exit();
}

if ($path === '/leads' && $request->getMethod() === 'GET') {
    try {
        $service = $app->make(\App\Services\YesMyHomeIntegrationService::class);
        $leads = $service->getLeads();

        echo json_encode([
            'success' => true,
            'data' => $leads
        ]);
    } catch (\Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage()
        ]);
    }
    exit();
}

// Not found
http_response_code(404);
echo json_encode([
    'success' => false,
    'message' => 'Endpoint not found'
]);
