{{/*
Render full image name from given values, e.g:
```
image:
  repository: quay.io/isovalent/hubble-rbac
  override:
  tag: latest
  useDigest: true
  digest: abcdefgh
```
Then `include "jobs-app.image" .Values.server.rbac.image`
will return `quay.io/isovalent/hubble-rbac:latest@abcdefgh`.
If `override` is included that value only will be returned.
*/}}
{{- define "jobs-app.image" -}}
{{- $digest := (.useDigest | default false) | ternary (printf "@%s" .digest) "" -}}
{{- if .override -}}
{{- printf "%s" .override -}}
{{- else -}}
{{- printf "%s:%s%s" .repository .tag $digest -}}
{{- end -}}
{{- end -}}
{{/* OTel agent egress rule block for CiliumNetworkPolicy */}}
{{- define "jobs-app.otelAgentEgress" -}}
{{- if .Values.networkPolicy.enableOtelEgress }}
{{- if .Values.networkPolicy.otelAgentEgressToEntities }}
- toEntities:
    - host
    - remote-node
  toPorts:
    - ports:
        - port: "{{ .Values.networkPolicy.otelAgentOTLPHTTPPort | default "4318" }}"
          protocol: TCP
        - port: "{{ .Values.networkPolicy.otelAgentOTLPGRPCPort | default "4317" }}"
          protocol: TCP
{{- else }}
- toEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: {{ .Values.networkPolicy.otelAgentNamespace | default "otel-splunk" }}
        k8s:app: {{ .Values.networkPolicy.otelAgentAppLabel | default "splunk-otel-collector" }}
        k8s:component: {{ .Values.networkPolicy.otelAgentComponentLabel | default "otel-collector-agent" }}
  toPorts:
    - ports:
        - port: "{{ .Values.networkPolicy.otelAgentOTLPHTTPPort | default "4318" }}"
          protocol: TCP
        - port: "{{ .Values.networkPolicy.otelAgentOTLPGRPCPort | default "4317" }}"
          protocol: TCP
{{- end }}
{{- end }}
{{- end }}
