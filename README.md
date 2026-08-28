# Bioinformatics-CI-CD

Dockerfile для сборки Docker-образа на базе Ubuntu 22.04 с актуальными версиями специализированных программ и библиотек для работы с SAM/BAM/CRAM и VCF/BCF.

## Стек

![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white)
![Samtools](https://img.shields.io/badge/Samtools-1.24-2E8B57)
![HTSlib](https://img.shields.io/badge/HTSlib-1.24-4682B4)
![BCFtools](https://img.shields.io/badge/BCFtools-1.24-6A5ACD)
![VCFtools](https://img.shields.io/badge/VCFtools-0.1.17-8B4513)
![libdeflate](https://img.shields.io/badge/libdeflate-1.26-708090)

## Специализированные программы и библиотеки

В образе установлены:

| Программа / библиотека | Версия | Назначение |
| --- | ---: | --- |
| [Samtools](https://github.com/samtools/samtools) | 1.24 | Работа с SAM/BAM/CRAM файлами |
| [HTSlib](https://github.com/samtools/htslib) | 1.24 | Библиотека и утилиты для работы с форматами высокопроизводительного секвенирования |
| [libdeflate](https://github.com/ebiggers/libdeflate) | 1.26 | Быстрое сжатие и распаковка DEFLATE/gzip |
| [BCFtools](https://github.com/samtools/bcftools) | 1.24 | Работа с VCF/BCF файлами и вариантами |
| [VCFtools](https://github.com/vcftools/vcftools) | 0.1.17 | Анализ и обработка VCF файлов |

Все специализированные программы и библиотеки собираются из исходников и устанавливаются в отдельные каталоги внутри `/soft`.

## Сборка Docker-образа

Клонировать репозиторий:

```bash
git clone https://github.com/WeinerGero/Bioinformatics-CI-CD.git
cd Bioinformatics-CI-CD
```

Собрать Docker-образ:

```bash
docker build -t bioinfo-tools .
```

## Запуск Docker-образа в интерактивном режиме

```bash
docker run --rm -it bioinfo-tools bash
```

После запуска контейнера программы доступны напрямую из `PATH`:

```bash
samtools --version
bcftools --version
vcftools --version
```

Также доступны утилиты HTSlib:

```bash
bgzip --version
tabix --version
htsfile --version
```

## Переменные окружения

```text
SOFT=/soft
SAMTOOLS=/soft/samtools-1.24/bin/samtools
BCFTOOLS=/soft/bcftools-1.24/bin/bcftools
VCFTOOLS=/soft/vcftools-0.1.17/bin/vcftools
```
