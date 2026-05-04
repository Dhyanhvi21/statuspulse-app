#!/bin/bash

set -e

BASE_URL="http://localhost:8000"

echo "Testing /health..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/health)
if [ "$STATUS" -ne 200 ]; then
  echo "/health failed"
  exit 1
fi
echo "/health passed"

echo " Testing POST /services..."
RESPONSE=$(curl -s -X POST $BASE_URL/services \
  -H "Content-Type: application/json" \
  -d '{"name":"google","url":"https://google.com"}')

echo "$RESPONSE" | grep "google" > /dev/null || { echo "❌ service create failed"; exit 1; }
echo "service created"

echo "🔍 Testing duplicate service (409)..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST $BASE_URL/services \
  -H "Content-Type: application/json" \
  -d '{"name":"google","url":"https://google.com"}')

if [ "$STATUS" -ne 409 ]; then
  echo " duplicate test failed"
  exit 1
fi
echo "duplicate handled"

echo "🔍 Testing GET /services..."
curl -s $BASE_URL/services | grep "google" > /dev/null || { echo "❌ get services failed"; exit 1; }
echo " services fetched"

echo "🔍 Testing POST /incidents..."
RESPONSE=$(curl -s -X POST $BASE_URL/incidents \
  -H "Content-Type: application/json" \
  -d '{"service_name":"google","title":"Test incident"}')

echo "$RESPONSE" | grep "investigating" > /dev/null || { echo "❌ incident create failed"; exit 1; }
echo "incident created"

echo "🔍 Testing GET /incidents..."
curl -s $BASE_URL/incidents | grep "google" > /dev/null || { echo "❌ get incidents failed"; exit 1; }
echo "incidents fetched"

echo "🎉 ALL TESTS PASSED"