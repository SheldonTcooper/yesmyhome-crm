<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\YesMyHomeIntegrationService;
use Illuminate\Http\Request;

class LeadController extends Controller
{
    protected $integration;

    public function __construct(YesMyHomeIntegrationService $integration)
    {
        $this->integration = $integration;
    }

    public function create(Request $request)
    {
        $data = json_decode(file_get_contents('php://input'), true) ?? [];
        $result = $this->integration->createLead($data);

        if ($result) {
            return response()->json(['success' => true, 'data' => $result], 201);
        }

        return response()->json(['success' => false, 'message' => 'Erro ao criar lead'], 500);
    }

    public function list()
    {
        $leads = $this->integration->getLeads();
        return response()->json(['success' => true, 'data' => $leads]);
    }

    public function health()
    {
        $online = $this->integration->healthCheck();
        return response()->json(['success' => true, 'backend_online' => $online]);
    }
}
