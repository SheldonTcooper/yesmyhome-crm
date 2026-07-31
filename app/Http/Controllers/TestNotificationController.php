<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Mail;
use Twilio\Rest\Client as TwilioClient;

class TestNotificationController extends Controller
{
    public function testEmail()
    {
        try {
            $to = config('app.debug') ? 'romulo@tauritecnologia.com.br' : 'test@example.com';

            Mail::raw('Este é um email de teste do Laravel CRM! 🚀', function ($message) use ($to) {
                $message->to($to)
                        ->subject('Teste Email - Laravel CRM');
            });

            return response()->json([
                'status' => 'success',
                'message' => 'Email enviado com sucesso para: ' . $to,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function testSMS()
    {
        try {
            $accountSid = config('services.twilio.account_sid');
            $authToken = config('services.twilio.auth_token');
            $fromPhone = config('services.twilio.phone');
            $toPhone = '+5511999999999'; // Seu número para testes

            $client = new TwilioClient($accountSid, $authToken);

            $message = $client->messages->create(
                $toPhone,
                [
                    'from' => $fromPhone,
                    'body' => 'Teste SMS - Laravel CRM! 🚀'
                ]
            );

            return response()->json([
                'status' => 'success',
                'message' => 'SMS enviado com sucesso!',
                'sid' => $message->sid,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    public function testBoth()
    {
        $emailResult = $this->testEmail();
        $smsResult = $this->testSMS();

        return response()->json([
            'email' => json_decode($emailResult->getContent(), true),
            'sms' => json_decode($smsResult->getContent(), true),
        ]);
    }
}
