# These files are made available at a stable non-digest URL for
# use by the static (/public) error pages or by external sites.
# Files e.g. catalog-autosuggest.js are optionally excluded from being
# precompiled into application.js via stubbing in the application.js
# manifest.

NonStupidDigestAssets.whitelist += [
  "application.css",
  "application.js",
  "autosuggest/index.js",
  "dul_argon/catalog-autosuggest.css"
  ]
