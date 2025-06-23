{%- set isolated_nodepools = cluster.nodePools | selectattr("isolated", "equalto", true) | list %}
{%- set is_isolated = isolated_nodepools | length > 0 -%}
{%- if cluster.argocd == "enabled" -%}

argo-cd:
  dex:
    enabled: false
  global:
    {%- if is_isolated %}
    tolerations:
      - key: "project"
        operator: "Equal"
        value: "{{ cluster.project }}"
        effect: "NoSchedule"
    nodeSelector:
      project: "{{ cluster.project }}"
    {%- endif %}
    domain: argocd.vcluster-{{ cluster.project }}.platformcon.stackit.run
    imagePullSecrets:
      - name: image-pull-secret
    revisionHistoryLimit: 5
  server:
    ingress:
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod
        nginx.ingress.kubernetes.io/backend-protocol: HTTPS
        nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      enabled: true
      ingressClassName: nginx
      tls: true
  {%- endif %}