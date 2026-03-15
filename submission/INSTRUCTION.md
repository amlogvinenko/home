# Инструкция по запуску и проверке

## Что должно быть в архиве
- `docker-compose.yml`
- папки `paper/` и `velocity/`
- `mc_motd_retriever.py`
- `submission/REPORT.md`
- `submission/INSTRUCTION.md`
- `submission/CONTENTS.txt`
- скриншоты/фото проверки (например, `фотки.pdf`)

## Запуск
```bash
docker compose up -d --build
```

## Что проверить
```bash
docker compose ps
python mc_motd_retriever.py
```

Дополнительно проверить закрытый backend-порт:
```powershell
Test-NetConnection localhost -Port 25570
```

## Остановка
```bash
docker compose down
```

## Ожидаемый результат
- `velocity` и `paper` в статусе `Up`
- порт `25565` доступен
- порт `25570` с хоста недоступен
- через `mc_motd_retriever.py` на `25565` виден MOTD backend
