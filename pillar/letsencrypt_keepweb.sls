---
{% import "./common.sls" as common -%}
letsencrypt:
  domainsets:
    www:
      - collections.{{ common.domain }}