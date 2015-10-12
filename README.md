# elasticsearch
Multi-purpose Elasticsearch-Image

This image serves as a basis for a OpenShift / Kubernetes cluster-wide logging instance with scalability.

ATTENTION in OpenShift:
The serviceaccount user has to have view rights on the cluster:

oc policy add-role-to-user view system:serviceaccount:<namespace>:default
