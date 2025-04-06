{{- define "sample-microservice.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "sample-microservice.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end -}}
