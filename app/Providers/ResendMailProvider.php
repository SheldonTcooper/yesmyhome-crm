<?php

namespace App\Providers;

use Illuminate\Mail\Transport\Transport;
use Illuminate\Support\ServiceProvider;
use Swift_Events_EventListener;
use Swift_Transport;

class ResendMailProvider extends ServiceProvider
{
    public function boot()
    {
        $this->app['mail.manager']->extend('resend', function () {
            return new ResendTransport(config('services.resend.key'));
        });
    }
}

class ResendTransport extends Transport implements Swift_Transport
{
    protected $apiKey;

    public function __construct($apiKey)
    {
        $this->apiKey = $apiKey;
    }

    public function isStarted()
    {
        return true;
    }

    public function start()
    {
        return $this;
    }

    public function stop()
    {
        return $this;
    }

    public function reset()
    {
        return $this;
    }

    public function send(\Swift_Mime_SimpleMessage $message, &$failedRecipients = null)
    {
        $this->beforeSendPerformed($message);

        try {
            $client = new \Resend($this->apiKey);

            $to = array_keys((array) $message->getTo());
            $cc = array_keys((array) $message->getCc());
            $bcc = array_keys((array) $message->getBcc());

            $payload = [
                'from' => $message->getFrom() ? key($message->getFrom()) : 'noreply@example.com',
                'to' => $to,
                'subject' => $message->getSubject(),
                'html' => $message->getBody(),
            ];

            if (!empty($cc)) {
                $payload['cc'] = $cc;
            }
            if (!empty($bcc)) {
                $payload['bcc'] = $bcc;
            }

            $client->emails->send($payload);

            $this->afterSendPerformed($message);
            return 1;
        } catch (\Exception $e) {
            \Log::error('Resend email error: ' . $e->getMessage());
            return 0;
        }
    }

    public function registerPlugin(Swift_Events_EventListener $plugin)
    {
        return $this;
    }
}
