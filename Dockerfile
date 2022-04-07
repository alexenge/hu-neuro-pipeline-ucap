FROM alexenge/r_eeg:4.1.2

ENV PIPELINE_DATA_DIR="$HOME/proj/data"

USER root

RUN \
    # Install the latest version of the pipeline
    pip3 install --no-cache-dir --upgrade --pre \
    --index https://test.pypi.org/simple/ hu-neuro-pipeline \
    # Add default user permissions
    && chown -R "$NB_USER" "$HOME"

USER "$NB_USER"
