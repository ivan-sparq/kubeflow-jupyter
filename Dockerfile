# Ref: https://www.kubeflow.org/docs/notebooks/custom-notebook/
# https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html
# https://github.com/krallin/tini

FROM jupyter/scipy-notebook
ENV NB_PREFIX /


RUN conda install -c conda-forge nodejs

# Install from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN jupyter labextension install -y --clean --debug --dev-build=False \
    dask-labextension \
    @jupyterlab/server-proxy && \
    jupyter lab build -y --dev-build=False --log-level=10


USER root
RUN apt update && apt-get install -y \
       keychain vim jq curl

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
 chmod +x ./kubectl && \
 mv ./kubectl /usr/local/bin/kubectl && \
kubectl version --client

# Install Helm
RUN curl "https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3" | bash

COPY run.bash /usr/local/bin/
RUN chmod +x /usr/local/bin/run.bash
ENTRYPOINT ["tini", "-vvv", "-g", "--"]
CMD ["run.bash"]

#USER $NB_UID
