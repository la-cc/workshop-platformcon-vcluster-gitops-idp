from schema import Schema, Optional, Or

config_schema = Schema({
    "clusters": [
        {
            "project": str,
            Optional("groupRbac", default="replace-org:replae-team"): str,
            Optional("argocd", default="disabled"): Or("enabled", "disabled"),


            "nodePools": [
                {
                    "isolated": bool,
                    Optional("name"): str,
                    Optional("availability_zones", default=["eu01-2"]): list,
                    Optional("machine_type", default="c1.3"): str,
                    Optional("os_version_min", default="4152.2.3"): str,
                    Optional("maximum", default=3): int,
                    Optional("minimum", default=2): int,
                    Optional("taints"): [dict],
                    Optional("labels"): dict,
                }
            ],

        },

    ]
})
