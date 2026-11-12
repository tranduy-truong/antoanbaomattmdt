<?php

declare(strict_types=1);

header('Content-Type: application/json');
header('Cache-Control: no-store');

function fail(int $status): never
{
    http_response_code($status);
    echo json_encode(['error' => ['status' => $status]]);
    exit;
}

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    fail(405);
}

$token = getenv('GEMINI_RELAY_TOKEN');
if (!$token || !hash_equals('Bearer '.$token, $_SERVER['HTTP_AUTHORIZATION'] ?? '')) {
    fail(401);
}

$key = getenv('GEMINI_API_KEY');
if (!$key) {
    fail(503);
}

$payload = file_get_contents('php://input', false, null, 0, 2810001);
if ($payload === false || strlen($payload) > 2810000) {
    fail(413);
}

$curl = curl_init('https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent');
curl_setopt_array($curl, [
    CURLOPT_POST => true,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CONNECTTIMEOUT => 4,
    CURLOPT_TIMEOUT => 20,
    CURLOPT_HTTPHEADER => ['Content-Type: application/json', 'x-goog-api-key: '.$key],
    CURLOPT_POSTFIELDS => $payload,
]);
$result = curl_exec($curl);
$status = curl_getinfo($curl, CURLINFO_HTTP_CODE);
if (!is_string($result) || !$status) {
    fail(504);
}
if ($status >= 400) {
    fail($status);
}
http_response_code($status);
echo $result;
