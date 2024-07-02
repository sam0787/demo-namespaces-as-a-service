{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "pg-common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pg-common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pg-common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "pg-common.labels" -}}
helm.sh/chart: {{ include "pg-common.chart" . }}
{{ include "pg-common.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
games24x7.com/component: {{ .Values.config.extraLabels.component }}
games24x7.com/team: {{ .Values.config.extraLabels.team }}
games24x7.com/project: {{ .Values.config.extraLabels.project }}
games24x7.com/business-unit: {{ .Values.config.extraLabels.businessUnit }}
games24x7.com/billing-unit: {{ .Values.config.extraLabels.billingUnit }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "pg-common.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "pg-common.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "pg-common.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a fully qualified heap dump path
*/}}
{{- define "pg-common.heapDumpPath" -}}
{{- if .Values.config.heapDump.pathOverride -}}
   /dumps/{{ (lower .Values.config.heapDump.pathOverride) }}_{{ include "pg-common.fullname" . }}/
{{- else -}}
   /dumps/{{ (lower .Values.config.extraLabels.project) }}_{{ include "pg-common.fullname" . }}/
{{- end -}}
{{- end -}}
