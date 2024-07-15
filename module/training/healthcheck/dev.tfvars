region            = "us-east-1"
environment       = "dev"
name              = "test-health-check"
domain_name       = "divyasf.sourcef.us"
resource_path     = "/index.html"
type              = "HTTPS_STR_MATCH"
measure_latency   = true
alarm_prefix      = "demo"
failure_threshold = 3
request_interval  = 10
search_string     = "My CloudFront Test" // Note:- string with space(eg. "Health API") is not working , it always goes to in-alarm state
alarm_endpoint    = "https://api.opsgenie.com/v1/json/cloudwatch?apiKey=xxxxx-xx-4xxc9c-xx-xxxx"
