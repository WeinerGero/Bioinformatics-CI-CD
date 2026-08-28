# Bioinformatics-CI-CD

Dockerfile для сборки Docker-образа с биоинформатическими программами и библиотеками.

## Сборка Docker-образа

```bash
docker build -t bioinfo-tools .
```

## Запуск Docker-образа в интерактивном режиме

```bash
docker run --rm -it bioinfo-tools bash
```
