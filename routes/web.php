<?php

use App\Services\YesMyHomeIntegrationService;
use Illuminate\Support\Facades\Route;

Route::get('/dashboard', function (YesMyHomeIntegrationService $service) {
    $data = $service->getLeads();
    $leads = $data['leads'] ?? [];
    return view('dashboard', ['leads' => $leads]);
});
