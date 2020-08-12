---
{% import "./common.sls" as common -%}
letsencrypt:
  domainsets:
    www:
      - workbench.{{ common.domain }}