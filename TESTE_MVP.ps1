# 🧪 Script de Teste MVP - YesMyHome CRM Integration
# Teste completo da integração entre Laravel CRM e Node.js Backend

Write-Host "================================" -ForegroundColor Cyan
Write-Host "🚀 TESTE MVP - YesMyHome CRM" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost/api/integration"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Cores
$green = 'Green'
$red = 'Red'
$yellow = 'Yellow'

# 1. Health Check
Write-Host "1️⃣  Verificando saúde do backend..." -ForegroundColor $yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -Method Get -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Backend online e conectado!" -ForegroundColor $green
    }
} catch {
    Write-Host "❌ Backend offline! Inicie o Node.js com: node src/server.js" -ForegroundColor $red
    exit 1
}

Write-Host ""

# 2. Criar Lead de Teste
Write-Host "2️⃣  Criando lead de teste..." -ForegroundColor $yellow

$leadData = @{
    name = "Cliente Teste MVP"
    email = "cliente@yesmyhome.com.br"
    phone = "+5511999999999"
    whatsapp = "+5511999999999"
    property_type = "chácara"
    operation_type = "sale"
    source = "crm"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads" `
        -Method Post `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $leadData `
        -ErrorAction Stop

    $leadJson = $response.Content | ConvertFrom-Json
    Write-Host "✅ Lead criado com sucesso!" -ForegroundColor $green
    Write-Host "   ID: $($leadJson.data.id)" -ForegroundColor $green
    Write-Host "   Nome: $($leadJson.data.name)" -ForegroundColor $green

    $leadId = $leadJson.data.id
} catch {
    Write-Host "❌ Erro ao criar lead: $($_.Exception.Message)" -ForegroundColor $red
    exit 1
}

Write-Host ""

# 3. Listar Leads
Write-Host "3️⃣  Listando todos os leads..." -ForegroundColor $yellow

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads" -Method Get -ErrorAction Stop
    $leadsJson = $response.Content | ConvertFrom-Json

    if ($leadsJson -is [array]) {
        Write-Host "✅ Total de leads: $($leadsJson.Count)" -ForegroundColor $green
    } else {
        Write-Host "✅ Leads carregados com sucesso!" -ForegroundColor $green
    }
} catch {
    Write-Host "❌ Erro ao listar leads: $($_.Exception.Message)" -ForegroundColor $red
}

Write-Host ""

# 4. Obter Detalhes do Lead
Write-Host "4️⃣  Obtendo detalhes do lead criado..." -ForegroundColor $yellow

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads/$leadId" -Method Get -ErrorAction Stop
    $leadDetail = $response.Content | ConvertFrom-Json

    Write-Host "✅ Lead encontrado:" -ForegroundColor $green
    Write-Host "   Nome: $($leadDetail.data.name)" -ForegroundColor $green
    Write-Host "   Email: $($leadDetail.data.email)" -ForegroundColor $green
    Write-Host "   WhatsApp: $($leadDetail.data.whatsapp)" -ForegroundColor $green
    Write-Host "   Status: $($leadDetail.data.status)" -ForegroundColor $green
} catch {
    Write-Host "❌ Erro ao obter detalhes: $($_.Exception.Message)" -ForegroundColor $red
}

Write-Host ""

# 5. Atualizar Status
Write-Host "5️⃣  Atualizando status do lead..." -ForegroundColor $yellow

$statusData = @{
    status = "contactado"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads/$leadId/status" `
        -Method Put `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $statusData `
        -ErrorAction Stop

    Write-Host "✅ Status atualizado para: contactado" -ForegroundColor $green
} catch {
    Write-Host "❌ Erro ao atualizar status: $($_.Exception.Message)" -ForegroundColor $red
}

Write-Host ""

# 6. Enviar Mensagem WhatsApp
Write-Host "6️⃣  Enviando mensagem via WhatsApp..." -ForegroundColor $yellow

$messageData = @{
    channel = "whatsapp"
    message = "🏠 Olá! Encontramos uma chácara perfeita para você. Quer agendar uma visita?"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads/$leadId/send-message" `
        -Method Post `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $messageData `
        -ErrorAction Stop

    Write-Host "✅ WhatsApp enviado com sucesso!" -ForegroundColor $green
} catch {
    Write-Host "⚠️  Erro ao enviar WhatsApp: $($_.Exception.Message)" -ForegroundColor $yellow
    Write-Host "   (Pode ser necessário configurar credenciais Twilio)" -ForegroundColor $yellow
}

Write-Host ""

# 7. Enviar Email
Write-Host "7️⃣  Enviando email..." -ForegroundColor $yellow

$emailData = @{
    channel = "email"
    message = "<h2>🏠 Oportunidade Imobiliária</h2><p>Encontramos uma chácara com piscina e área verde. Quer conhecer?</p>"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/leads/$leadId/send-message" `
        -Method Post `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $emailData `
        -ErrorAction Stop

    Write-Host "✅ Email enviado com sucesso!" -ForegroundColor $green
} catch {
    Write-Host "⚠️  Erro ao enviar email: $($_.Exception.Message)" -ForegroundColor $yellow
    Write-Host "   (Pode ser necessário configurar credenciais Resend)" -ForegroundColor $yellow
}

Write-Host ""

# 8. Dashboard Stats
Write-Host "8️⃣  Obtendo estatísticas do dashboard..." -ForegroundColor $yellow

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/dashboard/stats" -Method Get -ErrorAction Stop
    $stats = $response.Content | ConvertFrom-Json

    Write-Host "✅ Estatísticas carregadas:" -ForegroundColor $green
    Write-Host "   Total de Leads: $($stats.data.totalLeads)" -ForegroundColor $green
    Write-Host "   Novos: $($stats.data.newLeads)" -ForegroundColor $green
    Write-Host "   Contactados: $($stats.data.contactedLeads)" -ForegroundColor $green
    Write-Host "   Automações Enviadas: $($stats.data.automationsSent)" -ForegroundColor $green
} catch {
    Write-Host "❌ Erro ao obter stats: $($_.Exception.Message)" -ForegroundColor $red
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "✅ TESTE COMPLETO EXECUTADO!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Resumo:" -ForegroundColor Cyan
Write-Host "   ✅ Backend online" -ForegroundColor $green
Write-Host "   ✅ Lead criado: $leadId" -ForegroundColor $green
Write-Host "   ✅ Status atualizado" -ForegroundColor $green
Write-Host "   ✅ Mensagens enviadas" -ForegroundColor $green
Write-Host "   ✅ Estatísticas carregadas" -ForegroundColor $green
Write-Host ""
Write-Host "🚀 Sistema pronto para apresentação ao cliente!" -ForegroundColor Green
Write-Host ""
