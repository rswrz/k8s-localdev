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

## Flux deployment

### Bootstrap

Prepare the local repository

```sh
kubectl exec git-0 -- git-init k8s-localdev
git remote add local http://git.localhost/k8s-localdev.git
git push local main
```

Flux needs a password, create a dummy.

```sh
kubectl create namespace flux-system

flux create secret git flux-system \
  --namespace flux-system \
  --url http://git.default.svc/k8s-localdev.git \
  --username _ \
  --password _
```

Do the bootstrap

```sh
flux bootstrap git --url http://git.localhost/k8s-localdev.git --path flux --allow-insecure-http
```

Theoretically the password is not needed anymore, because of the patch during the first [initial setup](#initial-setup). Therefore lets keep it clean and delete the password.

```sh
kubectl --namespace flux-system delete secret flux-system
```

### Initial setup

To be able to install flux from a local git repository through http and no authentication, the following steps were done initially. This is not needed anymore, just [bootstrap](#bootstrap) from this repository.

1. Prepare bootstrap – create a dummy password

   ```sh
   kubectl create namespace flux-system

   flux create secret git flux-system \
     --namespace flux-system \
     --url http://git.default.svc/k8s-localdev.git \
     --username _ \
     --password _
   ```

2. Flux bootstrap

   ```sh
   flux bootstrap git \
   --components-extra=image-reflector-controller,image-automation-controller \
   --url=http://git.localhost/k8s-localdev.git \
   --allow-insecure-http=true \
   --path=flux
   ```

3. Patch failed bootstrap ([kustomization.yaml](./flux/flux-system/kustomization.yaml))
   - force http repository
   - remove secret ref

4. Bootstrap again like step 2
