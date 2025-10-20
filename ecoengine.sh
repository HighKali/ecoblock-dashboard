#!/bin/bash

# === EcoBlock Engine ===
# Diagnosi UI, riparazione, commit, push, notifica

PROJECT_DIR=~/ecoblock-dashboard
LOG="$PROJECT_DIR/ecoengine.log"
BRANCH="main"
WEBHOOK_URL=""  # Inserisci qui il tuo webhook Discord se vuoi notifiche

cd "$PROJECT_DIR" || { echo "❌ Directory non trovata"; exit 1; }

echo "🚀 Avvio EcoEngine: $(date)" > "$LOG"

# 1. Diagnosi e riparazione UI
echo "🔧 Esecuzione ecoheal_ui_fix.py..." >> "$LOG"
python ecoheal_ui_fix.py >> "$LOG" 2>&1

# 2. Commit e push GitHub
echo "📦 Commit e push su GitHub..." >> "$LOG"
git add index.html scripts.js ui_diagnose.log ecoengine.log
git commit -m "EcoEngine: riparazione UI e sincronizzazione"
git push origin "$BRANCH" >> "$LOG" 2>&1

# 3. Notifica Discord (se webhook presente)
if [ -n "$WEBHOOK_URL" ]; then
  curl -H "Content-Type: application/json" \
       -X POST \
       -d "{\"content\": \"🚀 EcoEngine completato: UI riparata e push eseguito su GitHub\"}" \
       "$WEBHOOK_URL"
  echo "🔔 Notifica Discord inviata" >> "$LOG"
else
  echo "ℹ️ Webhook Discord non configurato" >> "$LOG"
fi

echo "✅ EcoEngine completato. Log disponibile in ecoengine.log"
