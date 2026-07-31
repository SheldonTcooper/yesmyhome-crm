<?php

use App\Http\Controllers\Api\LeadController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes - Stateless, CSRF-exempt
|--------------------------------------------------------------------------
*/

Route::post('/leads', [LeadController::class, 'create']);
Route::get('/leads', [LeadController::class, 'list']);
Route::get('/health', [LeadController::class, 'health']);

// Teste de SMS direto
Route::get('/test-sms/{phone}', function ($phone) {
    try {
        $twilio = new \Twilio\Rest\Client(
            config('services.twilio.account_sid'),
            config('services.twilio.auth_token')
        );

        $message = $twilio->messages->create(
            $phone,
            [
                "body" => "🎉 CRM YesMyHome funcionando! Esse é um teste automático do sistema de mensageria.",
                "from" => config('services.twilio.phone')
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'SMS enviado com sucesso!',
            'sid' => $message->sid,
            'to' => $phone,
            'from' => config('services.twilio.phone')
        ], 200);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'error' => $e->getMessage()
        ], 500);
    }
});

// Webhook para receber leads do website
Route::post('/webhook/create-lead', function (Request $request, \App\Services\YesMyHomeIntegrationService $service) {
    $data = json_decode(file_get_contents('php://input'), true) ?? [];
    $data['source'] = 'website';

    $result = $service->createLead($data);

    if ($result) {
        return response()->json(['success' => true, 'lead_id' => $result['lead']['id'] ?? null], 201);
    }

    return response()->json(['success' => false, 'error' => 'Erro ao criar lead'], 500);
});

// Enviar mensagem automática
Route::post('/webhook/send-message', function (Request $request, \App\Services\YesMyHomeIntegrationService $service) {
    $leadId = $request->input('lead_id');
    $channel = $request->input('channel', 'whatsapp');
    $message = $request->input('message');

    if (!$message || !$leadId) {
        return response()->json(['success' => false, 'error' => 'Dados incompletos'], 400);
    }

    $result = $service->sendMessage($leadId, $channel, $message);

    if ($result) {
        return response()->json(['success' => true, 'message' => 'Mensagem enviada'], 200);
    }

    return response()->json(['success' => false, 'error' => 'Erro ao enviar'], 500);
});
