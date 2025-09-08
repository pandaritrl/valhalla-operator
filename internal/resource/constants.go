package resource

const valhallaDataPath = "/data"
const workerImage = "pandaritrl/valhalla-worker:latest"
const mapBuilderImage = "pandaritrl/valhalla-builder:latest"
const hirtoricalTrafficDataFetcherImage = "pandaritrl/valhalla-predicted-traffic:latest"

const DeploymentSuffix = ""
const HorizontalPodAutoscalerSuffix = ""
const JobSuffix = "builder"
const CronJobSuffix = "predicted-traffic"
const PersistentVolumeClaimSuffix = ""
const PodDisruptionBudgetSuffix = ""
const ServiceSuffix = ""
const containerPort = 8002
