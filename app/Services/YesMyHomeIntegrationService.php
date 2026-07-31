<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class YesMyHomeIntegrationService
{
    private $baseUrl = 'http://localhost:5000/api';
    private $timeout = 10;

    /**
     * Criar lead no banco de dados + enviar mensagens automáticas
     */
    public function createLead($leadData)
    {
        try {
            // Criar lead no banco de dados
            $lead = [
                'name' => $leadData['name'] ?? 'Sem nome',
                'email' => $leadData['email'] ?? null,
                'phone' => $leadData['phone'] ?? null,
                'whatsapp' => $leadData['whatsapp'] ?? $leadData['phone'] ?? null,
                'property_type' => $leadData['property_type'] ?? 'residential',
                'operation_type' => $leadData['operation_type'] ?? 'sale',
                'source' => $leadData['source'] ?? 'crm',
                'status' => 'novo',
                'ai_score' => rand(40, 90), // Score fake para demo
                'created_at' => now(),
                'updated_at' => now(),
            ];

            // Salvar em arquivo JSON para demo (sem banco de dados real)
            $leadsFile = storage_path('leads.json');
            $leads = file_exists($leadsFile) ? json_decode(file_get_contents($leadsFile), true) : [];

            $lead['id'] = count($leads) + 1;
            $leads[] = $lead;

            file_put_contents($leadsFile, json_encode($leads, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));

            Log::info('Lead criado com sucesso', [
                'lead_id' => $lead['id'],
                'name' => $lead['name'],
                'email' => $lead['email'],
            ]);

            // Enviar mensagens automáticas (mock)
            $this->enviarMensagensAutomaticas($lead);

            return [
                'success' => true,
                'lead' => $lead,
            ];
        } catch (\Exception $e) {
            Log::error('Exceção ao criar lead no Node.js: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Enviar mensagens automáticas (SMS, WhatsApp, Email)
     */
    private function enviarMensagensAutomaticas($leadData)
    {
        try {
            $email = $leadData['email'] ?? null;
            $phone = $leadData['whatsapp'] ?? $leadData['phone'] ?? null;
            $nome = $leadData['name'] ?? 'Visitante';

            // Email de boas-vindas
            if ($email) {
                \Mail::send([], [], function ($message) use ($email, $nome) {
                    $message->from(config('mail.from.address'))
                        ->to($email)
                        ->subject('Bem-vindo ao YesMyHome!')
                        ->html("
                            <h2>Bem-vindo, {$nome}!</h2>
                            <p>Obrigado por entrar em contato com a YesMyHome.</p>
                            <p>Nossa equipe já recebeu sua solicitação e em breve retornaremos com as melhores opções para você!</p>
                            <p><strong>Entre em contato conosco:</strong></p>
                            <p>WhatsApp: <a href='https://wa.me/5541992030057'>(41) 99203-0057</a></p>
                            <p>Atenciosamente,<br>YesMyHome Negociações Imobiliárias</p>
                        ");
                });
                Log::info('Email de boas-vindas enviado', ['email' => $email]);
            }

            // SMS via Twilio
            if ($phone) {
                try {
                    $twilio = new \Twilio\Rest\Client(
                        config('services.twilio.account_sid'),
                        config('services.twilio.auth_token')
                    );

                    $message = $twilio->messages->create(
                        $phone,
                        [
                            "body" => "Oi {$nome}! Recebemos sua solicitação. A YesMyHome em breve retorna com as melhores opções. 🏠",
                            "from" => config('services.twilio.phone')
                        ]
                    );
                    Log::info('SMS enviado via Twilio', ['sid' => $message->sid]);
                } catch (\Exception $e) {
                    Log::warning('Erro ao enviar SMS: ' . $e->getMessage());
                }
            }
        } catch (\Exception $e) {
            Log::error('Erro ao enviar mensagens automáticas: ' . $e->getMessage());
        }
    }

    /**
     * Listar todos os leads
     */
    public function getLeads()
    {
        try {
            $leadsFile = storage_path('leads.json');
            if (file_exists($leadsFile)) {
                $leads = json_decode(file_get_contents($leadsFile), true) ?? [];
                return [
                    'success' => true,
                    'leads' => $leads,
                ];
            }

            return [
                'success' => true,
                'leads' => [],
            ];
        } catch (\Exception $e) {
            Log::error('Exceção ao listar leads: ' . $e->getMessage());
            return [];
        }
    }

    /**
     * Obter detalhes de um lead
     */
    public function getLeadDetails($leadId)
    {
        try {
            $response = Http::timeout($this->timeout)
                ->get("{$this->baseUrl}/leads/{$leadId}");

            if ($response->successful()) {
                return $response->json();
            }

            return null;
        } catch (\Exception $e) {
            Log::error("Exceção ao obter lead {$leadId}: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Atualizar status do lead
     */
    public function updateLeadStatus($leadId, $status)
    {
        try {
            $response = Http::timeout($this->timeout)
                ->put("{$this->baseUrl}/leads/{$leadId}/status", [
                    'status' => $status,
                ]);

            if ($response->successful()) {
                Log::info("Lead {$leadId} status atualizado: {$status}");
                return $response->json();
            }

            return null;
        } catch (\Exception $e) {
            Log::error("Exceção ao atualizar status do lead {$leadId}: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Enviar mensagem (Email ou WhatsApp)
     */
    public function sendMessage($leadId, $channel, $message)
    {
        try {
            $response = Http::timeout($this->timeout)
                ->post("{$this->baseUrl}/leads/{$leadId}/send-message", [
                    'channel' => $channel, // 'email' ou 'whatsapp'
                    'message' => $message,
                ]);

            if ($response->successful()) {
                Log::info("Mensagem enviada via {$channel} para lead {$leadId}");
                return $response->json();
            }

            return null;
        } catch (\Exception $e) {
            Log::error("Exceção ao enviar mensagem: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Obter estatísticas do dashboard
     */
    public function getDashboardStats()
    {
        try {
            $response = Http::timeout($this->timeout)
                ->get("{$this->baseUrl}/leads/dashboard/stats");

            if ($response->successful()) {
                return $response->json();
            }

            return null;
        } catch (\Exception $e) {
            Log::error('Exceção ao obter stats: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Verificar saúde do backend
     */
    public function healthCheck()
    {
        try {
            $response = Http::timeout(5)->get("{$this->baseUrl}/leads");
            return $response->successful();
        } catch (\Exception $e) {
            Log::warning('Backend Node.js indisponível: ' . $e->getMessage());
            return false;
        }
    }
}
