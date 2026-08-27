# Bioinformatics-CI-CD

Dockerfile для сборки Docker-образа, содержащий актуальные версии программ и библиотек для биоинформатического пайплайна

docker build -t bioinfo-tools .
docker run --rm -it bioinfo-tools bash
