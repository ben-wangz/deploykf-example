# deploykf-example

## prepare env for all nodes
1. modprobe
    * ```shell
      MODULES_FILE=/etc/modules-load.d/istio.conf
      sudo bash -c "echo '# These modules need to be loaded on boot so that Istio (as required by Kubeflow) runs properly' > $MODULES_FILE"
      sudo bash -c "echo '# See also: https://github.com/istio/istio/issues/23009' >> $MODULES_FILE"
      modules=(br_netfilter nf_nat xt_REDIRECT xt_owner iptable_nat iptable_mangle iptable_filter)
      for module in ${modules[@]}
      do
            sudo modprobe $module
            sudo bash -c "echo '$module' >> /etc/modules-load.d/istio.conf"
      done
      ```
2. create a virtual k8s cluster with vcluster
    * deploykf will install basic k8s components such as cert-manager, istio, etc, 
      which may conflict with the existing k8s cluster

## generate/update manifests

1. download binary client called `deploykf`
    * ```shell
      # the binary will be downloaded at $HOME/bin/deploykf
      # make sure $HOME/bin is in your $PATH
      bash generate/download-client.sh
      ```
2. (optional) modify `generate/dev-values.yaml` to configure your deployment
3. (optional, already generated) generate manifests
    * ```shell
      # the manifests will be generated at $HOME/deploykf
      bash generate/generate-manifests.sh
      ```

## apply and sync the argocd application to you cluster(in which the argocd is already installed)
1. apply
    * ```shell
      kubectl -n argocd apply -f generate/manifests/app-of-apps.yaml
      ```
2. sync
    * ```shell
      argocd app sync -l "app.kubernetes.io/name=deploykf-app-of-apps"
      # NOTE: This will only be present if you are using a remote destination
      argocd app sync -l "app.kubernetes.io/name=deploykf-namespaces"
      argocd app sync -l "app.kubernetes.io/component=deploykf-dependencies"
      argocd app sync -l "app.kubernetes.io/component=deploykf-core"
      argocd app sync -l "app.kubernetes.io/component=deploykf-opt"
      #argocd app sync -l "app.kubernetes.io/component=deploykf-tools"
      argocd app sync -l "app.kubernetes.io/component=kubeflow-dependencies"
      argocd app sync -l "app.kubernetes.io/component=kubeflow-tools"
      ```