# User-defined variables
DOCKER_USER		:= alexenge
IMAGE_NAME		:= r_eeg
IMAGE_VERSION	:= 4.1.2
SLURM_SCRIPT	:= run_slurm.sh
SLURM_CPUS		:= 8
SLURM_MEMORY	:= 32G
SLURM_TIME		:= 24:00:00

# Automatic workflow variables
PROJECT_DIR		:= $(CURDIR)
PROJECT_NAME	:= $(notdir $(CURDIR))
IMAGE_TAG 		:= $(DOCKER_USER)/$(IMAGE_NAME)
IMAGE_URL		:= docker://$(IMAGE_TAG):$(IMAGE_VERSION)
IMAGE_FILE		:= $(PROJECT_DIR)/$(IMAGE_NAME)_$(IMAGE_VERSION).sif
REMOTE_DIR		:= /home/rstudio/project
SHELL			:= bash

# Check execution should be containerized and/or submitted as a batch job
ifeq ($(DOCKER), TRUE)
	run := docker run --rm --volume $(PROJECT_DIR):$(REMOTE_DIR) $(IMAGE_TAG) \
	Rscript -e "rmarkdown::render(input = 'analysis/manuscript.Rmd')"
else ifeq ($(SLURM), TRUE)
	run := sbatch --chdir $(PROJECT_DIR) --cpus-per-task $(SLURM_CPUS) \
	--mem $(SLURM_MEMORY) --nodes 1 --ntasks 1 --time $(SLURM_TIME) \
	$(SLURM_SCRIPT) $(PROJECT_DIR) $(IMAGE_FILE)
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
	docker run --rm --volume $(PROJECT_DIR):$(REMOTE_DIR) \
	-e PASSWORD=1234 -p 8888:8888 $(IMAGE_TAG)

# Pull the container with Docker
pull:
	docker pull $(IMAGE_TAG)

# Pull the container with Singularity
pull_singularity: $(IMAGE_FILE)
$(IMAGE_FILE):
	singularity pull --disable-cache $(IMAGE_FILE) $(IMAGE_URL)
