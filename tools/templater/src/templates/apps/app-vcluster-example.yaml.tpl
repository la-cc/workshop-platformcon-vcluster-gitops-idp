{%- set isolated_nodepools = cluster.nodePools | selectattr("isolated", "equalto", true) | list %}
{%- set is_isolated = isolated_nodepools | length > 0 -%}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vcluster-{{ cluster.project }}
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: vcluster-{{ cluster.project }}
    server: "https://kubernetes.default.svc"
  sources:
    - repoURL: https://github.com/la-cc/workshop-platformcon-vcluster-gitops-idp.git
      targetRevision: main
      path: "./managed-service-catalog/helm/vcluster"
      helm:
        ignoreMissingValueFiles: true
        releaseName: "vcluster-{{ cluster.project }}"
        valueFiles:
          - "values.yaml"
        values: |
          externalSecret:
            enabled: {{ "true" if cluster.argocd == "enabled" else "false" }}
          namespaceName: vcluster-{{ cluster.project }}
          rbac:
            groupName: "{{ cluster.groupRbac }}"
          vcluster:
            controlPlane:
            {%- if is_isolated %}
              coredns:
                deployment:
                  tolerations:
                    - key: "project"
                      operator: "Equal"
                      value: "{{ cluster.project }}"
                      effect: "NoSchedule"
                  nodeSelector:
                    project: "{{ cluster.project }}"
            {%- endif %}
              proxy:
                extraSANs:
                  - vcluster-{{ cluster.project }}.platformcon.stackit.run
              ingress:
                enabled: true
                host: "vcluster-{{ cluster.project }}.platformcon.stackit.run"
                pathType: ImplementationSpecific
                annotations:
                  nginx.ingress.kubernetes.io/backend-protocol: HTTPS
                  nginx.ingress.kubernetes.io/ssl-passthrough: "true"
                  nginx.ingress.kubernetes.io/ssl-redirect: "true"
                  cert-manager.io/cluster-issuer: letsencrypt-prod
                spec:
                  ingressClassName: nginx
            {%- if is_isolated %}
              statefulSet:
                scheduling:
                  tolerations:
                    - key: "project"
                      operator: "Equal"
                      value: "{{ cluster.project }}"
                      effect: "NoSchedule"
                  nodeSelector:
                    project: "{{ cluster.project }}"
              backingStore:
                etcd:
                  deploy:
                    statefulSet:
                      scheduling:
                        tolerations:
                          - key: "project"
                            operator: "Equal"
                            value: "{{ cluster.project }}"
                            effect: "NoSchedule"
                        nodeSelector:
                          project: "{{ cluster.project }}"
            {%- endif %}
  project: default
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
      allowEmpty: true
    syncOptions:
      - CreateNamespace=false
      - PruneLast=true
      - FailOnSharedResource=true
      - RespectIgnoreDifferences=true
      - ApplyOutOfSyncOnly=true
      - ServerSideApply=true
