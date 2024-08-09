# VPA

A chart to install the [Kubernetes Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)


## Tests and Debugging

There are a few tests included with this chart that can help debug why your installation of VPA isn't working as expected. You can run `helm test -n <Release Namespace> <Release Name>` to run them.

* `crds-available` - Checks for both the _verticalpodautoscalers_ and _verticalpodautoscalercheckpoints_ CRDs
* `metrics-api-available` - Checks to make sure that the metrics API endpoint is available. If it's not, install [metrics-server](https://github.com/kubernetes-sigs/metrics-server) in your cluster.
* `create-vpa` - A simple check to make sure that VPA objects can be created in your cluster. Does not check for functionality of that VPA.


## Components

There are three primary components to the Vertical Pod Autoscaler that can be enabled individually here.

* recommender
* updater
* admissionController

For more details, please see the values below, and the vertical pod autosclaer documentation.

## Installation

```bash
helm install vpa ./helm-charts/vpa --namespace vpa --create-namespace
```

## Utilize Prometheus for History

In order to utilize prometheus for recommender history, you will need to pass some extra flags to the recommender. If you use prometheus operator installed in the `prometheus-operator` namespace, these values will do the trick.

```yaml
recommender:
  extraArgs:
    prometheus-address: |
      http://prometheus-operator-prometheus.prometheus-operator.svc.cluster.local:9090
    storage: prometheus
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` | A list of image pull secrets to be used for all pods |
| priorityClassName | string | `""` | To set the priorityclass for all pods |
| nameOverride | string | `""` | A template override for the name |
| fullnameOverride | string | `""` | A template override for the fullname |
| podLabels | object | `{}` | Labels to add to all pods |
| rbac.create | bool | `true` | If true, then rbac resources (ClusterRoles and ClusterRoleBindings) will be created for the selected components. Temporary rbac resources will still be created, to ensure a functioning installation process |
| rbac.extraRules | object | `{"vpaActor":[],"vpaCheckpointActor":[],"vpaEvictioner":[],"vpaMetricsReader":[],"vpaStatusActor":[],"vpaStatusReader":[],"vpaTargetReader":[]}` | Extra rbac rules for ClusterRoles |
| rbac.extraRules.vpaActor | list | `[]` | Extra rbac rules for the vpa-actor ClusterRole |
| rbac.extraRules.vpaStatusActor | list | `[]` | Extra rbac rules for the vpa-status-actor ClusterRole |
| rbac.extraRules.vpaCheckpointActor | list | `[]` | Extra rbac rules for the vpa-checkpoint-actor ClusterRole |
| rbac.extraRules.vpaEvictioner | list | `[]` | Extra rbac rules for the vpa-evictioner ClusterRole |
| rbac.extraRules.vpaMetricsReader | list | `[]` | Extra rbac rules for the vpa-metrics-reader ClusterRole |
| rbac.extraRules.vpaTargetReader | list | `[]` | Extra rbac rules for the vpa-target-reader ClusterRole |
| rbac.extraRules.vpaStatusReader | list | `[]` | Extra rbac rules for the vpa-status-reader ClusterRole |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created for each component |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service accounts for each component |
| serviceAccount.name | string | `""` | The base name of the service account to use (appended with the component). If not set and create is true, a name is generated using the fullname template and appended for each component |
| serviceAccount.automountServiceAccountToken | bool | `true` | Automount API credentials for the Service Account |
| recommender.enabled | bool | `true` | If true, the vpa recommender component will be installed. |
| recommender.envFromSecret | string | `""` | Specify a secret to get environment variables from |
| recommender.annotations | object | `{}` | Annotations to add to the recommender deployment |
| recommender.extraArgs | object | `{"pod-recommendation-min-cpu-millicores":15,"pod-recommendation-min-memory-mb":100,"v":"4"}` | A set of key-value flags to be passed to the recommender |
| recommender.replicaCount | int | `1` |  |
| recommender.revisionHistoryLimit | int | `10` | The number of old replicasets to retain, default is 10, 0 will garbage-collect old replicasets |
| recommender.podDisruptionBudget | object | `{}` | This is the setting for the pod disruption budget |
| recommender.image.repository | string | `"registry.k8s.io/autoscaling/vpa-recommender"` | The location of the recommender image |
| recommender.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| recommender.image.pullPolicy | string | `"Always"` | The pull policy for the recommender image. Recommend not changing this |
| recommender.podAnnotations | object | `{}` | Annotations to add to the recommender pod |
| recommender.podLabels | object | `{}` | Labels to add to the recommender pod |
| recommender.podSecurityContext | object | `{"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | The security context for the recommender pod |
| recommender.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The security context for the containers inside the recommender pod |
| recommender.livenessProbe | object | `{"failureThreshold":6,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The liveness probe definition inside the recommender pod |
| recommender.readinessProbe | object | `{"failureThreshold":120,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The readiness probe definition inside the recommender pod |
| recommender.resources | object | `{"limits":{},"requests":{"cpu":"50m","memory":"500Mi"}}` | The resources block for the recommender pod |
| recommender.nodeSelector | object | `{}` |  |
| recommender.tolerations | list | `[]` |  |
| recommender.affinity | object | `{}` |  |
| recommender.podMonitor | object | `{"annotations":{},"enabled":false,"labels":{}}` | Enables a prometheus operator podMonitor for the recommender |
| updater.enabled | bool | `true` | If true, the updater component will be deployed |
| updater.annotations | object | `{}` | Annotations to add to the updater deployment |
| updater.extraArgs | object | `{}` | A key-value map of flags to pass to the updater |
| updater.replicaCount | int | `1` |  |
| updater.revisionHistoryLimit | int | `10` | The number of old replicasets to retain, default is 10, 0 will garbage-collect old replicasets |
| updater.podDisruptionBudget | object | `{}` | This is the setting for the pod disruption budget |
| updater.image.repository | string | `"registry.k8s.io/autoscaling/vpa-updater"` | The location of the updater image |
| updater.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| updater.image.pullPolicy | string | `"Always"` | The pull policy for the updater image. Recommend not changing this |
| updater.podAnnotations | object | `{}` | Annotations to add to the updater pod |
| updater.podLabels | object | `{}` | Labels to add to the updater pod |
| updater.podSecurityContext | object | `{"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | The security context for the updater pod |
| updater.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The security context for the containers inside the updater pod |
| updater.livenessProbe | object | `{"failureThreshold":6,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The liveness probe definition inside the updater pod |
| updater.readinessProbe | object | `{"failureThreshold":120,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The readiness probe definition inside the updater pod |
| updater.resources | object | `{"limits":{},"requests":{"cpu":"50m","memory":"500Mi"}}` | The resources block for the updater pod |
| updater.nodeSelector | object | `{}` |  |
| updater.tolerations | list | `[]` |  |
| updater.affinity | object | `{}` |  |
| updater.podMonitor | object | `{"annotations":{},"enabled":false,"labels":{}}` | Enables a prometheus operator podMonitor for the updater |
| admissionController.enabled | bool | `true` | If true, will install the admission-controller component of vpa |
| admissionController.annotations | object | `{}` | Annotations to add to the admission controller deployment |
| admissionController.extraArgs | object | `{}` | A key-value map of flags to pass to the admissionController |
| admissionController.generateCertificate | bool | `true` | If true and admissionController is enabled, a pre-install hook will run to create the certificate for the webhook |
| admissionController.secretName | string | `"{{ include \"vpa.fullname\" . }}-tls-secret"` | Name for the TLS secret created for the webhook. Default {{ .Release.Name }}-tls-secret |
| admissionController.registerWebhook | bool | `false` | If true, will allow the vpa admission controller to register itself as a mutating webhook |
| admissionController.certGen.image.repository | string | `"registry.k8s.io/ingress-nginx/kube-webhook-certgen"` | An image that contains certgen for creating certificates. Only used if admissionController.generateCertificate is true |
| admissionController.certGen.image.tag | string | `"v20230312-helm-chart-4.5.2-28-g66a760794"` | An image tag for the admissionController.certGen.image.repository image. Only used if admissionController.generateCertificate is true |
| admissionController.certGen.image.pullPolicy | string | `"Always"` | The pull policy for the certgen image. Recommend not changing this |
| admissionController.certGen.env | object | `{}` | Additional environment variables to be added to the certgen container. Format is KEY: Value format |
| admissionController.certGen.resources | object | `{}` | The resources block for the certgen pod |
| admissionController.certGen.securityContext | object | `{}` | The securityContext block for the certgen container(s) |
| admissionController.certGen.podSecurityContext | object | `{}` | The securityContext block for the certgen pod(s) |
| admissionController.certGen.nodeSelector | object | `{}` |  |
| admissionController.certGen.tolerations | list | `[]` |  |
| admissionController.certGen.affinity | object | `{}` |  |
| admissionController.mutatingWebhookConfiguration.annotations | object | `{}` | Additional annotations for the MutatingWebhookConfiguration. Can be used for integration with cert-manager |
| admissionController.mutatingWebhookConfiguration.failurePolicy | string | `"Ignore"` | The failurePolicy for the mutating webhook. Allowed values are: Ignore, Fail |
| admissionController.mutatingWebhookConfiguration.namespaceSelector | object | `{}` | The namespaceSelector controls, which namespaces are affected by the webhook |
| admissionController.mutatingWebhookConfiguration.objectSelector | object | `{}` | The objectSelector can filter object on e.g. labels |
| admissionController.mutatingWebhookConfiguration.timeoutSeconds | int | `5` |  |
| admissionController.replicaCount | int | `1` |  |
| admissionController.revisionHistoryLimit | int | `10` | The number of old replicasets to retain, default is 10, 0 will garbage-collect old replicasets |
| admissionController.podDisruptionBudget | object | `{}` | This is the setting for the pod disruption budget |
| admissionController.image.repository | string | `"registry.k8s.io/autoscaling/vpa-admission-controller"` | The location of the vpa admission controller image |
| admissionController.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| admissionController.image.pullPolicy | string | `"Always"` | The pull policy for the admission controller image. Recommend not changing this |
| admissionController.podAnnotations | object | `{}` | Annotations to add to the admission controller pod |
| admissionController.podLabels | object | `{}` | Labels to add to the admission controller pod |
| admissionController.podSecurityContext | object | `{"runAsNonRoot":true,"runAsUser":65534,"seccompProfile":{"type":"RuntimeDefault"}}` | The security context for the admission controller pod |
| admissionController.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | The security context for the containers inside the admission controller pod |
| admissionController.livenessProbe | object | `{"failureThreshold":6,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The liveness probe definition inside the admission controller pod |
| admissionController.readinessProbe | object | `{"failureThreshold":120,"httpGet":{"path":"/health-check","port":"metrics","scheme":"HTTP"},"periodSeconds":5,"successThreshold":1,"timeoutSeconds":3}` | The readiness probe definition inside the admission controller pod |
| admissionController.resources | object | `{"limits":{},"requests":{"cpu":"50m","memory":"200Mi"}}` | The resources block for the admission controller pod |
| admissionController.tlsSecretKeys | list | `[]` | The keys in the vpa-tls-certs secret to map in to the admission controller |
| admissionController.nodeSelector | object | `{}` |  |
| admissionController.tolerations | list | `[]` |  |
| admissionController.affinity | object | `{}` |  |
| admissionController.useHostNetwork | bool | `false` | Whether to use host network, this is required on EKS with custom CNI |
| admissionController.httpPort | int | `8000` | Port of the admission controller for the mutating webhooks |
| admissionController.metricsPort | int | `8944` | Port of the admission controller where metrics can be received from |
| tests.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":10324}` | The security context for the containers run as helm hook tests |
| tests.image.repository | string | `"bitnami/kubectl"` | An image used for testing containing bash, cat and kubectl |
| tests.image.tag | string | `""` | An image tag for the tests image |
| tests.image.pullPolicy | string | `"Always"` | The pull policy for the tests image. |
| metrics-server | object | `{"enabled":false}` | configuration options for the [metrics server Helm chart](https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server). See the projects [README.md](https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server#configuration) for all available options |
| metrics-server.enabled | bool | `false` | Whether or not the metrics server Helm chart should be installed |