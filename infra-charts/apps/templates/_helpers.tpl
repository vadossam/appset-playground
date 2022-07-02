{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 24 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "name" . }}
helm.sh/chart: {{ include "chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Define island suffix */}}
{{- define "island_suffix" -}}
{{- printf "%s" .Values.island | trimPrefix .Values.environment | trimPrefix "-" -}}
{{- end -}}

{{/* Select Slack alert channel based on environment */}}
{{- define "alert_channel" -}}
#alerts-{{ include "island_suffix" . }}
{{- end -}}

{{/* Select EasyWP domain based on environment */}}
{{- define "domain" -}}
{{- if eq .Values.environment "production" -}}
easywp.com
{{- else if eq .Values.environment "staging" -}}
easywp.host
{{- else if eq .Values.environment "testing" -}}
easywp.wtf
{{- else if eq .Values.environment "development" -}}
easywp.tld
{{- end -}}
{{- end -}}

{{/* Select management domain based on environment */}}
{{- define "management_domain" -}}
{{- if eq .Values.environment "production" -}}
namecheapcloud.net
{{- else if eq .Values.environment "staging" -}}
namecheapcloud.host
{{- else if eq .Values.environment "testing" -}}
namecheapcloud.wtf
{{- else if eq .Values.environment "development" -}}
namecheapcloud.tld
{{- end -}}
{{- end -}}

{{/* Define cluster names */}}
{{- define "database_clusters" -}}
{{- if eq .Values.role "overcloud" }}
01, 02, 03, 04, postfix, proftpd
{{- else if eq .Values.role "management" }}
postfix, proftpd
{{- end -}}
{{- end }}
