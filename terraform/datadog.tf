provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

resource "datadog_monitor_json" "monitor_json" {
  monitor = <<-EOF
{
  "name": "Web Health Check monitor",
  "type": "service check",
  "query": "\"http.can_connect\".over(\"instance:hexlet_devops_study_website\").by(\"*\").last(2).count_by_status()",
  "message": "Host is unhealthy!",
  "tags": [],
  "options": {
    "thresholds": {
      "critical": 1,
      "warning": 1,
      "ok": 1
    },
    "notify_audit": false,
    "notify_no_data": true,
    "no_data_timeframe": 2,
    "renotify_interval": 0,
    "timeout_h": 0,
    "include_tags": false
  }
}
EOF
}
