# User-defined variables
DOCKER_USER		:= alexenge
IMAGE_VERSION	:= latest
SLURM_SCRIPT	:= run_slurm.sh
SLURM_CPUS		:= 8
SLURM_MEMORY	:= 32G
SLURM_TIME		:= 24:00:00

# Automatic workflow variables
PROJ_DIR		:= $(CURDIR)
PROJ_NAME		:= $(notdir $(CURDIR))
IMAGE_TAG 		:= $(DOCKER_USER)/$(PROJ_NAME)
IMAGE_URL		:= docker://$(IMAGE_TAG):$(IMAGE_VERSION)
IMAGE_FILE		:= $(PROJ_DIR)/$(PROJ_NAME)_$(IMAGE_VERSION).sif
REMOTE_DIR		:= /home/rstudio/proj
SHELL			:= bash

# Check execution should be containerized and/or submitted as a batch job
ifeq ($(DOCKER), TRUE)
	run := docker run --rm --volume $(PROJ_DIR):$(REMOTE_DIR) $(IMAGE_TAG) \
	Rscript -e "rmarkdown::render(input = 'analysis/manuscript.Rmd')"
else ifeq ($(SLURM), TRUE)
	run := sbatch --chdir $(PROJ_DIR) --cpus-per-task $(SLURM_CPUS) \
	--mem $(SLURM_MEMORY) --nodes 1 --ntasks 1 --time $(SLURM_TIME) \
	$(SLURM_SCRIPT) $(PROJ_DIR) $(IMAGE_FILE)
else
	run := Rscript -e "rmarkdown::render(input = 'analysis/manuscript.Rmd')"
endif

# Main target: Knit the manuscript
all: analysis/manuscript.pdf
analysis/manuscript.pdf: analysis/manuscript.Rmd
analysis/manuscript.pdf:
	$(run)

# Run an interactive RStudio session with Docker
interactive:
	docker run --rm --volume $(PROJ_DIR):$(REMOTE_DIR) \
	-e PASSWORD=1234 -p 8888:8888 $(IMAGE_TAG)

# Build the container with Docker
build: Dockerfile
	docker build --no-cache --progress plain --tag $(IMAGE_TAG) .

# Push the container with Docker
push:
	docker push $(IMAGE_TAG)

# Pull the container with Docker
pull:
	docker pull $(IMAGE_TAG)

# Pull the container with Singularity
pull_singularity: $(IMAGE_FILE)
$(IMAGE_FILE):
	singularity pull --disable-cache $(IMAGE_FILE) $(IMAGE_URL)
