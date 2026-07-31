<?php

use App\Http\Controllers\Api\LeadController;
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes - Stateless, CSRF-exempt
|--------------------------------------------------------------------------
*/

Route::get('/health', function () {
    return response()->json(['success' => true, 'backend_online' => false]);
});

Route::post('/leads', [LeadController::class, 'create']);
Route::get('/leads', [LeadController::class, 'list']);

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
Route::post('/webhook/create-lead', function (Request $request) {
    try {
        $lead = [
            'id' => time(),
            'name' => $request->input('name', 'Sem nome'),
            'email' => $request->input('email'),
            'phone' => $request->input('phone'),
            'whatsapp' => $request->input('whatsapp'),
            'property_type' => $request->input('property_type'),
            'operation_type' => $request->input('operation_type'),
            'source' => 'website',
            'created_at' => now(),
        ];

        // Salvar em arquivo JSON
        $file = storage_path('leads.json');
        $leads = file_exists($file) ? json_decode(file_get_contents($file), true) ?? [] : [];
        $leads[] = $lead;
        @file_put_contents($file, json_encode($leads, JSON_PRETTY_PRINT));

        return response()->json(['success' => true, 'lead_id' => $lead['id']], 201);
    } catch (\Exception $e) {
        return response()->json(['success' => false, 'error' => $e->getMessage()], 500);
    }
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
