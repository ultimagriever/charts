{{/* Expand the name of the chart. */}}
{{- define "monochart.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "monochart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Set common labels */}}
{{- define "monochart.labels" -}}
helm.sh/chart: {{ include "monochart.chart" . }}
{{ include "monochart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Set selector labels - used to associate certain resources */}}
{{- define "monochart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "monochart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Name to use for service account */}}
{{- define "monochart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "monochart.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Chart Namespace */}}
{{- define "monochart.namespace" -}}
{{- if .Values.namespace.create }}
{{- printf "%s-%s" .Values.namespace.app .Values.namespace.environment.name }}
{{- else }}
{{- default "default" .Values.namespace.app }}
{{- end }}
{{- end }}

{{/* Encoded registry secret for docker images */}}
{{- define "monochart.registrySecret" }}
{{- with .Values.imagePullSecrets }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/* Name for the PDB when enabled */}}
{{- define "monochart.pdbName" }}
{{- if .Values.pdb.enabled }}
{{- default (include "monochart.name" .) .Values.pdb.name }}
{{- else }}
{{- default "default" .Values.pdb.name }}
{{- end }}
{{- end }}
