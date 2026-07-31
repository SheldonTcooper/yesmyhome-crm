<?php

namespace App\Http\Controllers;

use App\Services\YesMyHomeIntegrationService;
use Illuminate\Http\Request;

class LeadIntegrationController extends Controller
{
    protected $integration;

    public function __construct(YesMyHomeIntegrationService $integration)
    {
        $this->integration = $integration;
    }

    /**
     * Criar novo lead via CRM e sincronizar com backend
     */
    public function createLead(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'email' => 'nullable|email',
            'phone' => 'nullable|string',
            'whatsapp' => 'nullable|string',
            'property_type' => 'nullable|string',
            'operation_type' => 'nullable|string',
            'source' => 'nullable|string',
        ]);

        $result = $this->integration->createLead($validated);

        if ($result) {
            return response()->json([
                'success' => true,
                'message' => 'Lead criado com sucesso!',
                'data' => $result,
            ], 201);
        }

        return response()->json([
            'success' => false,
            'message' => 'Erro ao criar lead no backend',
        ], 500);
    }

    /**
     * Listar todos os leads
     */
    public function listLeads()
    {
        $leads = $this->integration->getLeads();

        return response()->json([
            'success' => true,
            'data' => $leads,
        ]);
    }

    /**
     * Ver detalhes de um lead
     */
    public function getLeadDetails($leadId)
    {
        $lead = $this->integration->getLeadDetails($leadId);

        if ($lead) {
            return response()->json([
                'success' => true,
                'data' => $lead,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Lead não encontrado',
        ], 404);
    }

    /**
     * Atualizar status do lead
     */
    public function updateLeadStatus(Request $request, $leadId)
    {
        $validated = $request->validate([
            'status' => 'required|string|in:novo,contactado,visitado,proposta,fechado,perdido',
        ]);

        $result = $this->integration->updateLeadStatus($leadId, $validated['status']);

        if ($result) {
            return response()->json([
                'success' => true,
                'message' => 'Status atualizado com sucesso!',
                'data' => $result,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Erro ao atualizar status',
        ], 500);
    }

    /**
     * Enviar mensagem via Email ou WhatsApp
     */
    public function sendMessage(Request $request, $leadId)
    {
        $validated = $request->validate([
            'channel' => 'required|string|in:email,whatsapp',
            'message' => 'required|string',
        ]);

        $result = $this->integration->sendMessage(
            $leadId,
            $validated['channel'],
            $validated['message']
        );

        if ($result) {
            return response()->json([
                'success' => true,
                'message' => 'Mensagem enviada com sucesso!',
                'data' => $result,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Erro ao enviar mensagem',
        ], 500);
    }

    /**
     * Obter estatísticas do dashboard
     */
    public function getDashboardStats()
    {
        $stats = $this->integration->getDashboardStats();

        if ($stats) {
            return response()->json([
                'success' => true,
                'data' => $stats,
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Erro ao obter estatísticas',
        ], 500);
    }

    /**
     * Verificar se backend está online
     */
    public function healthCheck()
    {
        $isOnline = $this->integration->healthCheck();

        return response()->json([
            'success' => true,
            'backend_online' => $isOnline,
            'message' => $isOnline ? 'Backend conectado!' : 'Backend offline',
        ]);
    }
}
