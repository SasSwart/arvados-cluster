---
{% import "./common.sls" as common -%}
letsencrypt:
  domainsets:
    www:
      - hackathon.{{ common.domain }}