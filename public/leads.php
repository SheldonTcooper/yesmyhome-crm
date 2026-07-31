<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/../vendor/autoload.php';
$app = require_once __DIR__ . '/../bootstrap/app.php';

$kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
$request = \Illuminate\Http\Request::capture();

try {
    $service = $app->make(\App\Services\YesMyHomeIntegrationService::class);

    $method = $_SERVER['REQUEST_METHOD'];

    if ($method === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);
        $result = $service->createLead($data);

        if ($result) {
            http_response_code(201);
            echo json_encode(['success' => true, 'message' => 'Lead criado!', 'data' => $result]);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Erro ao criar lead']);
        }
    } elseif ($method === 'GET') {
        $leads = $service->getLeads();
        echo json_encode(['success' => true, 'data' => $leads]);
    } else {
        http_response_code(405);
        echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    }
} catch (\Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
