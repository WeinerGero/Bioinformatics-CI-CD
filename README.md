# Bioinformatics-CI-CD

Dockerfile для сборки Docker-образа на базе Ubuntu 22.04 с программами и библиотеками для работы с SAM/BAM/CRAM, VCF/BCF и запуска SNP-addition.

## Стек

![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10-3776AB?logo=python&logoColor=white)
![Samtools](https://img.shields.io/badge/Samtools-1.24-2E8B57)
![HTSlib](https://img.shields.io/badge/HTSlib-1.24-4682B4)
![BCFtools](https://img.shields.io/badge/BCFtools-1.24-6A5ACD)
![VCFtools](https://img.shields.io/badge/VCFtools-0.1.17-8B4513)
![libdeflate](https://img.shields.io/badge/libdeflate-1.26-708090)

## Программы и библиотеки

В образе установлены:

| Программа / библиотека | Версия | Назначение |
| --- | ---: | --- |
| [Samtools](https://github.com/samtools/samtools) | 1.24 | Работа с SAM/BAM/CRAM |
| [HTSlib](https://github.com/samtools/htslib) | 1.24 | Работа с форматами секвенирования |
| [libdeflate](https://github.com/ebiggers/libdeflate) | 1.26 | Сжатие и распаковка DEFLATE/gzip |
| [BCFtools](https://github.com/samtools/bcftools) | 1.24 | Работа с VCF/BCF |
| [VCFtools](https://github.com/vcftools/vcftools) | 0.1.17 | Анализ и обработка VCF |
| Python | 3.10 | Запуск SNP-addition |

Специализированные программы и библиотеки собираются из исходников и устанавливаются в отдельные каталоги внутри `/soft`.

SNP-addition устанавливается в `/content/SNP-addition` вместе с зависимостями из `requirements.txt`.

## Сборка Docker-образа

```bash
git clone https://github.com/WeinerGero/Bioinformatics-CI-CD.git
cd Bioinformatics-CI-CD

docker build -t bioinfo-tools .
```

## Запуск контейнера

```bash
docker run --rm -it bioinfo-tools bash
```

Программы доступны напрямую из `PATH`:

```bash
samtools --version
bcftools --version
vcftools --version
bgzip --version
tabix --version
htsfile --version
```

Проверка SNP-addition:

```bash
docker run --rm bioinfo-tools python3 main.py --help
```

## Запуск SNP-addition

Файлы референсного генома на хостовой машине должны находиться в:

```text
/mnt/data/ref/GRCh38.d1.vd1_mainChr/sepChrs/
```

Каталог должен содержать `chr[1-22,M,X,Y].fa` и `chr[1-22,M,X,Y].fa.fai`.

Для сохранения результата и логов пробрасываю каталог с входными данными в `/data`, а референсный геном в `/ref/GRCh38.d1.vd1_mainChr/sepChrs/`:

```bash
docker run --rm \
  --mount type=bind,src=/path/to/SNP-addition,dst=/data \
  --mount type=bind,src=/mnt/data/ref/GRCh38.d1.vd1_mainChr/sepChrs,dst=/ref/GRCh38.d1.vd1_mainChr/sepChrs,readonly \
  -w /data \
  bioinfo-tools \
  python3 /content/SNP-addition/main.py \
    --input FP_SNPs_10k_GB38_twoAllelsFormat.tsv \
    --output result_FP_SNPs_10k_GB38_REF_ALT.tsv
```

После запуска результат и каталог `logs/` сохраняются в проброшенном каталоге `/data`.

## Переменные окружения

```text
SOFT=/soft
SAMTOOLS=/soft/samtools-1.24/bin/samtools
BCFTOOLS=/soft/bcftools-1.24/bin/bcftools
VCFTOOLS=/soft/vcftools-0.1.17/bin/vcftools
```

Подробное описание SNP-addition:

[SNP-addition](https://github.com/WeinerGero/SNP-addition)
