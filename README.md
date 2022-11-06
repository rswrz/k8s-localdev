# Local Kubernetes Development Plattform

## Requirements

- k3s Kubernetes cluster
  - Custom resource definition `HelmChart` is used.

## Components

- Git registry
- Container image registry
- NGINX ingress controller
- Kubernetes Dashboard
- Startpage (<http://localhost>)

## Quick start

Apply all manifest files

```sh
kubectl apply -k ./kustomize
```

Add git repository

```sh
kubectl exec git-0 -- git-init my-repo-1
git clone http://git.localhost/my-repo-1
```

Push image to registry

```sh
docker pull hello-world
docker tag hello-world registry.localhost/hello-world
docker push registry.localhost/hello-world
```

## Cluster configuration

Add the following configuration into your k3s cluster to be able to use the deployed container image registry inside the Kubernetes cluster.

```yaml
mirrors:
  registry.localhost:
    endpoint:
    - http://registry.default.svc
```

### Colima

Ad the following to colima configuration to set the container image registry automatically on cluster creation.

```yaml
provision:
  - mode: system
    script: |
      mkdir -p /etc/rancher/k3s
      cat <<'EOF' > /etc/rancher/k3s/registry.yaml
      mirrors:
        registry.localhost:
          endpoint:
          - http://registry.default.svc
      EOF
```
