FROM rocker/binder:4.1.2

ENV HOME="/home/$NB_USER"
ENV PROJDIR="$HOME/proj"
ENV RETICULATE_MINICONDA_ENABLED="FALSE"

USER root

RUN \
    # Install R packages from MRAN
    install2.r --error --skipinstalled \
    cowplot \
    emmeans \
    git2r \
    here \
    Hmisc \
    httpgd \
    huxtable \
    kableExtra \
    languageserver \
    lmerTest \
    magick \
    MetBrewer \
    modelsummary \
    naturalsort \
    performance \
    reticulate \
    Rmisc \
    styler \
    tictoc \
    # Install R packages from GitHub
    && installGithub.r \
    craddm/eegUtils@v0.7.0 \
    crsh/citr@0e8243d \
    crsh/papaja@2572124 \
    # Install Python packages from PyPI
    && pip3 install --no-cache-dir \
    mne==1.0.0 \
    notebook \
    radian \
    session_info \
    # Install Python packages from Test PyPI
    && pip3 install --no-cache-dir --upgrade --pre \
    --index https://test.pypi.org/simple/ hu-neuro-pipeline \
    # Install LaTeX packages
    && tlmgr update --self \
    && tlmgr install \
    amscls \
    # amsmath \
    # apa7 \
    # auxhook \
    # babel-english \
    # beamer \
    # bigintcalc \
    # bitset \
    # booktabs \
    # caption \
    # csquotes \
    # endfloat \
    # epstopdf-pkg \
    # etexcmds \
    # etoolbox \
    # euenc \
    # fancyhdr \
    # fancyvrb \
    # filehook \
    # float \
    # fontspec \
    # footmisc \
    # fp \
    # framed \
    # geometry environ \
    # gettitlestring \
    # grffile \
    # grfext \
    # hycolor \
    # hyperref \
    # iftex \
    # infwarerr \
    # intcalc \
    # kvdefinekeys \
    # kvoptions \
    # kvsetkeys \
    # latex-amsmath-dev \
    # letltxmacro \
    # lineno \
    # ltxcmds \
    # makecell \
    # makecmds \
    # multirow \
    # nowidow \
    # pdfescape \
    # pdftexcmds \
    # pgf \
    # polyglossia \
    # refcount \
    # rerunfilecheck \
    # scalerel \
    # setspace \
    # siunitx \
    # stringenc \
    # times \
    # threeparttable \
    # threeparttablex \
    # tipa \
    # translator \
    # trimspaces \
    # unicode-math \
    # uniquecounter \
    # was \
    # xcolor \
    # xpatch \
    # xunicode \
    # zapfding \
    # Make sure R Markdown documents get knitted from the project directory
    && echo "knitr::opts_knit\$set(root.dir = getwd())" >> "$HOME/.Rprofile" \
    # Enable plotting via `httpgd` in VS Code
    && echo "options(vsc.use_httpgd = TRUE)" >> "$HOME/.Rprofile" \
    # Set color theme for radian
    && echo "options(radian.color_scheme = 'vs')" > "$HOME/.radian_profile" \
    # Create working directory
    && mkdir "$PROJDIR" \
    # Add default user permissions
    && chown -R "$NB_USER" "$HOME"

USER "$NB_USER"

WORKDIR "$PROJDIR"
